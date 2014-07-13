# Execute the shell command.
command: 'curl -s "http://mf.feeds.reuters.com/reuters/UKTopNews"'

# Set the refresh frequency (milliseconds).
refreshFrequency: 300000

# Render the output.
render: (output) -> """
  <div id="heading">Today's News</div>
  <div id="title"></div>
  <div id="description"></div>
  <div id="footer"></div>
"""

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)
  
  # Parse our XML.
  xml = jQuery.parseXML(output)
  $xml = $(xml)
  
  # Get the item we care about.
  theItem = ($xml.find('rss').find('channel').find('item'))
  window.todaysNewsMaxStories = theItem.find('title').length
  window.todaysNewsCurrentStory = 0

  @showStory(theItem,dom,window)
  
  # Set the interval. We store the value in a window variable so we can clear it
  # each time the widget is refreshed.
  clearInterval(window.todaysNewsInterval)
  window.todaysNewsInterval = setInterval (=> @showStory(theItem,dom,window)),10000
 
showStory: (theItem,dom,win)-> 
  
  win.todaysNewsCurrentStory += 1
  if win.todaysNewsCurrentStory > win.todaysNewsMaxStories
    win.todaysNewsCurrentStory = 0

  # Get the title and the description from the item.
  theTitle = theItem.find('title')[win.todaysNewsCurrentStory].childNodes[0].data.split(':')
  theDescription = theItem.find('description')[win.todaysNewsCurrentStory].childNodes[0].data
  theDate = theItem.find('pubDate')[win.todaysNewsCurrentStory].childNodes[0].data

  # Convert the date to the local timezone.
  theDate = new Date(theDate)
  
  # Output the variables.
  dom.find(title).html(theTitle)
  dom.find(description).html(theDescription)
  dom.find(footer).html(theDate + '   (Story ' + win.todaysNewsCurrentStory + ' of ' + win.todaysNewsMaxStories + ')')

  # Trim out the extra information from the description.
  dom.find(description).html(dom.find(description)[0].childNodes[0])
  
# CSS Style
style: """
  top: 20px
  left: 440px
  width:400px
  margin:0px
  padding:0px
  background:rgba(#FFF, 0.5)
  border:2px solid rgba(#000, 0.5)
  border-radius:10px
  overflow:hidden

  #heading
    margin:12pt
    margin-bottom:0
    font-family: Helvetica
    font-size: 42pt
    font-weight:bold
    color: rgba(#FFF, 0.75)
  
  #title
    margin-left:12pt
    margin-right:12pt
    xxmargin-bottom:-10pt
    font-family: American Typewriter
    font-size: 20pt
    font-weight:bold

  #description
    margin-left:12pt
    margin-right:12pt
    font-family: American Typewriter
    font-size: 12pt
    line-height:18pt
    max-height:120pt
    overflow:hidden
    hyphens: auto
    
  #footer
    font-family: Helvetica
    font-size: 9pt
    margin:12pt
    color: rgba(#000, 0.5)
"""
