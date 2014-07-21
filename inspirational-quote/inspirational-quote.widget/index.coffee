command: 'curl -s "http://feeds.feedburner.com/brainyquote/QUOTEBR"'

refreshFrequency: 30000

style: """
  bottom: 0px
  right: 0px
  color: #fff
  font-family: Helvetica Neue


  .output
    padding: 5px 10px
    width: 300px
    font-size: 20px
    font-weight: lighter
	  font-smoothing: antialiased

  .author, .example, .example-meaning
    text-transform: capitalize
    font-size: 14px
  .author
    text-align: right
"""

render: (output) -> """
  <div class="output">
    <div class="quote"></div>
    <div class="author"></div>
  </div>
"""

update: (output, domEl) -> 
  # Define constants, and extract the juicy html.
  dom = $(domEl)
  xml = jQuery.parseXML(output)
  $xml = $(xml)
  description = jQuery.parseHTML($xml.find('description').eq(1).text())
  $description = $(description)

 # Find the info we need, and inject it into the DOM.
  dom.find('.quote').html $xml.find('description').eq(2)
  dom.find('.author').html $xml.find('title').eq(2)

 
