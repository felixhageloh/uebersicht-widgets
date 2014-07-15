# this is the shell command that gets executed every time this widget refreshes
command: "curl -s http://blockchain.info/ticker"

# the refresh frequency in milliseconds
refreshFrequency: 60000

render: (o) ->
  @count = 0
  """
    <div class='box'>
      <div class='btc'>1 BTC</div>
      <div class='prices'>
      </div>
    </div>
  """

update: (output, domEl) ->
  #########################################################
  # Change this to the currency symbols you want to show. #
  #########################################################
  CURRENCIES = ["AUD", "USD"]

  box = $(domEl).find('.box')

  prices = JSON.parse(output)


  content = for currency in CURRENCIES
    info = prices[currency]
    price = parseInt(info["last"])
    symbol = info["symbol"]

    """
      <div class='price'>#{symbol} #{price}</div>
      <div class='currency'>#{currency}</div>
    """

  $(box).find('.prices').html content

style: """
  bottom: 10%
  left: 5px
  color: white
  font-family: 'Helvetica Neue'
  font-weight: 100
  text-align: left
  margin: 5px
  width: 120px
  text-align: center

  .box
    padding: 3px
    border: 1px solid rgba(#FFF, 50%)
    font-size: 24px

    .price
      font-size: 32px

    .btc
      text-align: left

    .currency
      text-align: right

    .currency, .btc
      font-size: 10px
      font-weight: 500
      letter-spacing: 1px
"""
