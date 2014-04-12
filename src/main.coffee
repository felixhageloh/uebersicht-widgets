$              = require '../lib/jquery'
WidgetTemplate = require './widget-template.coffee'

$ ->
  list = $('#widget_list')

  req = $.getJSON 'widgets.json', (data) ->
    widgets = data.widgets
    list.append(WidgetTemplate(widget)) for widget in widgets when widget

  req.fail (req, _, err) -> console.log err.message
