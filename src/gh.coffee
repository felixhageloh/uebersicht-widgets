b64     = require './base64.js'
baseUrl = 'https://api.github.com'
reqId   = 0

module.exports = (user, repo) ->
  api = {}

  makeRequest = (url, callback) ->
    callbackName = "ghCallback#{reqId++}"
    script       = document.createElement('script')
    sep          = if url.indexOf('?') > -1 then '&' else '?'
    script.src   = "#{baseUrl}#{url}#{sep}callback=#{callbackName}"

    window[callbackName] = (data) ->
      callback(data.data)
      script.parentNode.removeChild(script)
      delete window[callbackName]

    document.body.appendChild(script)

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



