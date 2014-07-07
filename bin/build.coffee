#!/usr/bin/env coffee

GitHubApi   = require '../src/gh.coffee'
fs          = require 'fs'
exec        = require('child_process').exec
credentials = require '../secrets.json'

repo = 'uebersicht-widgets'
gh   = GitHubApi(credentials, repo)

getLastCommit = (callback) ->


getTree = (treeish, args...) ->
  if args.length == 1 or typeof args[0] == 'function'
    callback = args[0]
    options  = ''
  else
    callback = args[1]
    options  = args[0]

  exec "git ls-tree #{options} #{treeish}", (err, output, stderr) ->
    if err or stderr
      console.log(err ? stderr)
      return callback()

    lines = output.split '\n'

    entries = (for line in lines when line
      [mask, type, sha, path] = line.split(/\s+/)
      mask: mask, type: type, sha: sha, path: path
    )

    callback entries


getAndWriteWidgets = (file, tree, callback) ->
  written = 0

  parseEntry = (idx) ->
    return callback() unless (entry = tree[idx])?

    getWidget entry.sha, entry.path, (w) ->
      return parseEntry(idx+1) unless w

      writeWidget file, w, (if written > 0 then ',' else ''), ->
        console.log "  * ", entry.path
        written++
        parseEntry(idx+1)

  parseEntry(0)

getWidget = (sha, path, callback) ->
  getTree sha, (tree) ->
    #return callback() unless tree
    data = parseWidgetDir tree, path

    getManifest data.manifest, (manifest) ->
      #return callback() unless manifest
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

getManifest = (path, callback) ->

  exec "git show master:#{path}", (err, contents, stderr) ->
    if err or stderr
      callback()
    else
      callback JSON.parse(contents)

getModDate = (path, callback) ->
  exec "git log -1 --format=\"%ad\" master -- #{path}", (err, stdout, stderr) ->
    if err or stderr
      console.log err or stderr
      return callback()

    callback new Date(stdout).getTime()

writeWidget = (file, widget, sep, callback) ->
  file.write(sep+JSON.stringify(widget), callback)


pullChanges = (callback) ->
  exec "git checkout master && git pull && git checkout gh-pages", (err, stdout, stderr) ->
    if err
      console.log 'ERROR:', err
    else
      console.log stdout or stderr
      callback()

console.log 'getting widgets'
pullChanges ->

  getTree 'master', '-d', (tree) ->
    file = fs.createWriteStream('widgets.json')
    file.write "{\"widgets\":["

    getAndWriteWidgets file, tree, ->
      file.end "]}"
      console.log 'done'
