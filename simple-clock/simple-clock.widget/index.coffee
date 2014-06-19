format = '%l:%M %p'

command: "date +\"#{format}\""

# the refresh frequency in milliseconds
refreshFrequency: 30000

render: (output) -> """
  <h1>#{output}</h1>
"""

style: """
  background: rgba(#fff, 0.2)
  color: #FFFFFF
  font-family: Helvetica Neue
  left: 3%
  bottom: 5%

  h1
    font-size: 7em
    font-weight: 100
    margin: 0
    padding: 10px 20px
  """
