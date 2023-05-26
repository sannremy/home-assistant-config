#!/bin/bash

# Get Suez (Tout sur mon eau) current month water consumption
# Usage:
# ./water_consumption.sh username password meter_id

username=$1
password=$2
meter_id=$3

# Install chromium, nodejs and dependencies
apk add -q chromium nodejs-current npm

# Install dependencies
cd /config/shell/node && npm install --silent &>/dev/null

uname -a > /config/shell/output/uname.txt
whoami > /config/shell/output/uname.txt
which chromium-browser > /config/shell/output/uname.txt

# SUEZ_USERNAME=$username SUEZ_PASSWORD=$password SUEZ_METER_ID=$meter_id node /config/shell/node/suez.js > /config/shell/output/water_consumption.txt
