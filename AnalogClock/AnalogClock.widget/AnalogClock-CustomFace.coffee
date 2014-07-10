# Execute the shell command.
command: 'export TZ="US/Central";date +"%m/%d/%Y %I:%M:%S %p"'

# Set the refresh frequency (milliseconds).
refreshFrequency: 1000

# CSS Style
style: """
  top:40px
  left:40px
  margin:0px
  padding:0px
  
  #clockImage
    z-index:-1
    display:none
    
  #clockLabel
    display:none
"""

# Render the output.
render: (output) -> """
  <canvas id="clockCanvas" width="100" height="100"></canvas>
  <img id="clockImage"/>
  <div id="clockLabel"></div>
"""

# Update the rendered output.
update: (output, domEl) ->

  # Get a reference to our DOM.
  dom = $(domEl)

  # Convert the date from the output to a Javascript date.
  # We do this (rather than using Javascript dates) so that we can use Unix timezones.
  theDate = new Date(output)
  
  # Set our clock settings.
  Clock =
    size: 100
    scale: 2
    showFace: false
    showFaceImage: true
    showHourTicks: true
    showMinuteTicks: true
    showFrame: true
    showHourHand: true
    showMinuteHand: true
    showSecondHand: true
    showHandCover: true
    showLabel: false
    
  # This measurement is used frequently below.
  ClockRadius = (Clock.size * Clock.scale / 2)
      
  Face = 
    radius: ClockRadius
    fillColor: "rgba(0,0,0,0.25)"
    
  FaceImage = 
    imageObject: dom.find(clockImage)[0]
    width: Clock.size * Clock.scale
    height: Clock.size * Clock.scale
    filename: "AnalogClock.widget/Faces/ClockFace.png"
    
  MinuteTicks = 
    outerRadius: ClockRadius
    innerRadius: ClockRadius - Clock.scale * 4
    degrees: 6
    lineWidth: 1
    strokeColor: "rgba(255,255,255,0.5)"

  HourTicks = 
    outerRadius: ClockRadius
    innerRadius: ClockRadius - Clock.scale * 4
    degrees: 30
    lineWidth: 4
    strokeColor: "rgba(255,255,255,1)"

  Frame = 
    outerRadius: ClockRadius
    innerRadius: ClockRadius - Clock.scale * 2
    fillColor: "rgba(0,0,0,1)"
    
  SecondHand = 
    length: ClockRadius * 0.75
    width: 1
    fillColor: "rgba(255,0,0,1)"
    strokeColor: "rgba(0,0,0,0.5)"
    lineWidth:0
    shadowOffset: 2
    shadowColor: "rgba(0,0,0,0.75)"
    shadowBlur: 2
    degrees: @degreesToRadians(theDate.getSeconds() * 6)
    
  MinuteHand = 
    length: ClockRadius * 0.75
    width: 1.5
    fillColor: "rgba(0,0,0,1)"
    strokeColor: "rgba(255,255,255,1)"
    lineWidth:0
    shadowOffset: 2
    shadowColor: "rgba(0,0,0,0.75)"
    shadowBlur: 2
    degrees: @degreesToRadians((theDate.getMinutes() + theDate.getSeconds() / 60) * 6)
    
  HourHand = 
    length: ClockRadius * 0.55
    width: 1.5
    fillColor: "rgba(0,0,0,1)"
    strokeColor: "rgba(255,255,255,1)"
    lineWidth:0
    shadowOffset: 2
    shadowColor: "rgba(0,0,0,0.75)"
    shadowBlur: 2
    degrees: @degreesToRadians(((theDate.getHours() + theDate.getMinutes() / 60) * 360 / 12) % 360)

  HandCover =
    radius: HourHand.width * 2
    lineWidth: 0
    fillColor: "rgba(0,0,0,1)"
    strokeColor: "rgba(0,0,0,1)"

  Label =
    labelObject: $(dom.find(clockLabel)[0])
    text: "Central US"
    fontFamily: "Helvetica Neue"
    fontSize: "6pt"
    color: "rgba(255,255,255,0.5)"
    textAlign: "center"
    background: "rgba(0,0,0,0.125)"
    borderColor: "rgba(0,0,0,.125)"
    borderWidth: "1px"
    borderRadius: "20px"
  
  # Get a reference to our canvas.
  cvs = dom.find(clockCanvas)[0]
  
  # Set our scale.
  cvs.width = Clock.size * Clock.scale
  cvs.height = Clock.size * Clock.scale
  
  # Get our Context and translate it to make the center point of the Canvas our origin.
  # Clear the entire canvas each time we run through this.
  context = cvs.getContext('2d')
  context.translate(cvs.width/2, cvs.height/2)
  context.clearRect(cvs.width/2 * -1,cvs.height/2 * -1,cvs.width,cvs.width)

  # Create our clock.
  theDate = new Date()
  if Clock.showFace then @drawFace(context,Face,Clock.scale)
  if Clock.showFaceImage then @showFaceImage(FaceImage)
  if Clock.showMinuteTicks then @drawFaceDecorations(context,MinuteTicks,Clock.scale)
  if Clock.showHourTicks then @drawFaceDecorations(context,HourTicks,Clock.scale)
  if Clock.showFrame then @drawFrame(context,Frame,Clock.scale)
  if Clock.showSecondHand then @drawHand(context,theDate,SecondHand,Clock.scale)
  if Clock.showMinuteHand then @drawHand(context,theDate,MinuteHand,Clock.scale)
  if Clock.showHourHand then @drawHand(context,theDate,HourHand,Clock.scale)
  if Clock.showHandCover then @drawHandCover(context,HandCover,Clock.scale)
  if Clock.showLabel then @showLabel(Label,Clock.scale)
  
  # Set the origin back to 0,0. Translate uses relative positioning, which would cause the
  # context to continue to move each time the widget runs.
  context.translate(cvs.width/2 * -1, cvs.height/2 * -1)
  
drawFace: (context,Settings,Scale) ->
  # Draw the face of our clock.
  context.save()
  context.beginPath()
  context.arc(0, 0, Settings.radius, 0, 2 * Math.PI, false)  
  context.fillStyle = Settings.fillColor
  context.fill()
  context.restore()

showFaceImage: (Settings) ->
  # Show our image.
  Settings.imageObject.src = Settings.filename
  $(Settings.imageObject).css('position','absolute')
  $(Settings.imageObject).css('top','0')
  $(Settings.imageObject).css('left','0')
  $(Settings.imageObject).width(Settings.width)
  $(Settings.imageObject).height(Settings.height)
  $(Settings.imageObject).css('display','block')
  
drawFrame: (context,Settings,Scale) ->
  # Draw the frame of our clock. This is a torus with the outside circle filled and 
  # the inner one not.
  context.save()
  context.beginPath()
  context.arc(0, 0, Settings.outerRadius, 0, 2 * Math.PI, true)  
  context.arc(0, 0, Settings.innerRadius, 0, 2 * Math.PI, false)  
  context.fillStyle = Settings.fillColor
  context.fill()
  context.restore()

drawFaceDecorations: (context,Settings,Scale) ->
  # Draw the ticks on the clock.
  context.save()
  context.beginPath()
  for d in [1..(360/Settings.degrees)]
    context.rotate(@degreesToRadians(Settings.degrees))
    context.moveTo(Settings.innerRadius,0)
    context.lineTo(Settings.outerRadius,0)
  if Settings.lineWidth > 0
    context.lineWidth = Settings.lineWidth * Scale
    context.strokeStyle = Settings.strokeColor
    context.stroke()
  context.restore()

drawHandCover: (context, Settings, Scale) ->
  # Draw a circle over the hands to polish things up.
  context.save()
  context.beginPath()  
  context.arc(0, 0, Settings.radius * Scale, 0, 2 * Math.PI, false)
  context.fillStyle = Settings.fillColor
  context.fill()
  if Settings.lineWidth > 0
    context.lineWidth = Settings.lineWidth * Scale
    context.strokeStyle = Settings.strokeColor
    context.stroke()
  context.restore()

drawHand: (context,theDate,Settings,Scale) ->
  context.save()
  
  # Rotate the canvas the appropriate number of degrees. This makes the drawing of the hand much easier.
  context.rotate(Settings.degrees)
  
  # Set our basic colors, etc.
  context.fillStyle = Settings.fillColor
  context.shadowColor = Settings.shadowColor
  context.shadowBlur = Settings.shadowBlur * Scale
  context.shadowOffsetX = Settings.shadowOffset * Scale
  context.shadowOffsetY = Settings.shadowOffset * Scale
  
  # Draw the hand.
  context.beginPath()
  context.arc(0, 0, Settings.width*2*Scale, @degreesToRadians(0), @degreesToRadians(180),false);
  context.moveTo(Settings.width*-2*Scale,0)
  context.lineTo(Settings.width/2*Scale,Settings.length * -1)
  context.lineTo(Settings.width*2*Scale,0)
  
  if Settings.lineWidth > 0
    context.lineWidth = Settings.lineWidth * Scale
    context.strokeStyle = Settings.strokeColor
    context.stroke()
  
  context.fill()
  context.restore()

showLabel: (Settings,Scale) ->
  Settings.labelObject.html(Settings.text)
  Settings.labelObject.css('font-family',Settings.fontFamily)
  Settings.labelObject.css('font-size',@scaleUnit(Settings.fontSize,Scale))
  Settings.labelObject.css('color',Settings.color)
  Settings.labelObject.css('text-align',Settings.textAlign)
  Settings.labelObject.css('background',Settings.background)
  Settings.labelObject.css('border-style',"solid")
  Settings.labelObject.css('border-color',Settings.borderColor)
  Settings.labelObject.css('border-width',@scaleUnit(Settings.borderWidth,Scale))
  Settings.labelObject.css('border-radius',@scaleUnit(Settings.borderRadius,Scale))
  Settings.labelObject.css('display','block')

degreesToRadians: (degrees) ->
  (Math.PI / 180) * degrees
  
scaleUnit: (sizeString,Scale) ->
  unit = sizeString.match('px|em|%|in|cm|mm|ex|pt|pc')
  value = sizeString.match('[0-9]+')
  value * Scale + unit