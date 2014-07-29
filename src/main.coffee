$              = require '../lib/jquery'
WidgetTemplate = require './widget-template.coffee'
downloads      = require './download-counts.coffee'

listEl         = $('#widget_list')
mainNav        = $('header nav')
installationEl = $('#installation')

allWidgets = {}

init = (widgets) ->
  widgetEls = []

  for widget in widgets when widget
    do (widget) ->
      widget.numDownloads = 0
      allWidgets[widget.id] = widget

      widgetEls.push(widgetEl = renderWidget widget)
      downloads.get widget.id, (count) ->
        widget.numDownloads = count ? 0
        setTimeout -> showDownloadCount(widget, widgetEl)

  listEl.append(widgetEls)

  setTimeout ->
    registerEvents(widgetEls)
    switchSortBy 'modifiedAt'

registerEvents = (widgetEls) ->
  listEl.on "click", '.download', (e) ->
    id = $(e.currentTarget).data('id')
    downloads.increment id, -> showDownloadCount(allWidgets[id])

  mainNav.on 'click', '.sort a', (e) ->
    e.preventDefault()
    switchSortBy $(e.currentTarget).data('sort-by')

  $('[href=#installation]').on 'click', (e) ->
    e.preventDefault()
    installationEl.addClass('visible')

  installationEl.on 'click',  '[data-action=close]', (e) ->
    e.preventDefault()
    installationEl.removeClass('visible')

renderWidget = (widget) ->
  $(WidgetTemplate(widget))

fetchWidgets = (callback) ->
  req = $.getJSON 'widgets.json', (data) ->
    callback(data.widgets)
  req.fail (req, _, err) -> console.log err.message

showDownloadCount = (widget, widgetEl) ->
  return unless widget.numDownloads
  widgetEl ?= $("##{widget.id}.widget")

  widgetEl.find('.download-count')
    .html "<span class='icon'>⬇</span> #{widget.numDownloads}︎"

switchSortBy = (property) ->
  mainNav.find('.active').removeClass 'active'
  mainNav.find("[data-sort-by=#{property}]").addClass 'active'
  sortWidgets property

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
