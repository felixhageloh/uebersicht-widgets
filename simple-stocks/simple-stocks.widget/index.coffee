# Separate stock symbols with a plus sign
symbols = "AAPL+FB+ORCL+GOOG+MSFT"

# See http://www.jarloo.com/yahoo_finance/ for Yahoo Finance options
command: "curl -s 'http://download.finance.yahoo.com/d/quotes.csv?s=#{symbols}&f=sl1c1p2' | sed 's/\"//g'"

# Refresh every 5 minutes
refreshFrequency: 300000

style: """
  bottom: 300px
  left: 500px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

    &:after
      content: 'simple stocks'
      position: absolute
      left: 0
      top: -14px
      font-size: 10px

  td
    border: 1px solid #fff
    font-size: 24px
    font-weight: 100
    width: 182px
    max-width: 182px
    overflow: hidden
    text-shadow: 0 0 1px rgba(#000, 0.5)
    background: rgba(#000, 0.3)

  .wrapper
    padding: 4px 6px 4px 6px
    position: relative

  .info
    padding: 0
    margin: 0
    font-size: 11px
    font-weight: normal
    max-width: 100%
    color: #ddd
    text-overflow: ellipsis
    text-shadow: none

  .up
    color: #0f0

  .down
    color: #f00
"""

render: -> """
  <table><tr><td>Loading...</td></tr></table>
"""

update: (output, domEl) ->
  stocks = output.split('\n')
  table  = $(domEl).find('table')
  table.html ""

  renderStock = (label, val, change, changepct) ->
    direction = if (changepct.charAt(0) == '+') then 'up' else 'down'
    """
    <td>
      <div class='wrapper'>
        #{label} #{val}
        <div class='info #{direction}'>#{change} (#{changepct.replace /\s/g, ''})</div>
      </div>
    </td>
    """

  for stock, i in stocks
    args = stock.split(',')
    if i % 2 == 0
      table.append "<tr/>"
    if (args[0])
      table.find("tr:last").append renderStock(args...)
