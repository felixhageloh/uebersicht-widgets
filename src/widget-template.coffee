repoLink = (widget) -> """
  href='#{widget.repoUrl}' title='click for more details'
"""

module.exports = (widget) -> """
  <div id='#{widget.id}' class='widget'>
    <div class='author'>#{widget.author}</div>

    <div class='screenshot'>
      <div class='image'
           style='background-image: url(#{widget.screenshotUrl})'>
      </div>
    </div>

    <div class='info'>
      <h1>#{widget.name}</h1>
      <div class='download-count'></div>
    </div>

    <a class='download' data-id="#{widget.id}" href='#{widget.downloadUrl}' title='download widget'>
      download
    </a>

    <a class='details' data-id="#{widget.id}" #{if widget.repoUrl then repoLink(widget) else ''}>
      <p>#{widget.description}</p>
    </a>
  </div>
"""

