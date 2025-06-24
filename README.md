# GameMaker Android Project

A GameMaker Studio 2 game project configured for Android development.

## Development Requirements

- **Windows 10 or newer**
- **GameMaker Studio 2** (latest version recommended)
- **Java JDK 11 or newer** (ensure `JAVA_HOME` is set correctly)
- **Android SDK & NDK** installed
- **Android device or emulator** for testing
- **USB debugging** enabled on your device
- **USB drivers** installed for your device
- **Gradle 8+** (included with GMS2 runtime)
- **Internet connection** for SDK/Gradle downloads

## Getting Started

1. **Clone this repository**
   ```sh
   git clone https://github.com/OL3s/Gamemaker_Projects.git
   ```

2. **Install GameMaker Studio 2**  
   Download and install from [YoYo Games](https://www.yoyogames.com/get).

3. **Install Java JDK 11+**  
   Download from [Adoptium](https://adoptium.net/) or [Oracle](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html).  
   Set `JAVA_HOME` in your system environment variables.

4. **Install Android SDK & NDK**  
   Use the GameMaker Preferences > Platform Settings > Android to install and configure.

5. **Connect your Android device**  
   - Enable Developer Options and USB Debugging.
   - Install device USB drivers.
   - Connect via USB or use an emulator.

## Building & Running

1. Open the project in GameMaker Studio 2.
2. Go to **Target** and select **Android**.
3. Click **Run** or **Build** to deploy to your device or emulator.

## Troubleshooting

- **Build errors:**  
  Check that all SDK/NDK paths are set in GameMaker preferences.

## Credits

- GameMaker Studio 2 by YoYo Games