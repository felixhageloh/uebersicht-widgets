command: 'cal $(date -v -1m "+%m %Y") && cal && date'

refreshFrequency: 3600000

style: """
  bottom: 10px
  right: 10px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

  td
    text-align: center
    padding: 4px 6px
    text-shadow: 0 0 1px rgba(#000, 0.5)

  thead tr
    &:first-child td
      font-size: 24px
      font-weight: 100

    &:last-child td
      font-size: 11px
      padding-bottom: 10px
      font-weight: 500

  tbody td
    font-size: 12px    

  .today
    font-weight: bold
    background: rgba(#fff, 0.2)
    border-radius: 50%

  .grey
    color: #C0C0C0
"""

render: -> """
  <table>
    <thead>
      <tbody>
      </tbody>
    </thead>
  </table>
"""

updateHeader: (rows,table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[8]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[9].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  tbody = table.find("tbody")
  tbody.empty()
  
  rows.pop()
  today = rows.pop().split(/\s+/)[2]
  rows.splice 0,6

  tableRow = $("<tr></tr>").appendTo(tbody)

  for i in [0,1]
    days = rows[i].split(/\s+/).filter (day) -> day.length > 0

    if days.length != 7
      for day in days
        cell = $("<td>#{day}</td>").appendTo(tableRow)
        cell.addClass("grey")

  rows.splice 0,4

  days = rows[0].split(/\s+/).filter (day) -> day.length > 0   
  for day in days
    cell = $("<td>#{day}</td>").appendTo(tableRow) 

  rows.splice 0,1

  for week, i in rows
    tableRow = $("<tr></tr>").appendTo(tbody)
  
    days = week.split(/\s+/).filter (day) -> day.length > 0
    for day in days
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day == today
  
    if i != 0 and 0 < days.length < 7
      for j in [1..7-days.length]
        cell = $("<td>#{j}</td>").appendTo(tableRow)
        cell.addClass("grey")

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table

