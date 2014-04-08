gh   = require('./gh.coffee')
repo = '/repos/felixhageloh/uebersicht/git'

getLastCommit = (callback) ->
  gh.get "#{repo}/refs/heads/master", (data) ->
    callback data.object.sha

getTree = (sha, callback) ->
  gh.get "#{repo}/trees/#{sha}?recursive=1", (data) ->
    console.debug data
    callback data.tree

renderTree = (tree) ->
  for entry in tree
    $(document.body).append "<p>#{entry.path}</p>"

$ ->
  getLastCommit (sha) -> getTree sha, renderTree
