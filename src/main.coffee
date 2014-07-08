$              = require '../lib/jquery'
WidgetTemplate = require './widget-template.coffee'
downloads      = require './download-counts.coffee'

listEl         = $('#widget_list')
mainNav        = $('header nav')
installationEl = $('#installation')

allWidgets = {}

init = (widgets) ->
  for widget in widgets when widget
    do (widget) ->
      widget.numDownloads = 0
      allWidgets[widget.id] = widget

      renderWidget widget
      downloads.get widget.id, (count) ->
        widget.numDownloads = count ? 0
        setTimeout -> showDownloadCount(widget)

  registerEvents()

registerEvents = ->
  listEl.on "click", '.download', (e) ->
    id = $(e.currentTarget).data('id')
    downloads.increment id, -> showDownloadCount(allWidgets[id])

  mainNav.on 'click', '.sort a', (e) ->
    e.preventDefault()
    mainNav.find('.active').removeClass('active')
    link = $(e.currentTarget)
    link.addClass('active')
    sortWidgets link.data('sort-by')

  $('[href=#installation]').on 'click', (e) ->
    e.preventDefault()
    installationEl.addClass('visible')

  installationEl.on 'click',  '[data-action=close]', (e) ->
    e.preventDefault()
    installationEl.removeClass('visible')


renderWidget = (widget) ->
  listEl.append(WidgetTemplate(widget))

fetchWidgets = (callback) ->
  req = $.getJSON 'widgets.json', (data) ->
    callback(data.widgets)
  req.fail (req, _, err) -> console.log err.message

showDownloadCount = (widget) ->
  return unless widget.numDownloads
  $("##{widget.id}.widget").find('.download-count')
    .html "<span class='icon'>⬇</span> #{widget.numDownloads}︎"

sortWidgets = (property) ->
  if property == 'name'
    compare = (a, b) ->  a[property].localeCompare(b[property])
  else
    compare = (a, b) -> b[property] - a[property]

  sorted = (w for _, w of allWidgets).sort compare

  widgetEls = listEl.children()

  for widget, i in sorted
    widgetEl = document.getElementById(widget.id)
    listEl[0].insertBefore widgetEl, listEl.children()[i]

fetchWidgets init
