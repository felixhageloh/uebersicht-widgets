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
    $('#submit_success a').html("Submit '#{widgetData.name}' for review")
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

renderInvalidRepoExplanation = (error) ->
  $('#submit_error').html """
    <h2>Please fix the follwing issues with your repo</h2>
    <ul>
    #{error.screenshot &&
      "<li>
        Missing screenshot.<br/>
        Please add a screenshot named <code>screenshot.png</code>
      </li>
    "}
    #{error.zip &&
      "<li>
        Missing zip file.<br/>
        Please add a zip file named <code>&lt;widget-name&gt.widget.zip</code>,
        containing your widget.
      </li>
    "}
    #{error.manifest &&
      "<li>
        Missing manifest file.<br/>
        Please add a JSON file named <code>widget.json</code> describing your
        widget.
      </li>
    "}
    </ul>
  """

renderInvalidManifestExplanation = (error) ->
  $('#submit_error').html """
    <h2>Invalid manifest file</h2>
    <p>Error: #{error}</p>
    <p>Please ensure your manifest file is valid JSON and has the following format:</p>
    <pre><code>{
      "name": "name of your widget",
      "description": "a short(!) description",
      "author": "your name",
      "email": "your email address"
    }</code></pre>
  """
