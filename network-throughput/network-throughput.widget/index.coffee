network_interface = 'en0'

# Sample for one second, one time
# The command actually takes longer than 1 second to execute
command: "sar -n DEV 1 1 | grep #{network_interface} | tail -n1 | awk '{print $4,$6}'"

# Even though the command takes longer than 1 second to execute, 1000ms
# seems to work best (widget output updates approx every 3 seconds)
refreshFrequency: 1000

style: """
  top: 20px
  left: 10px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed
  
    &:after
      content: 'network throughput'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px
  
  td
    border: 1px solid #fff
    font-size: 24px
    font-weight: 100
    width: 182px
    max-width: 182px
    height: 48px
    overflow: hidden
    text-shadow: 0 0 1px rgba(#000, 0.5)
  
  .wrapper
    padding: 4px 6px 4px 6px
    position: relative

  .label
    position: absolute
    top: 1px
    right: 8px
    font-size: 10px
    font-weight: normal
  
  .col1
    background: rgba(#f00, 0.4)
  
  .col2
    background: rgba(#0ff, 0.4)

  .hidden
    display: none
"""

render: -> """
  <table>
  <tr>
    <td class='col1'><div class='wrapper'>0.00 KB/s<div class='label'>IN</div></div></td>
    <td class='col2'><div class='wrapper'>0.00 KB/s<div class='label'>OUT</div></div></td>
  </tr>
  </table>
"""

update: (output, domEl) ->
  table  = $(domEl).find('table')
  result = output.split(' ')

  # Rather than just use KB and/or MB, let's accommodate all speeds
  # Pass "si" as true for base 10 (1 KiB = 1000 bytes)
  # Pass "si" as false for base 2 (1 kB = 1024 bytes)
  renderBytes = (bytes, type, si) ->
    bytes = Number(bytes)
    units = ['B']
    u = 0
    thresh = if si then 1000 else 1024
    if (bytes < thresh)
      units = ['B']
      u = 0
    else
      units = if si then ['kB','MB','GB','TB','PB','EB','ZB','YB'] else ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB']
      u = -1
      loop
        bytes /= thresh
        ++u
        break if (bytes <= thresh)

    "<div class='wrapper'>" +
      "#{bytes.toFixed(1)} #{units[u]}/s" +
      "<div class='label'>#{type}</div>" +
    "</div>"

  table.find(".col1").html renderBytes(result[0], 'IN', true)
  table.find(".col2").html renderBytes(result[1], 'OUT', true)
