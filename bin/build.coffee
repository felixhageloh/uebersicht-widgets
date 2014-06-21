#!/usr/bin/env coffee

GitHubApi   = require '../src/gh.coffee'
fs          = require 'fs'
credentials = require '../secrets.json'

repo = 'uebersicht-widgets'
gh   = GitHubApi(credentials, repo)

getLastCommit = (callback) ->
  gh.get "/repos/#{credentials.user}/#{repo}/git/refs/heads/master", (data) ->
    return console.log "no object in", data unless data.object
    callback data.object.sha

getAndWriteWidgets = (tree, callback) ->
  done    = 0
  written = 0

  for entry in tree
    if entry.type != 'tree'
      done++
      continue

    getWidget entry.sha, entry.path, (w) ->
      process.stdout.write(".")
      writeWidget w, (if written > 0 then ',' else ''), ->
        done++
        written++
        callback() if done == tree.length

getWidget = (sha, path, callback) ->
  widget = {}

  parseEntry = (entry) ->
    if entry.path.indexOf('screenshot') > -1
      widget.screenshotUrl = gh.rawUrl path+'/'+entry.path

    if entry.path.indexOf('widget.json') > -1
      widget.manifest = path+'/'+entry.path

    if entry.path.indexOf('.widget.zip') > -1
      widget.downloadUrl = gh.rawUrl path+'/'+entry.path

  getManifest = (path, callback) ->
    gh.getContent path, (manifest) ->
      manifest           = JSON.parse(manifest)
      widget.name        = manifest.name
      widget.author      = manifest.author
      widget.description = manifest.description
      callback widget

  gh.getTree sha, (tree) ->
    parseEntry(entry) for entry in tree
    getManifest widget.manifest, callback

writeWidget = (widget, sep, callback) ->
  file.write(sep+JSON.stringify(widget), callback)


file = fs.createWriteStream('widgets.json')
file.write "{\"widgets\":["

console.log 'getting widgets'
getLastCommit (sha) -> gh.getTree sha, (tree) ->
  getAndWriteWidgets tree, ->
    file.end "]}"
    console.log 'done'
