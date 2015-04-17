#--------------------------------------------------------------------------------------
# Please Read
#--------------------------------------------------------------------------------------
# The images used in this widget are from the Noun Project (http://thenounproject.com).
#
# They were created by the following individuals:
#   Ethernet by Michael Anthony from The Noun Project
#   Wireless by Piotrek Chuchla from The Noun Project
#
#--------------------------------------------------------------------------------------

# Execute the shell command.
command: "NetworkInfo.widget/NetworkInfo.sh"

# Set the refresh frequency (milliseconds).
refreshFrequency: 5000

# Render the output.
render: (output) -> """
  <div id='services'>
    <div id='ethernet' class='service'>
      <p class='primaryInfo'></p>
      <p class='secondaryInfo'></p>
    </div>
    <div id='wi-fi' class='service'>
      <p class='primaryInfo'></p>
      <p class='secondaryInfo'></p>
    </div>
  </div>
"""

# Update the rendered output.
update: (output, domEl) ->
  dom = $(domEl)

  # Parse the JSON created by the shell script.
  data = JSON.parse output
  html = ""

  # Loop through the services in the JSON.
  for svc in data.service

    disabled = svc.ipaddress == ""
    el = $('#'+svc.name)
    el.find('.primaryInfo').text(svc.ipaddress || 'NotConnected')
    el.find('.secondaryInfo').text(if !disabled then svc.macaddress else '')
    el.toggleClass('disabled', disabled)


# CSS Style
style: """
  margin:0
  padding:0px
  left:10px
  top: 10px
  background:rgba(#000, .25)
  border:1px solid rgba(#000, .25)
  border-radius:10px

  #wi-fi
    background: url(/NetworkInfo.widget/images/wi-fi.png)

    &.disabled
      background: url(/NetworkInfo.widget/images/wi-fi_disabled.png)

  #ethernet
    background: url(/NetworkInfo.widget/images/ethernet.png)

    &.disabled
      background: url(/NetworkInfo.widget/images/ethernet_disabled.png)

  #wi-fi, #ethernet, #wi-fi.disabled, #ethernet.disabled
    height: 40px
    width: 100px
    float: left
    background-position: center 5px
    background-repeat: no-repeat
    background-size: 32px 32px

  .service
    text-align: center
    padding: 35px 2px 2px 2px

  .primaryInfo, .secondaryInfo
    font-family: Helvetica Neue
    padding:0px
    margin:2px

  .primaryInfo
    font-size:10pt
    font-weight:bold
    color: rgba(#000,0.75)

  .secondaryInfo
    font-size:8pt
    color: rgba(#000, 0.5)

  .disabled p
    color: rgba(#000, 0.35)
"""
