# the api key is generated using md5(username:password)
api_key = "yourApiKey"
server = "https://yourFeverServer/"
command: "curl -s -d 'api_key=#{api_key}' \"#{server}?api&unread_item_ids\" | grep -Eo '\"unread_item_ids\":.*?[^\\]\",' | grep -Eo [0-9]+ | wc -l"

refreshFrequency: 60000

style: """
  bottom: 120px
  left: 100px
  color: #fff
  font-family: Helvetica Neue

  div
    display: block
    text-shadow: 0 0 1px rgba(#000, 0.5)
    font-size: 24px
    font-weight: 100


"""


render: -> """
  <div class='rss-count'></div>
"""

update: (numberOfUnreadArticles, domEl) ->
  $(domEl).find('.rss-count').html("RSS: #{numberOfUnreadArticles} unread")
