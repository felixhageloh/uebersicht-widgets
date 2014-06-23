command: "osascript -e 'tell application \"Mail\" to set unreadCount to unread count of inbox'"

refreshFrequency: 60000

style: """
  bottom: 120px
  left: 310px
  color: #fff
  font-family: Helvetica Neue

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 24px
    font-weight: 100


"""


render: -> """
  <div class='mail-count'></div>
"""

update: (numberOfUnreadMails, domEl) ->
  $(domEl).find('.mail-count').html("Mail: #{numberOfUnreadMails} unread")
