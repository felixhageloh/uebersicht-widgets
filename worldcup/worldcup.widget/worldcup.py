#!/usr/bin/env python2.7
# coding:utf-8

import datetime
import json
import urllib2
import dateutil.parser
import dateutil.tz

##rest endpoint for today's matches
URL = "http://worldcup.sfg.io/matches/today"

try:
    data = json.load(urllib2.urlopen(URL))

    ##Set  local timezone
    timezone = dateutil.tz.tzlocal()

    ##iterate through matches
    for match in data: 
        matchtime = dateutil.parser.parse(match.get("datetime"))
        matchtime = matchtime.astimezone(timezone)

        if (match.get("status") == 'future'):
            goals = " - "
        else:
            goals =  "({0}) - ({1})".format(match.get("home_team").get("goals"), match.get("away_team").get("goals"))

        print """<p>{team1} {goals} {team2}, 
        {start_time}</p>""".format(team1=match.get("home_team").get("code"),
            team2=match.get("away_team").get("code"),
            goals=goals,
            start_time=matchtime.strftime("%a %H:%M"))

except Exception:
    print "n/A"