#!/usr/bin/env coffee

GitHubApi   = require '../src/gh.coffee'
fs          = require 'fs'
exec        = require('child_process').exec
credentials = require '../secrets.json'

repo = 'uebersicht-widgets'
gh   = GitHubApi(credentials, repo)

getTree = (treeish, args...) ->
  if args.length == 1 or typeof args[0] == 'function'
    callback = args[0]
    options  = {}
  else
    callback = args[1]
    options  = args[0] ? {}

  saveExec "git ls-tree #{treeish}", options, (output) ->
    callback() unless output
    lines = output.split '\n'

    entries = (for line in lines when line
      [mask, type, sha, path] = line.split(/\s+/)
      mask: mask, type: type, sha: sha, path: path
    )

    callback entries

getAndWriteWidgets = (file, tree, callback) ->
  written = 0

  doWrite = (w, cb) ->
    writeWidget file, w, (if written > 0 then ',' else ''), ->
      console.log "  * ", w.id
      written++
      cb()

  parseEntry = (idx) ->
    return callback() unless (entry = tree[idx])?

    if entry.mask == '160000'
      getWidget 'master', '.', cwd: entry.path, (w) ->
        return parseEntry(idx+1) unless w
        doWrite w, -> parseEntry(idx+1)
    else if entry.type == 'tree'
      getWidget entry.sha, entry.path, {}, (w) ->
        return parseEntry(idx+1) unless w
        doWrite w, -> parseEntry(idx+1)
    else
      parseEntry(idx+1)

  parseEntry(0)

getWidget = (sha, path, options, callback) ->
  getTree sha, options, (tree) ->
    return callback() unless tree
    data = parseWidgetDir tree, path

    getUserRepo options, (user, repo) ->
      console.debug user, repo
      getManifest data.manifest, options, (manifest) ->
        return callback() unless manifest
        getModDate path+'/'+data.zipPath, (date) ->
          callback
            id            : path
            name          : manifest.name
            author        : manifest.author
            description   : manifest.description
            screenshotUrl : data.screenshotUrl
            downloadUrl   : data.downloadUrl
            modifiedAt    : date


parseWidgetDir = (dirTree, dirPath) ->
  data = {}

  for entry in dirTree
    if entry.path.indexOf('widget.json') > -1
      data.manifest = dirPath+'/'+entry.path
    else if entry.path.indexOf('screenshot') > -1
      data.screenshotUrl = gh.rawUrl dirPath+'/'+entry.path
    else if entry.path.indexOf('.widget.zip') > -1
      data.zipPath     = entry.path
      data.downloadUrl = gh.rawUrl dirPath+'/'+entry.path

  data

getManifest = (path, options, callback) ->
  saveExec "git show master:#{path}", options, (contents) ->
    callback JSON.parse(contents ? 'null')

getModDate = (path, callback) ->
  saveExec "git log -1 --format=\"%ad\" master -- #{path}", {}, (stdout) ->
    return callback() unless stdout
    callback new Date(stdout).getTime()

getUserRepo = (options, callback) ->
  saveExec "git remote -v | tail -n 1", (stdout) ->
    return callback() unless stdout

    [junk, userAndRepo] = stdout.split('github.com:')
    [user, repo]        = userAndRepo.split('/')
    callback user, repo.replace(/\.git.*/, '')

writeWidget = (file, widget, sep, callback) ->
  file.write(sep+JSON.stringify(widget), callback)

pullChanges = (callback) ->
  cmd = "git checkout master && \
         git pull --recurse-submodules && \
         git submodule update --recursive && \
         git checkout gh-pages"

  exec cmd, (err, stdout, stderr) ->
    if err
      console.log 'ERROR:', err
    else
      console.log stdout or stderr
      callback()

saveExec = (cmd, options, callback) ->
  exec cmd, options, (err, output, stderr) ->
    if err or stderr
      console.log(err ? stderr)
      callback()
    else
      callback(output)


console.log 'getting widgets'
pullChanges ->
  getTree 'master', (tree) ->
    file = fs.createWriteStream('widgets.json')
    file.write "{\"widgets\":["

    getAndWriteWidgets file, tree, ->
      file.end "]}"
      console.log 'done'
