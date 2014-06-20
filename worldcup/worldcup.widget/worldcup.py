#!/usr/bin/env python2.7
# coding:utf-8

import suds
import datetime
import sys
import locale
import calendar

locale.setlocale(locale.LC_ALL, '')

## Define League
LEAGUE_NAME = "fifa2014"
LEAGUE_SAISON = "2014"
LEAGUE_ID = 739

##configure difference from utc
DIFF_UTC = 2

## SOAP Interface
URL = "http://www.openligadb.de/Webservices/Sportsdata.asmx?WSDL"

## Create client
client = suds.client.Client(URL)

## Only show games within a certain period
fromtime = datetime.datetime.combine(datetime.date.today(), datetime.time(0,0,0))
totime = fromtime + datetime.timedelta(days=1)

## Get Match-List
try:
    matches =  client.service.GetMatchdataByLeagueDateTime(fromtime, totime, LEAGUE_NAME).Matchdata
except Exception:
    print "n/A"
    sys.exit(1)

## reverse-iteration
for match in matches:
    timestamp = calendar.timegm(match.matchDateTime.timetuple())
    start_time=datetime.datetime.fromtimestamp(timestamp)-datetime.timedelta(hours=DIFF_UTC)
    if match.matchResults:
        goals =  "({0}) - ({1})".format(match.matchResults.matchResult[0].pointsTeam1, match.matchResults.matchResult[0].pointsTeam2)
    else:
        goals = "-"
    print """<p>{team1} {goals} {team2}, 
    {start_time}</p>""".format(team1=match.nameTeam1.encode("utf-8"),
        team2=match.nameTeam2.encode("utf-8"), 
        goals=goals, start_time=start_time.strftime("%a %H:%M"))