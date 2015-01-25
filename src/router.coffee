module.exports = (onStateChange) ->
  api     = {}
  baseUrl = null

  init = ->
    baseUrl = window.location.href.replace(initialPath(), '')

    window.addEventListener 'hashchange', (e) ->
      onStateChange currentState()

    api

  api.navigate = (widget) ->
    changeState widget

  api.activate = ->
    onStateChange currentState(), true

  initialPath = ->
    return window.location.hash if window.location.hash

  changeState = (widget) ->
    hash = generateHash(widget) || baseUrl

    if window.history.replaceState
      window.history.replaceState null, null, hash
      onStateChange widget?.id
    else
      window.location.hash = hash

  generateHash = (widget) ->
    if widget then "##{widget.id}" else ''

  currentState = ->
    window.location.hash.replace('#', '')

  init()
