command: "curl -4fNs ip.appspot.com"

refreshFrequency: 43200000

style: """
  top: 100px
  left: 10px
  color: #fff
  font-family: Helvetica Neue

  div
    display: block
    border: 1px solid #fff
    text-shadow: 0 0 1px rgba(#000, 0.5)
    background: rgba(#fff, 0.1)
    font-size: 24px
    font-weight: 100
    padding: 4px 6px 4px 6px

    &:after
      content: 'Public IP'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px
      font-weight: 500

"""


render: -> """
  <div class='ip_address'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.ip_address').html(output)

