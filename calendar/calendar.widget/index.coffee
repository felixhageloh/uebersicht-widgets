sundayFirstCalendar = 'cal && date'

mondayFirstCalendar =  'cal | awk \'{ print " "$0; getline; print "Mo Tu We Th Fr Sa Su"; \
getline; if (substr($0,1,2) == " 1") print "                    1 "; \
do { prevline=$0; if (getline == 0) exit; print " " \
substr(prevline,4,17) " " substr($0,1,2) " "; } while (1) }\' && date'

command: sundayFirstCalendar

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
"""

render: -> """
  <table>
    <thead>
    </thead>
    <tbody>
    </tbody>
  </table>
"""

updateHeader: (rows, table) ->
  thead = table.find("thead")
  thead.empty()

  thead.append "<tr><td colspan='7'>#{rows[0]}</td></tr>"
  tableRow = $("<tr></tr>").appendTo(thead)
  daysOfWeek = rows[1].split(/\s+/)

  for dayOfWeek in daysOfWeek
    tableRow.append "<td>#{dayOfWeek}</td>"

updateBody: (rows, table) ->
  tbody = table.find("tbody")
  tbody.empty()

  rows.splice 0, 2
  rows.pop()
  today = rows.pop().split(/\s+/)[2]

  for week, i in rows
    days = week.split(/\s+/).filter (day) -> day.length > 0
    tableRow = $("<tr></tr>").appendTo(tbody)

    if i == 0 and days.length < 7
      for j in [days.length...7]
        tableRow.append "<td></td>"

    for day in days
      cell = $("<td>#{day}</td>").appendTo(tableRow)
      cell.addClass("today") if day == today

update: (output, domEl) ->
  rows = output.split("\n")
  table = $(domEl).find("table")

  @updateHeader rows, table
  @updateBody rows, table
