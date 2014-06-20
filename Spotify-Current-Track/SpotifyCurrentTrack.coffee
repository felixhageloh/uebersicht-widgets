command: """
IFS='|' read -r theArtist theName <<<"$(osascript <<<'tell application "Spotify"
        set theTrack to current track
        set theArtist to artist of theTrack
        set theName to name of theTrack
        return theArtist & "|" & theName
    end tell')"
echo "$theArtist - $theName"
"""

refreshFrequency: 2000

style: """
  bottom: 10px
  left: 10px
  color: #fff

  .some-class
    font-family: Helvetica Neue
    font-size: 30px
    font-weight: 100
    text-shadow: 0 1px 5px #000000;
"""

render: (output) -> """
	<div class="some-class">#{output}</div>
"""