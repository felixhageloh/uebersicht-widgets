# Execute the shell command.
command: "WorldClock.widget/WorldClock.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000

# Render the output.
render: -> """
"""

# Update the rendered output.
update: (output, domEl) ->

  # Get our main DIV.
  div = $(domEl)        

  # Get our timezones and times.
  zones=output.split("\n")

  # Initialize our HTML.
  timeHTML = ''
    
  # Loop through each of the time zones.
  for zone, idx in zones
    
    # If the zone is not empty (e.g. the last newline), let's add it to the HTML.
    if zone != ''
    
      # Split the timezone from the time.
      values = zone.split(";")
      
      # Create the DIVs for each timezone/time. The last item is unique in that we don't want to display the border.
      if idx < zones.length - 2
        timeHTML = timeHTML + "<div class='Wrapper'><div class='Timezone'>" + values[0] + "</div><div class='Time'>" + values[1] + "</div></div>"    
      else
        timeHTML = timeHTML + "<div class='LastWrapper'><div class='Timezone'>" + values[0] + "</div><div class='Time'>" + values[1] + "</div></div>"    
      
  # Set the HTML of our main DIV.
  div.html(timeHTML)

  # Change the location of the border, depending on whether or not the Wrapper DIVs are the same size as the overall DIV (i.e. the display is vertical).
  if div.find('.Wrapper').css('width') == div.css('width')
    div.find('.Wrapper').css({'border-bottom-style':'solid','border-bottom-width':'2px','border-bottom-color':'rgba(0,0,0,0.25)'})
  else
    div.find('.Wrapper').css({'border-right-style':'solid','border-right-width':'2px','border-right-color':'rgba(0,0,0,0.25)'})
  
  
# CSS Style
style: """
  xxwidth:140px
  top: 6pt
  left: 6pt
  font-family: Helvetica Neue
  background:rgba(#000, 0.25)
  border:2px solid rgba(0,0,0,0.15)
  border-radius:10px
  text-align:center
  font-size:11pt
  
  .Wrapper, .LastWrapper
    xxwidth:100%
    display:inline-block
    
  .Timezone
    color: rgba(255,255,255,0.75)
    padding:6px
    padding-bottom:0px
    
  .Time
    color: rgba(255,255,255,0.40)
    padding:6px
    padding-top:0px
"""
