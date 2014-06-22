command: """
read -r running <<<"$(ps -ef | grep \"MacOS/Spotify\" | grep -v \"grep\" | wc -l)" &&
test $running != 0 &&
IFS='|' read -r theArtist theName <<<"$(osascript <<<'tell application "Spotify"
        set theTrack to current track
        set theArtist to artist of theTrack
        set theName to name of theTrack
        return theArtist & "|" & theName
    end tell')" &&
echo "$theArtist - $theName" || echo "Not Connected To Spotify"
"""

refreshFrequency: 2000

style: """
  bottom: 10px
  left: 10px
  color: #fff

  .output
    font-family: Helvetica Neue
    font-size: 30px
    font-weight: 100
    text-shadow: 0 1px 5px #000000;
"""

render: (output) -> """
	<div class="output">#{output}</div>
"""
