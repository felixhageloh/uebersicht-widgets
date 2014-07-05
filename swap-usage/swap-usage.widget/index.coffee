command: "sysctl -n vm.swapusage | awk '{printf \"%s,%s\\n%s,%s\\n%s,%s\", $1,$3,$4,$6,$7,$9}'"

refreshFrequency: 5000

style: """
  top: 280px
  left: 50px
  color: #fff
  font-family: Helvetica Neue


  table
    border-collapse: collapse
    table-layout: fixed

    &:before
      content: 'swap'
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

"""


render: ->
  """
  <table>
    <tr>
      <td class='col1'></td>
      <td class='col2'></td>
      <td class='col3'></td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (name, value) ->
    "<div class='value'>" +
      "#{value}<p>#{name}</p>" +
    "</div>"

  for process, i in processes
    args = process.split(',')
    table.find(".col#{i+1}").html renderProcess(args...)
