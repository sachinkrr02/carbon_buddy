# Carbon Intensity Dashboard

**Overview**  
The Carbon Intensity Dashboard is a mobile app that allows users to monitor real-time and daily carbon intensity, helping them make energy usage decisions based on current carbon levels. By using data from the UK’s Carbon Intensity API, the app displays live national carbon intensity and a graph of half-hourly intensity for the current day.

**Features**
- **Live Carbon Intensity**: Shows current national carbon intensity in an easy-to-read widget.
- **Daily Intensity Graph**: Visualizes half-hourly carbon intensity trends for the day.
- **Error and Loading States**: Provides smooth handling of loading and data errors.

**API Integration**  
Using the [Carbon Intensity API (v2.0.0)](https://carbon-intensity.github.io/api-definitions/#carbon-intensity-api-v2-0-0):
- `/intensity` for live intensity data
- `/intensity/date` for half-hourly data throughout the day

**Tech Stack**  
- **Frontend**: Flutter for cross-platform support
- **Data Handling**: REST API for real-time updates

**Setup**
1. Clone: `git clone https://github.com/your-username/carbon-intensity-dashboard.git`
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

**Download APK**  
You can download the latest APK version [here](https://drive.google.com/drive/folders/1wMEXSJoIv6JqwZ7IbWyaWZxUL2slN4TT?usp=drive_link).

**Contributions**  
Contributions are welcome! See `CONTRIBUTING.md` for details.