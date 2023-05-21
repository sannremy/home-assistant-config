#!/bin/bash

# Get Suez (Tout sur mon eau) current month water consumption
# Usage:
# ./water_consumption.sh username password

username=$1
password=$2
meter_id=$3

apk add -q chromium nodejs-current npm
cd /config/shell/node && npm install --silent &>/dev/null
SUEZ_USERNAME=$username SUEZ_PASSWORD=$password SUEZ_METER_ID=$meter_id node /config/shell/node/suez.js > /config/shell/output/water_consumption.txt
