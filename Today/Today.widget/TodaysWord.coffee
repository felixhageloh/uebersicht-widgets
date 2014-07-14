# Execute the shell command.
command: 'curl -s "http://wordsmith.org/awad/rss1.xml"'

# Set the refresh frequency (milliseconds).
refreshFrequency: 7200000

# Render the output.
render: (output) -> """
  <div id="date"></div>
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

  # Get the title and the description from the item.
  theTitle = theItem.find('title')[0].childNodes[0].data.split(':')
  theDescription = theItem.find('description')[0].childNodes[0].data

  theDate = "Today's Word"
  
  # Output the variables.
  dom.find(date).html(theDate)
  dom.find(title).html(theTitle)
  dom.find(description).html(theDescription)

  # Find the total number of paragraphs in the description.
  parCount = dom.find(description).find('p').length

  # If there is more than one, replace the Description with just the first paragraph
  # and set the footer to reflect that more information is available on the website.
  if parCount > 0
    dom.find(description).html(dom.find(description).find('p')[0])
    dom.find(footer).html('Read ' + parCount + ' more paragraphs at http://www.history.com/this-day-in-history')

# CSS Style
style: """
  top: 400px
  left: 440px
  width:400px
  margin:0px
  padding:0px
  background:rgba(#FFF, 0.5)
  border:2px solid rgba(#000, 0.5)
  border-radius:10px
  overflow:hidden

  #date
    margin:12pt
    margin-bottom:0
    font-family: Helvetica
    font-size: 42pt
    font-weight:bold
    color: rgba(#FFF, 0.75)
  
  #title
    margin-left:12pt
    margin-right:12pt
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
