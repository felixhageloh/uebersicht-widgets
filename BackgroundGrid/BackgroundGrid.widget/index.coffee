# Execute the shell command.
command: ''

# Set the refresh frequency (milliseconds).
refreshFrequency: 86400000

# Render the output.
render: (output) -> """
  <canvas id='backgroundCanvas'></canvas>
  <canvas id='majorGridCanvas'></canvas>
  <canvas id='minorGridCanvas'></canvas>
"""

# Update the rendered output.
update: (output, domEl) -> 

  #--------------------------------------------------------------------------------
  # User-Defined Properties
  #--------------------------------------------------------------------------------

  # Background
  Background = 
    visible: true
    color: "rgba(102,128,153,1)"
  
  # Major Grid  
  Major = 
    visible: true
    xSpacing: 50
    ySpacing: 50
    lineSize: 1
    dashSize: 0
    gridColor: "rgba(255, 255, 255, 0.25)"
    showMeasures: true
    textColor: "rgba(255, 255, 255, 0.50)"
    font: "9pt Helvetica Neue"
    
  # Minor Grid
  Minor =
    visible: true
    gridDivisions: 5
    lineSize: 1
    dashSize: 0
    gridColor: "rgba(255, 255, 255, 0.10)"

  #--------------------------------------------------------------------------------
  # Main Code
  #--------------------------------------------------------------------------------

  # Get our main DIV.
  div = $(domEl)
  
  # Set the width and height of each canvas.
  canvases = div.find('canvas')
  for c in canvases
    c.width = div.width()
    c.height = div.height()

  # Get our contexts.
  backgroundCtx = backgroundCanvas.getContext('2d')
  majorCtx = majorGridCanvas.getContext('2d')
  minorCtx = minorGridCanvas.getContext('2d')
  
  # Create the background.
  if Background.visible
    backgroundCtx.rect(0,0,div.width(),div.height())
    backgroundCtx.fillStyle = Background.color
    backgroundCtx.fill()

  # Create the major grid.
  if Major.visible
  
    # Set the font settings for the measures.
    majorCtx.fillStyle = Major.textColor
    majorCtx.font = Major.font
    
    # Loop from 0 to the width of our main div and draw the vertical lines.
    for x in [0..div.width()] by Major.xSpacing
      majorCtx.moveTo(x+.5,0);
      majorCtx.lineTo(x+.5,div.height());
      if Major.showMeasures then majorCtx.fillText(x,x+2,12);
  
    # Loop from 0 to the width of our main div and draw the horizontal lines.
    for y in [0..div.height()] by Major.ySpacing
      majorCtx.moveTo(0,y+.5);
      majorCtx.lineTo(div.width(),y+.5);
      if Major.showMeasures && y > 0 then majorCtx.fillText(y,2,y+12);

    # Set the line formatting and stroke the lines.
    if Major.dashSize > 0 then majorCtx.setLineDash([Major.dashSize])  
    majorCtx.lineWidth = Major.lineSize;
    majorCtx.strokeStyle = Major.gridColor
    majorCtx.stroke();

  # Create the minor grid.
  if Minor.visible
  
    # Loop from 0 to the width of our main div and draw the vertical lines.
    for x in [0..div.width()] by Major.xSpacing / Minor.gridDivisions
      minorCtx.moveTo(x+.5,0);
      minorCtx.lineTo(x+.5,div.height());
  
    # Loop from 0 to the width of our main div and draw the horizontal lines.
    for y in [0..div.height()] by Major.ySpacing / Minor.gridDivisions
      minorCtx.moveTo(0,y+.5);
      minorCtx.lineTo(div.width(),y+.5);

    # Set the line formatting and stroke the lines.
    if Minor.dashSize > 0 then minorCtx.setLineDash([Minor.dashSize])  
    minorCtx.lineWidth = Minor.lineSize;
    minorCtx.strokeStyle = Minor.gridColor
    minorCtx.stroke();
      
# CSS Style
style: """
  top: 0
  left: 0
  width:100%
  height:100%
  margin:0px
  padding:0px
  z-index:-999

  #majorGridCanvas, #minorGridCanvas, #backgroundCanvas
    position:absolute
    top:0
    left:0
"""
