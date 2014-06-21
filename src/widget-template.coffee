module.exports = (widget) -> """
  <div class='widget'>
    <div class='screenshot'>
      <div class='image'
           style='background-image: url(#{widget.screenshotUrl})'>
      </div>
    </div>

    <h1>#{widget.name}</h1>
    <p>#{widget.description}</p>

    <a href='#{widget.downloadUrl}'>download</a>

    <div class='author'>
      by <em>#{widget.author}</em>
    </div>
  </div>
"""
