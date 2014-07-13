# Execute the shell command.
command: ''

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000

# CSS Style
style: """
  top:40px
  left:40px
  margin:0px
  padding:0px
  height:200px
  width:200px
  
  #clockImage
    position:absolute
    width:100%
    height:100%
    content: url('SimpleAnalogClock.widget/Faces/MinimalWhite.png')
    z-index:-1

  #clockCanvas
    position:absolute
    width:100%
    height:100%

  #secondHand
    width:2.5%
    height:40%
    background-color: rgba(255,0,0,0.75)
    border-style:solid
    border-color: rgba(0,0,0,.75)
    border-width: 1px

  #minuteHand
    width:3.5%
    height:35%
    background-color: rgba(0,0,0,0.75)
    border-style:solid
    border-color: rgba(0,0,0,1)
    border-width: 1px

  #hourHand
    width:3.5%
    height:25%
    background-color: rgba(0,0,0,0.75)
    border-style:solid
    border-color: rgba(0,0,0,1)
    border-width: 1px

  #frame
    width:4%
    border-color: rgba(0,0,0,1)
 
"""

# Render the output.
render: (output) -> """
  <canvas id="clockCanvas"></canvas>
  <img id="clockImage"/>
  <p id="secondHand"/>
  <p id="minuteHand"/>
  <p id="hourHand"/>
  <p id="frame"/>
"""

# Update the rendered output.
update: (output, domEl) ->

  # Get a reference to our DOM.
  dom = $(domEl)

  # Get the local date.
  theDate = new Date()
  
  # Get a reference to our canvas.
  cvs = dom.find(clockCanvas)[0]

  # Set the height and width of the canvas to that of the DOM. This will assure that
  # the scale of the objects is correct. Note: This also has the effect of clearing
  # the canvas, so we don't need to specifically call clearRect.
  cvs.height = dom.height()
  cvs.width = dom.width()
  
  # Get our Context and translate it to make the center point of the Canvas our origin.
  context = cvs.getContext('2d')
  context.translate(cvs.width/2, cvs.height/2)

  # Draw the clock.
  @drawHand(context,dom.find(secondHand),@degreesToRadians(theDate.getSeconds() * 6-180),'Overlapping')
  @drawHand(context,dom.find(minuteHand),@degreesToRadians((theDate.getMinutes() + theDate.getSeconds() / 60) * 6 - 180),'Overlapping')
  @drawHand(context,dom.find(hourHand),@degreesToRadians(((theDate.getHours() + theDate.getMinutes() / 60) * 360 / 12) % 360 - 180),'Overlapping')
  @drawFrame(context,cvs.width,dom.find(frame))

drawHand: (context,object,radians,handType) ->

  # Hide the object. It's only used as a placeholder for the CSS measurements.
  object.css('display','none')
  
  # Get the height and with from the object. These are used to determine the size of the hands.
  width = object.width()
  height = object.height()
  
  # Save our context.
  context.save()
  
  # Rotate the canvas the appropriate number of degrees. This makes the drawing of the hand much easier.
  context.rotate(radians)

  # Draw the hand.
  context.beginPath()

  if handType == 'Rounded'
    # This must be fixed to use the new rotation.
    context.arc(0, 0, width, @degreesToRadians(180), @degreesToRadians(360),false);
    context.moveTo(width,0)
    context.lineTo(0,height)
    context.lineTo(width*-1,0)  
  else if handType == 'Overlapping'
    context.moveTo(width/2,height * -0.2)
    context.lineTo(0,height)
    context.lineTo(width/-2,height * -0.2)
    context.lineTo(width/2,height * -0.2)

  # Fill the hand.
  context.fillStyle = object.css('background-color')
  context.fill()

  # Outline the hand if the border-style is set.
  if object.css('border-style') != 'none'
    context.strokeStyle = object.css('border-color')
    context.lineWidth = @getCSSValue(object.css('border-width'))
    context.stroke()
      
  # Restore our context.
  context.restore()

drawFrame: (context,width,object) ->

  # Hide the object. It's only used as a placeholder for the CSS measurements.
  object.css('display','none')

  # Save our context.
  context.save()
  
  # Draw the frame.
  context.beginPath()
  context.arc(0, 0, width/2, 0, 2 * Math.PI, true)  
  context.arc(0, 0, (width - object.width())/2, 0, 2 * Math.PI, false)  
  
  # Fill the frame.
  context.fillStyle = object.css('border-color')
  context.fill()
  
  # Restore our context.
  context.restore()

degreesToRadians: (degrees) ->
  # Convert degrees to radians.
  (Math.PI / 180) * (degrees)

getCSSValue: (valueString) ->
  # Extract just the numbers from the string.
  value = valueString.match('[0-9]+')
  value