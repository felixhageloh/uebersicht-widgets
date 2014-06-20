command: "pmset -g batt | grep -o '[0-9]*%; [a-z]*'"

refreshFrequency: 30000

style: """
  top: 20px
  left: 10px
  color: #fff
  font-family: Helvetica Neue

  div
    display: block
    border: 1px solid #fff
    width: 80px
    max-width: 120px
    text-shadow: 0 0 1px rgba(#000, 0.5)
    background: rgba(#fff, 0.1)
    padding: 4px 6px 4px 6px

    &:after
      content: 'battery'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px
      font-weight: 500

  .percent
    font-size: 24px
    font-weight: 100
    margin: 0

  .status
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
  <div><p class='percent'></p><p class='status'></p></div>
"""

update: (output, domEl) ->
  values = output.split(";")
  percent = values[0]
  status = values[1]
  div     = $(domEl)
  
  div.find('.percent').html(percent)
  div.find('.status').html(status)

