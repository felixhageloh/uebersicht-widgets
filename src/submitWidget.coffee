getWidget = require './getWidget.js'
$ = require '../lib/jquery'

module.exports = submitWidget = (e) ->
  e.preventDefault()
  form = e.target
  form.elements['submit'].disabled = true
  handleSubmitProgress({})
  $('#submit_progress').show()
  $('#submit_success').hide()
  $('#submit_error').html('')
  getWidget(form.elements['repo-url'].value, handleSubmitProgress)
    .then (widgetData) -> handleSubmitSuccess(widgetData)
    .catch (err) -> handleSubmitError(err)
    .then -> form.elements['submit'].disabled = false

handleSubmitProgress = (progress) ->
  $('#checks #repo_found').toggleClass('success', !!progress.repoFound)
  $('#checks #repo_valid').toggleClass('success', !!progress.repoValid)
  $('#checks #manifest').toggleClass('success', !!progress.manifest)

handleSubmitSuccess = (widgetData) -> new Promise (resolve) ->
  setTimeout ->
    $('#submit_success a').html("Request '#{widgetData.name}' to be added")
    $('#submit_success a')[0].search =
      "title=New widget: #{encodeURIComponent(widgetData.name)}" +
      '&body=Please add this widget to the gallery: ' +
      encodeURIComponent(widgetData.repoUrl)
    $('#submit_success').show()
    $('#submit_progress').hide()
    resolve()
  , 1000

handleSubmitError = (errors) -> new Promise (resolve) ->
  $('#checks #repo_found').toggleClass('error', !!errors.repoFound)
  $('#checks #repo_valid').toggleClass('error', !!errors.repoValid)
  $('#checks #manifest').toggleClass('error', !!errors.manifest)
  setTimeout ->
    $('#submit_progress').hide()
    renderErrorExplanation(errors)
    resolve()
  , 1000

renderErrorExplanation = (errors) ->
  return renderRepoNotFoundExplanation(errors.error) if !!errors.repoFound
  return renderInvalidRepoExplanation(errors.error) if !!errors.repoValid
  return renderInvalidManifestExplanation(errors.error) if !!errors.manifest

renderRepoNotFoundExplanation = (error) ->
  $('#submit_error').html """
    <h2>Repo Not Found</h2>
    <p>Please make sure you entered a valid repo URL</p>
  """




