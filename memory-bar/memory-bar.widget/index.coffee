command: "memory_pressure && sysctl -a | grep memsize"

refreshFrequency: 2000

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  top 10px
  left 10px

  // Statistics text settings
  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 300px
    text-align: widget-align
    position: relative
    clear: both

  .widget-title
    text-align: widget-align

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td
    font-size: 14px
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
    text-align: widget-align

  .widget-title
    font-size 10px
    text-transform uppercase
    font-weight bold

  .label
    font-size 8px
    text-transform uppercase
    font-weight bold

  .bar-container
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    background: rgba(#fff, .5)
    position: absolute
    margin-bottom: 5px

  .bar
    height: bar-height
    float: widget-align
    transition: width .2s ease-in-out

  .bar:first-child
    if widget-align == left
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar:last-child
    if widget-align == right
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar-inactive
    background: rgba(#0bf, .5)

  .bar-active
    background: rgba(#fc0, .5)

  .bar-wired
    background: rgba(#c00, .5)
"""


render: -> """
  <div class="container">
    <div class="widget-title">Memory</div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="stat"><span class="wired"></span></td>
        <td class="stat"><span class="active"></span></td>
        <td class="stat"><span class="inactive"></span></td>
        <td class="stat"><span class="free"></span></td>
        <td class="stat"><span class="total"></span></td>
      </tr>
      <tr>
        <td class="label">wired</td>
        <td class="label">active</td>
        <td class="label">inactive</td>
        <td class="label">free</td>
        <td class="label">total</td>
      </tr>
    </table>
    <div class="bar-container">
      <div class="bar bar-wired"></div>
      <div class="bar bar-active"></div>
      <div class="bar bar-inactive"></div>
    </div>
  </div>
"""

update: (output, domEl) ->

  usage = (pages) ->
    mb = (pages * 4096) / 1024 / 1024
    usageFormat mb

  usageFormat = (mb) ->
    if mb > 1024
      gb = mb / 1024
      "#{parseFloat(gb.toFixed(2))}GB"
    else
      "#{parseFloat(mb.toFixed())}MB"

  updateStat = (sel, usedPages, totalBytes) ->
    usedBytes = usedPages * 4096
    percent = (usedBytes / totalBytes * 100).toFixed(1) + "%"
    $(domEl).find(".#{sel}").text usage(usedPages)
    $(domEl).find(".bar-#{sel}").css "width", percent

  lines = output.split "\n"

  freePages = lines[3].split(": ")[1]
  inactivePages = lines[13].split(": ")[1]
  activePages = lines[12].split(": ")[1]
  wiredPages = lines[16].split(": ")[1]

  totalBytes = lines[28].split(" = ")[1]
  $(domEl).find(".total").text usageFormat(totalBytes / 1024 / 1024)

  updateStat 'free', freePages, totalBytes
  updateStat 'active', activePages, totalBytes
  updateStat 'inactive', inactivePages, totalBytes
  updateStat 'wired', wiredPages, totalBytes
