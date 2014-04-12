b64     = require './base64.js'
baseUrl = 'https://api.github.com'
http    = require 'https'

module.exports = (user, repo) ->
  api = {}

  makeRequest = (url, callback) ->
    options =
      hostname: 'api.github.com'
      path    : url
      headers : { 'User-Agent': 'Übersicht-App'}

    http.get options, (res) ->
      str = ''
      res.setEncoding('utf8')
      res.on 'data', (chunk) -> str += chunk
      res.on 'end',  (chunk) ->
        str += chunk if chunk
        callback JSON.parse(str)

  api.get = (url, callback) ->
    makeRequest url, callback

  api.getTree = (sha, callback) ->
    makeRequest "/repos/#{user}/#{repo}/git/trees/#{sha}", (data) ->
      callback data.tree

  api.getContent = (path, callback) ->
    makeRequest "/repos/#{user}/#{repo}/contents/#{path}", (data) ->
      callback b64.decode(data.content)

  api.rawUrl = (path) ->
    "https://raw.githubusercontent.com/#{user}/#{repo}/master/#{path}"

  api



