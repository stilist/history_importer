# `history_importer`

This is a collection of scripts that automatically back up your personal data. The goal is to have a managed dataset of unmodified source data that can be processed and manipulated as desired.

## Supported data sources

* [batlog](https://github.com/jradavenport/batlog): data is copied from `~/batlog.dat`
* FaceTime: data is copied from `~/Library/Application Support/CallHistoryDB/CallHistory.storedata`
* [Flight tracks](http://flightxml.flightaware.com/soap/FlightXML2/doc#op_GetHistoricalTrack): uses the [FlightAware](http://flightaware.com) API -- you can find `faFlightID`s by viewing a flight's track log; for example, [American Airlines 1384](http://flightaware.com/live/flight/AAL1384) flew [SEA to PHX](http://flightaware.com/live/flight/AAL1384/history/20170501/0059Z/KSEA/KPHX/tracklog) with an id of `AAL1384-1493357164-airline-0177`
* [iOS](https://www.theiphonewiki.com/wiki/ITunes_Backup): data is copied from `~/Library/Application Support/MobileSync/Backup`
* [IRB history](http://ruby-doc.org/stdlib-2.4.0/libdoc/irb/rdoc/IRB.html#module-IRB-label-History): data is copied from [`~/.irb_history`](https://github.com/stilist/dotfiles/blob/master/ruby/.irbrc)
* [`less` history](https://linux.die.net/man/1/less): data is copied from `$LESSHISTFILE` (defaults to `~/.lesshst`)
* [Messages](https://support.apple.com/explore/messages): data is copied from `~/Library/Messages`
* [Photos](https://www.apple.com/macos/photos/): metadata is extracted via JavaScript for Automation (JXA)
* [Safari](https://www.apple.com/safari/): data is copied from `~/Library/Safari/history.db`
* [Time Sink](http://manytricks.com/timesink/): data is copied from `~/Library/Time Sink/Configurations/Default.plist`
* [WhatPulse](https://whatpulse.org): data is copied from `~/Library/Application Support/whatpulse/whatpulse.db`

## Importing data

The importer script will:

1. create the `history` directory if it doesn’t already exist,
2. import available data

You can safely run this importer on multiple machines. Because different machines may have different data sets, most importers will give files a name based on the machine where the script is running.

### Running the importer manually

You’ll need to be in a terminal window to run the importer.

Make sure you are in the directory on your machine where this repository was cloned: `pwd` should return `history_importer`. Run `HISTORY_DATA_PATH=../history ./import.sh`.

### Using `crontab` to run the importer automatically

Make sure you are in the directory on your machine where this repository was cloned: `pwd` should return `history_importer`.

To automatically run the importer every hour:

```shell
cron_path="$(env - /bin/sh -c 'echo $PATH'):/usr/sbin"
croncmd="pushd $(pwd) ; PATH=$cron_path HISTORY_DATA_PATH=$(cd ../history ; pwd) $(pwd)/import.sh"
cronjob="0 * * * * $croncmd"
( crontab -l 2>/dev/null | grep -v -F "$croncmd" ; echo "$cronjob" ) | crontab -
```

To stop automatically running the importer:

```shell
cron_path="$(env - /bin/sh -c 'echo $PATH'):/usr/sbin"
croncmd="pushd $(pwd) ; PATH=$cron_path HISTORY_DATA_PATH=$(cd ../history ; pwd) $(pwd)/import.sh"
( crontab -l | grep -v -F "$croncmd" ) | crontab -
```
