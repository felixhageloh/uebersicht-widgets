$  = require '../lib/jquery'
H  = require './widget-details-template.coffee'

module.exports = (domEl) ->
  api = {}

  apiURL    = "https://api.github.com"
  callbacks =
    onClose: []

  init = ->
    domEl.on 'click', (e) ->
      api.hide() if e.target == domEl[0]

    api

  api.render = (widget) ->
    domEl.html H(widget)

    readmeEl = domEl.find '.readme'
    getReadme widget, (err, html) ->
      throw err if err
      readmeEl.html html

  api.show = ->
    domEl.addClass 'active'

  api.hide = ->
    domEl.removeClass 'active'
    cb() for cb in callbacks.onClose

  api.onClose = (cb) ->
    callbacks.onClose.push cb

  getReadme = (widget, callback) ->
    $.ajax
      url    : "#{apiURL}/repos/#{widget.user}/#{widget.repo}/readme"
      method : 'GET'
      headers:
        Accept: 'application/vnd.github.html'
      success: (html) -> callback(null, html)

  init()
