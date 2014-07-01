# A widget to describe what's playing in iTunes
# in the form of "Now Playing in iTunes: <song> by <artist> on <album>"
# blagged and edited from:
# http://www.tuaw.com/2007/04/02/terminal-tip-now-playing-info-from-the-command-line/

command: "osascript -e \'tell application \"iTunes\" to if player state is playing then \"Now Playing in iTunes: \" & name of current track & \" by \" & artist of current track & \" on \" & album of current track'"

refreshFrequency: 1000

style: """
  top: 75%
  left: 35%
  color: #fff
  font-family: Helvetica Neue
  text-shadow: 0.1em 0.1em 0.2em #000

  p
    padding: 0
    margin: 0
    font-size: 16px
    font-weight: normal

"""

render: (output) -> """
 <p>#{output}</p>
"""
