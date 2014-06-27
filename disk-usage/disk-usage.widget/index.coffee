# You may exclude certain drives (separate with a pipe)
# Example: exclude = 'MyBook' or exclude = 'MyBook|WD Passport'
# Set as something obscure to show all drives (strange, but easier than editing the command)
exclude   = 'NONE'

# appearance
filledStyle  = false # set to true for the second style variant. bgColor will become the text color

width        = '367px'
barHeight    = '36px'
labelColor   = '#fff'
usedColor    = '#d7051d'
freeColor    = '#525252'
bgColor      = '#fff'
borderRadius = '3px'
bgOpacity    = 0.9

# You may optionally limit the number of disk to show
maxDisks: 10


command: "df -h | grep '/dev/' | while read -r line; do fs=$(echo $line | awk '{print $1}'); name=$(diskutil info $fs | grep 'Volume Name' | awk '{print substr($0, index($0,$3))}'); echo $(echo $line | awk '{print $2, $3, $4, $5}') $(echo $name | awk '{print substr($0, index($0,$1))}'); done | grep -vE '#{exclude}'"

refreshFrequency: 60000

style: """
  bottom: 330px
  right: 400px
  font-family: Helvetica Neue
  font-weight: 200

  .label
    font-size: 12px
    color: #{labelColor}
    margin-left: 1px
    font-style: italic
    font-family: Myriad Set Pro, Helvetica Neue

    .total
      display: inline-block
      margin-left: 8px
      font-weight: bold

  .disk:not(:first-child)
    margin-top: 16px

  .wrapper
    height: #{barHeight}
    font-size: #{Math.round(parseInt(barHeight)*0.8)}px
    line-height: 1
    width: #{width}
    max-width: #{width}
    margin: 4px 0 0 0
    position: relative
    overflow: hidden
    border-radius: #{borderRadius}
    background: rgba(#{bgColor}, #{bgOpacity})
    #{'background: none' if filledStyle }

  .wrapper:first-of-type
    margin: 0px

  .bar
    position: absolute
    top: 0
    bottom: 0px

    &.used
      border-radius: #{borderRadius} 0 0 #{borderRadius}
      background: rgba(#{usedColor}, #{ if filledStyle then bgOpacity else 0.05 })
      border-bottom: 1px solid #{usedColor}
      #{'border-bottom: none' if filledStyle }

    &.free
      right: 0
      border-radius: 0 #{borderRadius} #{borderRadius} 0
      background: rgba(#{freeColor}, #{ if filledStyle then bgOpacity else 0.05 })
      border-bottom:  1px solid #{freeColor}
      #{'border-bottom: none' if filledStyle }


  .stats
    display: inline-block
    font-size: 0.5em
    line-height: 1
    word-spacing: -2px
    text-overflow: ellipsis
    vertical-align: middle
    position: relative

    span
      font-size: 0.8em
      margin-left: 2px

    .free, .used
      display: inline-block
      white-space: nowrap


    .free
      margin-left: 12px
      color: #{if filledStyle then bgColor else freeColor}

    .used
      color: #{if filledStyle then bgColor else usedColor}
      margin-left: 6px
      font-size: 0.9em

  .needle
    width: 0
    border-left: 1px dashed rgba(#{usedColor}, 0.2)
    position: absolute
    top: 0
    bottom: -2px
    display: #{'none' if filledStyle}

    &:after, &:before
      content: ' '
      border-top: 5px solid #{usedColor}
      border-left: 4px solid transparent
      border-right: 4px solid transparent
      position: absolute
      left: -4px
"""

humanize: (sizeString) ->
  sizeString.replace(/(\wi)/, " $1B")

renderInfo: (total, used, free, pctg, name) -> """
  <div class='disk'>
    <div class='label'>#{name} <span class='total'>#{@humanize(total)}</span></div>
    <div class='wrapper'>
      <div class='bar used' style='width: #{pctg}'></div>
      <div class='bar free' style='width: #{100 - parseInt(pctg)}%'></div>

      <div class='stats'>
        <div class='free'>#{@humanize(free)} <span>free</span> </div>
        <div class='used'>#{@humanize(used)} <span>used</span></div>
      </div>
      <div class='needle' style="left: #{pctg}"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  disks = output.split('\n')
  $(domEl).html ''

  for disk, i in disks[..(@maxDisks - 1)]
    args = disk.split(' ')
    if (args[4])
      args[4] = args[4..].join(' ')
      $(domEl).append @renderInfo(args...)
