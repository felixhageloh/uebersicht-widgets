GH   = require './gh.coffee'

user = 'felixhageloh'
repo = 'uebersicht-widgets'
gh   = GH(user, repo)

getLastCommit = (callback) ->
  gh.get "/repos/#{user}/#{repo}/git/refs/heads/master", (data) ->
    callback data.object.sha

getAndRenderWidgets = (tree) ->
  for entry in tree
    continue unless entry.type == 'tree'
    getWidget entry.sha, entry.path, renderWidget

getWidget = (sha, path, callback) ->
  widget = {}

  parseEntry = (entry) ->
    widget.screenshot = path+'/'+entry.path  if entry.path.indexOf('screenshot') > -1
    widget.manifest   = path+'/'+entry.path if entry.path.indexOf('widget.json') > -1

  getManifest = (path, callback) ->
    gh.getContent path, (manifest) ->
      manifest           = JSON.parse(manifest)
      widget.name        = manifest.name
      widget.description = manifest.description
      callback widget

  gh.getTree sha, (tree) ->
    parseEntry(entry) for entry in tree
    getManifest widget.manifest, callback

renderWidget = (widget) ->
  $(document.body).append widgetTemplate(widget)

widgetTemplate = (widget) -> """
  <div style='border: 1px solid #ccc'>
    <p>#{widget.name}</p>
    <p>#{widget.description}</p>
    <img src='#{gh.rawUrl widget.screenshot}'/>
  </div>
"""


$ ->
  getLastCommit (sha) -> gh.getTree sha, getAndRenderWidgets
