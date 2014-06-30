command: "curl -s https://api.bitcoinaverage.com/ticker/global/EUR/last"  

refreshFrequency: 50000 #ms

style: """
  bottom: 10px
  left: 10px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

    &:after
      content: 'Bitcoin Price'
      position: absolute
      left: 0
      top: -14px
      font-size: 11px

  td
    font-size: 24.5px
    font-weight: 200
    width: 90px
    max-width: 110px
    overflow: hidden
    text-shadow: 0 0 1px rgba(#000, 0.5)
    padding-left:5px

  .wrapper
    padding: 4px 6px 4px 6px
    position: relative

  .col1
    background: rgba(#fff, 0.2)
 

"""

render: (o) -> """
  <table>
    <tr>
      <td class='col1'>€#{o}</td>
    </tr>
  </table>
"""