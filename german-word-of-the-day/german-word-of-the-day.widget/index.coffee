command: 'curl -s "http://feeds.feedblitz.com/german-word-of-the-day"'

refreshFrequency: 3600000

style: """
  top: 40px
  left: 0px
  color: #fff

  .output
    padding: 5px 10px
    font-family: Helvetica Neue
    font-size: 30px
    font-weight: 100
    text-shadow: 0 0px 5px #000000;
    background-color: rgba(0,0,0,0.15)
    
  .word, .part, .example, .example-meaning
    text-transform:capitalize
    font-size: 20px
"""

render: (output) -> """
  <div class="output">
    <div class="title">German word of the day</div>
    <div class="word"></div>
    <div class="part"></div>
    <div class="example"></div>
    <div class="example-meaning"></div>
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
  dom.find('.word').html $xml.find('title').eq(1)
  part = $description.find('td').eq(0).text()
  dom.find('.part').html "Part of speech: #{part}"
  example = $description.find('td').eq(1).text()
  dom.find('.example').html "Example sentence: #{example}"
  exampleMeaning = $description.find('td').eq(2).text()
  dom.find('.example-meaning').html "Sentence meaning: #{exampleMeaning}"

  # Position the DOM in the middle of our screen.
  # NOTE: this is optional. Adjust as you like.
  domWidth = dom.width()
  frameWidth = $(window).width()
  dom.css('left',((frameWidth)/2)-(domWidth/2))
