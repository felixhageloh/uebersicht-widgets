command: "worldcup.widget/worldcup.py"

refreshFrequency: 60000

style: """
  top:  260px;
  right: 1%
  color: #fff
  font-family: Helvetica Neue
  font-size: 10pt
  text-align: right

  h1
    font-size: 12pt
  .img
    margin-right: 10px
"""

render: (_) -> """
  <h1><img class='img' src='worldcup.widget/football.ico' />World Cup 2014</h1>
  <hr />
  <div class='output'></div>
"""

update: (output, domEl) ->
  $(domEl).find('.output').html output