apiKey   = '<api-key>'        # put your forcast.io api key here
location = '52.3833,-4.9000'  # enter your coordinates as LATITUDE,LONGITUDE here

exclude  = "minutely,hourly,alerts,flags"

command: "curl -s 'https://api.forecast.io/forecast/#{apiKey}/#{location}?units=auto&exclude=#{exclude}'"

refreshFrequency: 600000

render: (o) -> """
  <div class='today'>
    <div class='date'></div>
    <div class='icon'></div>
    <div class='temp'></div>
    <div class='summary'></div>
  </div>
  <div class='forecast'></div>
"""

update: (output, domEl) ->
  data  = JSON.parse(output)
  today = data.daily.data[0]
  date  = @getDate today.time
  $domEl = $(domEl)

  $domEl.find('.date').text @dayMapping[date.getDay()]
  $domEl.find('.temp').html """
    <span class='hi'>#{Math.round(today.temperatureMax)}°</span> /
    <span class='lo'>#{Math.round(today.temperatureMin)}°</span>
  """

  $domEl.find('.summary').text today.summary
  $domEl.find('.icon')[0].innerHTML = @getIcon(today)

  forecastEl = $domEl.find('.forecast').html('')
  for day in data.daily.data[1..5]
    forecastEl.append @renderForecast(day)

renderForecast: (data) ->
  date = @getDate data.time

  """
    <div class='entry'>
      <div class='icon'>#{@getIcon data}</div>
      <div class='temp'>#{Math.round(data.temperatureMax)}°</div>
      <div class='day'>#{@dayMapping[date.getDay()][0..2]}</div>
    </div>
  """

style: """
  bottom: 20%
  left: 50%
  color: #fff
  font-family: Helvetica Neue
  text-align: center
  width: 340px
  margin-left: -160px

  @font-face
    font-family Weather
    src url(weather.widget/icons.svg) format('svg')

  .today
    display: inline-block
    text-align: left
    position: relative

  .icon
    font-family: Weather
    font-size: 50px
    line-height: 70px
    position: absolute
    left: 0
    top: 0
    vertical-align: middle

  .temp, .date
    padding-left: 90px

  .date
    font-size: 11px
    margin-bottom: 5px

  .temp
    font-weight: 200
    font-size: 32px

    .hi
      color: #fff

    .lo
      color: #fafafa

  .summary
    font-size: 14px
    text-align: center
    line-height: 1.5
    color: #fff
    margin-top: 20px

  .forecast
    margin-top: 15px
    padding-top: 10px
    border-top: 1px solid #fff

  .forecast .entry
    display: inline-block
    margin-right: 40px
    text-align: center

    div
      margin-top: 5px

    &:last-child
      margin-right: 0;

    .temp
      font-size: 12px
      padding: 0

    .icon
      font-size: 15px
      line-height: 20px
      position: static

    .day
      font-size: 12px
"""

dayMapping:
  0: 'Sunday'
  1: 'Monday'
  2: 'Tuesday'
  3: 'Wednesday'
  4: 'Thursday'
  5: 'Friday'
  6: 'Saturday'

iconMapping:
  "rain"                :"&#xf019;"
  "snow"                :"&#xf01b;"
  "fog"                 :"&#xf014;"
  "cloudy"              :"&#xf013;"
  "wind"                :"&#xf021;"
  "clear-day"           :"&#xf00d;"
  "mostly-clear-day"    :"&#xf00c;"
  "partly-cloudy-day"   :"&#xf002;"
  "clear-night"         :"&#xf02e;"
  "partly-cloudy-night" :"&#xf031;"
  "unknown"             :"&#xf03e;"

getIcon: (data) ->
  return @iconMapping['unknown'] unless data
  if data.icon.indexOf('cloudy') > -1
    if data.cloudCover < 0.25
      @iconMapping["clear-day"]
    else if data.cloudCover < 0.5
      @iconMapping["mostly-clear-day"]
    else if data.cloudCover < 0.75
      @iconMapping["partly-cloudy-day"]
    else
      @iconMapping["cloudy"]
  else
    @iconMapping[data.icon]

getDate: (utcTime) ->
  date  = new Date(0)
  date.setUTCSeconds(utcTime)
  date
