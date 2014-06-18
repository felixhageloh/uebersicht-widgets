command: "pmset -g batt | grep -o '[0-9]*%'"

refreshFrequency: 60000

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
    font-size: 24px
    font-weight: 100
    padding: 4px 6px 4px 6px

    &:after
      content: 'battery'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px
      font-weight: 500

"""


render: -> """
  <div class='battery'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.battery').html(output)

