#!/bin/bash

# Get Suez (Tout sur mon eau) current month water consumption
# Usage:
# ./water_consumption.sh username password meter_id

username=$1
password=$2
meter_id=$3

# Install chromium, nodejs and dependencies
apk add -q \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    nodejs-current npm

# Install dependencies
cd /config/shell/node && npm install --silent &>/dev/null

whoami > /config/shell/output/whoami.txt
which chromium-browser > /config/shell/output/which_chromium-browser.txt

# SUEZ_USERNAME=$username SUEZ_PASSWORD=$password SUEZ_METER_ID=$meter_id node /config/shell/node/suez.js > /config/shell/output/water_consumption.txt
