repoLink = (widget) -> """
  <a class='repo' href='#{widget.repoUrl}' title='view on github'>
    view on github
  </a>
"""

module.exports = (widget) -> """
  <div id='#{widget.id}' class='widget'>
    <div class='screenshot'>
      <div class='image'
           style='background-image: url(#{widget.screenshotUrl})'>
      </div>
    </div>

    <h1>#{widget.name}</h1>
    <p>#{widget.description}</p>

    #{if widget.repoUrl then repoLink(widget) else ''}

    <a class='download' data-id="#{widget.id}" href='#{widget.downloadUrl}' title='download widget'>
      download
    </a>

    <div class='author'>
      by <em>#{widget.author}</em>
      <div class='download-count'></div>
    </div>
  </div>
"""

