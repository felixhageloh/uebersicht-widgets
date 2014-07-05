command: "sysctl -n vm.loadavg | awk '{printf \"%s,%s,%s\",$2,$3,$4}'"

refreshFrequency: 5000

style: """
    top: 210px
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

    .wrapper
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

    .pid
      position: absolute
      top: 2px
      right: 2px
      font-size: 10px
      font-weight: normal
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

  renderValue = (load_avg) ->
    "<div class='wrapper'>" +
      "#{load_avg}" +
    "</div>"

  for value, i in values
    args = value.split(',')
    table.find(".col#{i+1}").html renderValue(args...)
