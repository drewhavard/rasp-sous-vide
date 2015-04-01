#!/bin/bash
rrdtool create watertemp.rrd --start N --step 1 \
DS:temp:GAUGE:600:U:U \
RRA:AVERAGE:0.5:1:60 \
RRA:AVERAGE:0.5:60:3600 \