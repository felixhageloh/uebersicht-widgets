# Drives that aren't connected will be ignored

# Run 'df -h' to see valid mountpoints, add the ones you want, separated by spaces
# e.g. '/ /Volumes/MyBook /Volumes/Seagate1TB'
mount_points = '/'

command: "df -h #{mount_points} | awk 'NR>1 {print $2,$3,$4,$5,$9}'"

refreshFrequency: 60000

style: """
  bottom: 10px
  left: 400px
  color: #fff
  font-family: Helvetica Neue

  .output
    &:after
      content: 'disk info'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px

  .wrapper
    margin: 10px 0 0
    position: relative
    border: 1px solid #fff
    font-size: 24px
    font-weight: 100
    width: 367px
    max-width: 367px
    overflow: hidden
    text-shadow: 0 0 1px rgba(#000, 0.5)
    text-align: center

  .wrapper:first-of-type
    margin: 0px

  .bar
    background: rgba(#00C, 0.3)
    position: absolute
    height: 100%

  .label
    padding: 3px

  .stats
    padding: 3px
    margin: 0
    font-size: 11px
    font-weight: normal
    max-width: 100%
    color: #ddd
    text-overflow: ellipsis
    text-shadow: none

  .stat
    margin-right: 20px
"""


render: -> """
  <div class="output"></div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  output = $(domEl).find('.output')

  renderInfo = (total, used, free, pctg, mountpoint) ->
    "<div class='wrapper'>" +
      "<div class='bar' style='width: #{pctg}'></div>" +
      "<div class='label'>#{mountpoint}</div>" +
      "<div class='stats'>" +
        "<span class='stat'>#{total} total</span>" +
        "<span class='stat'>#{used} used</span>" +
        "<span class='stat'>#{free} free</span>" +
      "</div>" +
    "</div>"

  output.html ''

  for disk, i in disks
    args = disk.split(' ')
    if (args[4])
      if (args[4] == '/')
        args[4] = "Macintosh HD"
      else
        args[4] = args[4].replace /\/Volumes\//, ""
      output.append renderInfo(args...)
