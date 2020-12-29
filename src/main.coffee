$ = require '../lib/jquery'
WidgetTemplate = require './widget-template.coffee'
downloads = require './download-counts.coffee'
WidgetDetails = require './widget-details.coffee'
Router = require './router.coffee'
submitWidget = require './submitWidget.coffee'

listEl = $('#widget_list')
mainNav = $('header nav')
installationEl = $('#installation')
router = null
lastScroll = null

allWidgets    = {}
widgetDetails = WidgetDetails($('#widget_details'))

init = (widgets) ->
  widgetEls = []

  router = Router goToState

  handleIntersection = (entries, observer) -> requestAnimationFrame ->
    entries.forEach (entry) ->
      return unless entry.isIntersecting
      entry.target.classList.add("visible");
      observer.unobserve(entry.target)

  observer = new IntersectionObserver(handleIntersection);

  for widget in widgets when widget
    do (widget) ->
      widget.numDownloads = 0
      widget.id = widget.id.replace(/\./g, '_')
      allWidgets[widget.id] = widget

      widgetEls.push(widgetEl = renderWidget widget)
      observer.observe(widgetEl[0])
      downloads.get widget.id, (count) ->
        widget.numDownloads = count ? 0
        setTimeout -> showDownloadCount(widget, widgetEl)

  listEl.append(widgetEls)

  setTimeout ->
    registerEvents(widgetEls)
    switchSortBy 'modifiedAt'
    setTimeout router.activate


registerEvents = (widgetEls) ->

  widgetDetails.onClose -> router.navigate()

  $(document).on "click", '.download', (e) -> setTimeout ->
    id = $(e.currentTarget).data('id')
    downloads.increment id, (newCount) ->
      widget = allWidgets[id]
      widget.numDownloads = newCount
      showDownloadCount(widget)

  listEl.on "click", '.details', (e) ->
    e.preventDefault()
    id = $(e.currentTarget).data('id')
    router.navigate allWidgets[id]

  mainNav.on 'click', '.sort a', (e) ->
    e.preventDefault()
    widgetDetails.hide()
    switchSortBy $(e.currentTarget).data('sort-by')

  $('[href=#installation]').on 'click', (e) ->
    e.preventDefault()
    $('.drawer').removeClass('visible')
    installationEl.addClass('visible')
    $(document.body).css overflow: 'hidden'

  $('[href=#submit]').on 'click', (e) ->
    e.preventDefault()
    $('.drawer').removeClass('visible')
    $('#submit').addClass('visible')
    $(document.body).css overflow: 'hidden'

  $('[href=#disclaimer]').on 'click', (e) ->
    widgetDetails.hide()

  document.addEventListener 'keydown', (e) ->
    widgetDetails.hide() if e.which == 27

  $('.drawer').on 'click',  '[data-action=close]', (e) ->
    e.preventDefault()
    $('.drawer').removeClass('visible', 'active')
    $(document.body).css overflow: 'auto'

  $('.drawer').on 'transitionend', ->
    $('.drawer').toggleClass('active', $('.drawer').is('.visible'))

  $('#submit_form').on 'submit', submitWidget


goToState = (id, initial = false) ->
  widget = allWidgets[id]
  scrollToWidget widget if initial and widget
  showWidget widget

showWidget = (widget) ->
  if widget
    lastScroll = document.body.scrollTop
    widgetDetails.render(widget)
    widgetDetails.show ->
      $(document.body).css overflow: 'hidden'
      $('header').css background: '#fff'
  else
    $(document.body).css overflow: 'auto'
    $('header').css background: ''
    setTimeout ->
      document.body.scrollTop = lastScroll if lastScroll

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

scrollToWidget = (widget) ->
  headerHeight = $('header').height()
  window.scrollTo 0, $('#'+widget.id).offset()?.top - headerHeight



fetchWidgets init
