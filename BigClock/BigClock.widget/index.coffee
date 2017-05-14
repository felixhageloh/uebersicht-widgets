format = '%m/%d/%Y %a\n %H:%M'

command: "date +\"#{format}\""

refreshFrequency: 30000

render: () -> """
  <div id='bigclock'></div>
"""
update: (output) ->
  data = output.split('\n')

  html = '<span class="time">'
  html += data[1]
  html += '</span>'
  html += data[0]

  $(bigclock).html(html)


style: """
  margin-top: 13em
  width: 100%

  #bigclock
    color: #FFF
    font-family: Helvetica Neue
    font-size: 5em
    font-weight: 100
    text-shadow: 1px 1px rgba(000, 20, 29, .5)
    margin: 0
    padding: 0

  #bigclock .time
    margin-right: .2em
    font-size: 4em
  """
