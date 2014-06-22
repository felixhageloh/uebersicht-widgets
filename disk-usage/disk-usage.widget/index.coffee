# You may exclude certain drives (separate with a pipe)
# Example: exclude = 'MyBook' or exclude = 'MyBook|WD Passport'
# Set as something obscure to show all drives (strange, but easier than editing the command)
exclude = 'NONE'

command: "df -h | grep '/dev/' | while read -r line; do fs=$(echo $line | awk '{print $1}'); name=$(diskutil info $fs | grep 'Volume Name' | awk '{print substr($0, index($0,$3))}'); echo $(echo $line | awk '{print $2, $3, $4, $5}') $(echo $name | awk '{print substr($0, index($0,$1))}'); done | grep -vE '#{exclude}'"

refreshFrequency: 60000

style: """
  bottom: 10px
  left: 400px
  color: #fff
  font-family: Helvetica Neue

  .result
    &:after
      content: 'disk usage'
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
  <div class="result"></div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  result = $(domEl).find('.result')

  renderInfo = (total, used, free, pctg, name) ->
    "<div class='wrapper'>" +
      "<div class='bar' style='width: #{pctg}'></div>" +
      "<div class='label'>#{name}</div>" +
      "<div class='stats'>" +
        "<span class='stat'>#{total} total</span>" +
        "<span class='stat'>#{used} used</span>" +
        "<span class='stat'>#{free} free</span>" +
      "</div>" +
    "</div>"

  result.html ''

  for disk, i in disks
    args = disk.split(' ')
    if (args[4])
      args[4] = args[4..].join(' ')
      result.append renderInfo(args...)
