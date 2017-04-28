command: "ps axo \"rss,pid,ucomm\" | sort -nr | head -n3 | awk '{printf \"%8.0f,%s,%s\\n\", $1/1024, $3, $2}'"

refreshFrequency: 5000

style: """
  bottom: 0px
  left: 580px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed
    margin-bottom: 4px

  td
    font-size: 10px
    font-weight: normal
    width: 80px
    max-width: 80px
    overflow: ellipsis
    text-shadow: 0 0 1px rgba(#000, 0.5)


"""


render: ->
  """
  <table>
    <tr id="row-1"></tr>
    <tr id="row-2"></tr>
    <tr id="row-3"></tr>
  </table>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (mem, name) ->
    "<td>#{name}</td><td>#{mem}</td>"

  for process, i in processes
    args = process.split(',')
    table.find("#row-#{i+1}").html renderProcess(args...)

