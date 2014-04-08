baseUrl = 'https://api.github.com'
reqId   = 0

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

exports.get = (url, callback) ->
  makeRequest url, callback



