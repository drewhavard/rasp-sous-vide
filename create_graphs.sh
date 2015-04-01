#!/bin/bash
DIR="/home/sousvide/"
 
#set to C if using Celsius
TEMP_SCALE="F"
 
#define the desired colors for the graphs
SOUSVIDE_COLOR="#CC0000"
 
#minute
rrdtool graph /var/www/temp_minute.png --width 300 --height 100 --full-size-mode  --start -1minutes --end now --step 1 --x-grid SECOND:1:SECOND:5:SECOND:20:0:%X \
DEF:temp=$DIR/watertemp.rrd:temp:AVERAGE \
AREA:temp$SOUSVIDE_COLOR:"Water Temp [deg $TEMP_SCALE]" \
 
#15 minutes
rrdtool graph /var/www/temp_15minute.png --width 300 --height 100 --full-size-mode --start -15minutes --end now \
DEF:temp=$DIR/watertemp.rrd:temp:AVERAGE \
AREA:temp$SOUSVIDE_COLOR:"Water Temp [deg $TEMP_SCALE]" \
