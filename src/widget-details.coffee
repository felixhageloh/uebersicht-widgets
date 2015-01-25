$  = require '../lib/jquery'
H  = require './widget-details-template.coffee'

module.exports = (domEl) ->
  api = {}

  apiURL    = "https://api.github.com"
  current   = null
  callbacks =
    onClose: []

  nexFrame = requestAnimationFrame ?
             webkitRequestAnimationFrame ?
             mozRequestAnimationFrame ?
             setTimeout

  init = ->
    domEl.on 'click', (e) ->
      api.hide() if e.target == domEl[0]

    domEl.on 'click', 'a.close', (e) ->
      api.hide()

    api

  api.render = (widget) ->
    current = widget
    domEl.html H(widget)

    readmeEl = domEl.find '.readme'
    getReadme widget, (err, html) ->
      return readmeEl.html "No README available." if err
      el = $(html)
      fixLinks(el, widget)
      nexFrame -> readmeEl.html el

  api.show = (cb) ->
    domEl.show()
    nexFrame ->
      domEl.addClass 'active'
      cb()

  api.hide = ->
    domEl
      .removeClass 'active'
      .hide()
    cb(current) for cb in callbacks.onClose

  api.onClose = (cb) ->
    callbacks.onClose.push cb

  getReadme = (widget, callback) ->
    return callback("old widget") if widget.repo == "uebersicht-widgets"

    $.ajax
      url    : "#{apiURL}/repos/#{widget.user}/#{widget.repo}/readme"
      method : 'GET'
      headers:
        Accept: 'application/vnd.github.html'
      success: (html)   -> callback(null, html)
      error  : (_, err) -> callback(err)

  fixLinks = (el, widget) ->
    for img in el.find('img')
      url = img.getAttribute('src')
      continue if isAbsoluteUrl(url)
      img.src = absoluteImgUrl(widget, url)

    for a in el.find('a')
      url = a.getAttribute('href')
      continue if isAbsoluteUrl(url)
      a.href = absoluteImgUrl(widget, url)

  isAbsoluteUrl = (url) ->
    /^http/.test(url) or /^\/\//.test(url)

  absoluteImgUrl = (widget, url) ->
    "https://raw.githubusercontent.com/#{widget.user}/#{widget.repo}/master/#{url}"

  init()
