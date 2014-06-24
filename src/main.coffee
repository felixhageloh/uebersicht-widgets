$              = require '../lib/jquery'
WidgetTemplate = require './widget-template.coffee'
downloads      = require './download-counts.coffee'

showDownloadCount = (id) ->
  downloads.get id, (count) ->
    return unless count?
    $("##{id}.widget").find('.download-count')
      .html "<span class='icon'>⬇</span> #{count}︎"

$ ->
  list = $('#widget_list')

  req = $.getJSON 'widgets.json', (data) ->
    widgets = data.widgets
    for widget in widgets when widget
      do (widget) ->
        # newline or space is needed for correct layout
        list.append(WidgetTemplate(widget) + '\n')
        setTimeout -> showDownloadCount(widget.id)

  req.fail (req, _, err) -> console.log err.message

  list.on "click", '.download', (e) ->
    id = $(e.currentTarget).data('id')
    downloads.increment id, ->
      showDownloadCount(id)


