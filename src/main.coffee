$              = require '../lib/jquery'
WidgetTemplate = require './widget-template.coffee'

$ ->
  list = $('#widget_list')

  req = $.getJSON 'widgets.json', (data) ->
    widgets = data.widgets
    # newline or space is needed for correct layout
    list.append(WidgetTemplate(widget) + '\n') for widget in widgets when widget

  req.fail (req, _, err) -> console.log err.message

  list.on "click", '.download', (e) ->
    id = $(e.currentTarget).data('id')
    ga('send', 'event', 'download-link', 'click', id)
