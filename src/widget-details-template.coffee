repoLink = (widget) -> """
  href='#{widget.repoUrl}' title='click for more details'
"""

module.exports = (widget) -> """
  <div class='back-cover'>
    <img src="#{widget.screenshotUrl}"/>
  </div>

  <div class='content'>
    <div class='details'>
      <h1>#{widget.name}</h1>

      <nav>
        <a class='download' data-id="#{widget.id}" href='#{widget.downloadUrl}' title='download widget'>
          download
        </a>

        <a class='close' title='close'>✕</a>
      </nav>

      <p class='description'>#{widget.description}</p>
      <img src="#{widget.screenshotUrl}"/>

      <p>by <em>#{widget.author}</em></p>

      <a class='github' #{if widget.repoUrl then repoLink(widget) else ''}>
        View on GitHub.
      </a>
    </div>

    <div class='readme-wrapper'>
      <div class='readme'></div>
    </div>
  </div>
"""
