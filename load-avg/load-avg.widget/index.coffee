command: "sysctl -n vm.loadavg | awk '{printf \"%s,%s,%s\",$2,$3,$4}'"

refreshFrequency: 5000

style: """
    top: 70px
    left: 50px
    color: #fff
    font-family: Helvetica Neue

    table
      border-collapse: collapse
      table-layout: fixed

      &:after
        content: 'load avg'
        position: absolute
        left: 0
        top: -14px
        font-size: 10px

    td
      border: 1px solid #fff
      font-size: 24px
      font-weight: 100
      width: 120px
      max-width: 120px
      overflow: hidden
      text-shadow: 0 0 1px rgba(#000, 0.5)

    .value
      padding: 4px 6px 4px 6px
      position: relative

    .col1
      background: rgba(#fff, 0.2)

    .col2
      background: rgba(#fff, 0.1)

    p
      padding: 0
      margin: 0
      font-size: 11px
      font-weight: normal
      max-width: 100%
      color: #ddd
      text-overflow: ellipsis
      text-shadow: none
"""

render: -> """
  <table>
    <tr>
      <td class='col1'></td>
      <td class='col2'></td>
      <td class='col3'></td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  values = output.split(',')
  table     = $(domEl).find('table')

  renderValue = (load_avg, index, label) ->
    "<div class='value'>" +
      "#{load_avg}" +
      "<p class=label> #{label}</p>" +
    "</div>"

  for value, i in values
    if i == 0
      label = '1 Minute'
    else if i == 1
      label = '5 Minute'
    else if i == 2
      label = '15 Minute'

    table.find(".col#{i+1}").html renderValue(value,i, label)
