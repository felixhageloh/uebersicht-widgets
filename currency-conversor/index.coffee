# currency-conversor
# author : kikorb

# HOWTO
# replace the from and to variables with the corresponding currencies
# enjoy!

command : ""
from    : "GBP"
to      : "EUR"
refreshFrequency: 15 * 60 * 1000

style: """
  top: 260px
  right: 40px
  color: #fff
  text-align: right

  h3
    font-size: 22px
    padding-bottom: 5px
  span
    background: rgba(#000, 0.5)
    border: 1px solid white
    padding: 10px 30px
    border-radius: 8px
    font-size: 16px
"""

render: (input) ->
    """
    <div>
      <h3>#{@from}-#{@to}</h3>
      <span id='rate'>To be replaced</span>
    </div>
    """

update : (input, domEl) ->
  $.ajax dataType: "jsonp", url:"http://rate-exchange.appspot.com/currency?from=#{@from}&to=#{@to}&q=1", success: ( data ) =>
    @replaceRate(data)

replaceRate : (data) ->
  $domEl = $("##{@id}")
  if !data.rate
    $domEl.hide()
  else
    $domEl.find('#rate').html(data.rate)
