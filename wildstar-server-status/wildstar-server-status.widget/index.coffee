auth_server = 1  # 1 == NA, 2 == EU

server_name = 'stormtalon'  # replace with the server you care about

command:  "curl -s http://wsstatus.com/embed/json.php?serverid=\"#{auth_server}\" && echo \"|\" && curl -s http://wsstatus.com/embed/json.php?server=\"#{server_name}\""

style: """
  background: rgba(#fff, 0)
  color: #FFFFFF
  font-family: Helvetica Neue
  left: 50px
  bottom: 50%

  &:after
    content: 'Wildstar Server Status'
    position: absolute
    left: 0
    top: -16px
    font-size: 10px

  table
    border-collapse: collapse
    table-layout: fixed
    font-size: 24px

  p
    padding: 0
    margin: 0px 5px 0px 5px
    max-width: 100%
    text-overflow: ellipsis
    text-shadow: none

  th
    text-align: right
    border: 1px solid #fff
    background: rgba(#ffff, 0.15)
    width: 260px
    max-width: 260px

  td
    text-align: left
    border: 1px solid #fff
    font-weight: 100
    width: 100px
    max-width: 100px

  """

refreshFrequency:  30000

render: -> """
  <table>
    <tr class='row1'>
      <th class='name1'></td>
      <td class='status1'></td>
    </tr>
    <tr class='row2'>
      <th class='name2'></td>
      <td class='status2'></td>
    </tr>
  </table>
"""

update:  (output, domEl) ->
  servers = output.split('|')
  table     = $(domEl).find('table')

  renderName = (name, type) ->
    "<p>#{name} (#{type})</p>"

  renderStatus = (status) ->
    "<p>#{status}"

  for server, i in servers
    data = JSON.parse(server)[0]
    table.find(".name#{i+1}").html renderName(data.Name, data.Type)
    table.find(".status#{i+1}").html renderStatus(data.Status)
