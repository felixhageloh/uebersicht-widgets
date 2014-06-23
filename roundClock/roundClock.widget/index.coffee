# Read style section for settings (e.g. retina scaling, colors)

command: "date +%-I,%M,%-S"

refreshFrequency: 1000

render: (output) -> """
<svg version="1.1" id="clock" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 215 215" enable-background="new 0 0 215 215" xml:space="preserve">
  <defs>
    <marker id="sec-mk" markerHeight="10" markerWidth="5" refX="0" refY="5" orient="auto">
      <polygon points="0,0 0,10 5,5"/>
    </marker>
    <marker id="hr-mk" markerHeight="10" markerWidth="5" refX="0" refY="5" orient="auto">
      <polygon points="0,0 0,10 5,5"/>
    </marker>
  </defs>

  <path id="min-ln" stroke-width="15" stroke-miterlimit="10" d="M107.5,7.5c55.2,0,100,44.8,100,100s-44.8,100-100,100s-100-44.8-100-100S52.3,7.5,107.5,7.5"/>

  <line id="hr-ln" class="line" marker-end="url(#hr-mk)" stroke-miterlimit="10" x1="107" y1="107.5" x2="107" y2="24.5"/>
  <line id="sec-ln" class="line" marker-end="url(#sec-mk)" stroke-miterlimit="10" x1="107" y1="107.5" x2="107" y2="24.5"/>
</svg>

<div id="digits">
  <span id="hr-dig">0</span><span id="min-dig">00</span><div id="sec-dig">0</div>
</div>
"""

update: (output) ->
  time = output.split(',')

  circ = Math.PI*2*100

  $('#hr-dig').text time[0]
  $('#min-dig').text time[1]
  $('#sec-dig').text time[2]

  $('#min-ln').css('stroke-dashoffset',circ - ( ( parseInt(time[1]) + ( time[2] / 60 ) ) / 60 ) * circ)
  $('#sec-ln').css('-webkit-transform','rotate('+( time[2] / 60 ) * 360+'deg)')
  $('#hr-ln').css('-webkit-transform','rotate('+( ( parseInt(time[0]) + ( time[1] / 60 ) ) / 12 ) * 360+'deg)')

style: """
  /* Settings */
  main = #121212
  second = rgb(191, 0, 0)
  background = rgba(255,255,255,0.15)
  transitions = false                   // disabled by default to save CPU cycles
  scale = 1                             // set to 2 to scale for retina displays

  /* Styles (mod if you want) */
  box-sizing: border-box

  left: 0%
  bottom: 0%
  margin-left: 15px * scale
  margin-bottom: 15px * scale

  width: 225px * scale
  height: 225px * scale

  padding: 5px * scale
  background: background
  border-radius: 112.5px * scale

  svg
    width: 215px * scale
    height: 215px * scale

  #hr-mk polygon
    fill: main
  #sec-mk polygon
    fill: second
  .line
    -webkit-transform-origin: 100% 100%    // centers the ticks

    if transitions
      -webkit-transition: -webkit-transform .25s cubic-bezier(0.175, 0.885, 0.32, 1.275)    // this bezier gives the tick a natural bounce
  #min-ln
    stroke: main
    fill: none

    stroke-dasharray: PI*2*100
    stroke-dashoffset: PI*2*100

    if transitions
      -webkit-transition: stroke-dashoffset .5s ease

  #digits
    position: absolute
    left:     50%
    top:      50%
    margin-left: -107.5px * scale
    margin-top: -38px * scale
    width:    215px * scale

    font-family: HelveticaNeue
    font-size: 72px * scale
    line-height: 1
    text-align: center
    -webkit-font-smoothing: antialiased    // the transparent bg makes subpixel look bad
    color: main
  #hr-dig
    font-family: HelveticaNeue-Bold
    letter-spacing: -3px * scale
    margin-right: 3px * scale
  #min-dig
    font-size: 48px * scale
    letter-spacing: -2px * scale
  #sec-dig
    font-family: HelveticaNeue-Light
    font-size: 24px * scale
    color: second
"""
