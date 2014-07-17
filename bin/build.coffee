#!/usr/bin/env coffee

fs    = require 'fs'
exec  = require('child_process').exec
chalk = require('chalk')

baseRepo = "https://github.com/felixhageloh/uebersicht-widgets"

build = ->
  console.log 'getting widgets'
  pullChanges ->
    getTree 'master', (tree) ->
      file = fs.createWriteStream('widgets.json')
      file.write "{\"widgets\":["

      getAndWriteWidgets tree, file, ->
        file.end "]}"
        console.log chalk.green 'done'

getAndWriteWidgets = (dirTree, outfile, callback) ->
  written = 0

  writeAndNext = (idx, next) -> (w) ->
    return next(idx+1) unless w

    writeWidget outfile, w, (if written > 0 then ',' else ''), ->
      console.log chalk.green "ok"
      written++
      next idx+1

  parseDirEntry = (idx) ->
    return callback() unless (entry = dirTree[idx])?

    if entry.mask == '160000'
      buildWidget 'master', '.', cwd: entry.path, writeAndNext(idx, parseDirEntry)
    else if entry.type == 'tree'
      buildWidget entry.sha, entry.path, {}, writeAndNext(idx, parseDirEntry)
    else
      parseDirEntry(idx+1)

  parseDirEntry(0)

buildWidget = (sha, path, options, callback) ->
  manifest = null
  modDate  = null
  urls     = null

  widgetId = options.cwd ? path

  process.stdout.write chalk.blue(" » ") + widgetId + ' .. '

  bail = (reason) ->
    console.log chalk.red "fail"
    console.log chalk.red "   " + reason
    callback()

  combineData = ->
    return unless manifest and modDate and urls
    callback
      id            : widgetId
      name          : manifest.name
      author        : manifest.author
      description   : manifest.description
      screenshotUrl : urls.screenshotUrl
      downloadUrl   : urls.downloadUrl
      repoUrl       : if urls.repoUrl == baseRepo then null else urls.repoUrl
      modifiedAt    : modDate

  getTree sha, options, (widgetDir) ->
    return bail "could not read widget dir" unless widgetDir
    paths = parseWidgetDir widgetDir

    return bail "could not find screenshot" unless paths.screenshotPath
    return bail "could not find manifest"   unless paths.manifestPath
    return bail "could not find zip file"   unless paths.zipPath

    getUserRepo options, (user, repo) ->
      return bail "could not retrieve repo info" unless user and repo
      urls =
        downloadUrl  : ghRawUrl user, repo, "#{path}/#{paths.zipPath}"
        screenshotUrl: ghRawUrl user, repo, "#{path}/#{paths.screenshotPath}"
        repoUrl      : ghUrl user, repo
      combineData()

    getModDate "#{path}/#{paths.zipPath}", options, (date) ->
      return bail "could not get last mod date" unless date
      modDate = date
      combineData()

    getManifest "#{path}/#{paths.manifestPath}", options, (man) ->
      return bail "could not read manifest" unless man
      manifest = man
      combineData()

parseWidgetDir = (dirTree, dirPath) ->
  paths = {}

  for entry in dirTree
    if entry.path.indexOf('widget.json') > -1
      paths.manifestPath = entry.path
    else if entry.path.indexOf('screenshot') > -1
      paths.screenshotPath = entry.path
    else if entry.path.indexOf('.widget.zip') > -1
      paths.zipPath  = entry.path

  paths

getManifest = (path, options, callback) ->
  saveExec "git show master:#{path}", options, (contents) ->
    callback JSON.parse(contents ? 'null')

getModDate = (path, options, callback) ->
  saveExec "git log -1 --format=\"%ad\" master -- #{path}", options, (stdout) ->
    return callback() unless stdout
    callback new Date(stdout).getTime()

getUserRepo = (options, callback) ->
  saveExec "git remote -v | tail -n 1", options, (stdout) ->
    return callback() unless stdout

    [junk, userAndRepo] = stdout.split(/\s/)[1].split('github.com:')
    [user, repo]        = userAndRepo.split('/')
    callback user, repo.replace(/\.git$/g, '')

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

ghRawUrl = (user, repo, path) ->
  "https://raw.githubusercontent.com/#{user}/#{repo}/master/#{path}"

ghUrl = (user, repo) ->
  "https://github.com/#{user}/#{repo}"

saveExec = (cmd, options, callback) ->
  exec cmd, options, (err, output, stderr) ->
    if err or stderr
      console.log(err ? stderr)
      callback()
    else
      callback(output)

build()
