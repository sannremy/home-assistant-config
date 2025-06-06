# Home assistant config

I run Home assistant on a Raspberry Pi 4 (8Gb).

## Backup
- Netatmo video files to internal FTP.
- Home assistant config files to Dropbox.

## Monitoring
- Water consumption using Suez (water provider company in France).
- River level monitoring with Vigicrue (river data service in France).
- Internet connectivity operated by Altitude Infra and Bouygues Telecom.
- Morning commute to work office.
- Dryer time durations.

## Alerting
- River level above a threshold (river level data service in France).
- Internet connections and disconnections.
- Water consumption above a threshold per day.

## Dashboard UI
I have created a custom UI using Home assistant API and Websockets. This code can be found here: https://github.com/sannremy/home-assistant-ui
