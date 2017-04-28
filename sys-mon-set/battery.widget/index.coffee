command: "pmset -g batt | grep -o '[0-9]*%'"

refreshFrequency: 60000

style: """
  bottom: 120px
  left: 0
  color: #fff
  font-family: Helvetica Neue

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 24px
    font-weight: 100


"""


render: -> """
  <div class='battery'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.battery').html(output)

