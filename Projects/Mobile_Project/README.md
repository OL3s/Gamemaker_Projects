## 📘 General Overview

**Path of Salvation** is a pixel-style, real-time dungeon crawler where your ultimate goal is to collect all three legendary gems. Each gem is earned by defeating one of the three unique final bosses. Once you have collected all three gems, the game resets for a new challenge.

### Gameplay Loop

1. Start in the Sanctuary (the main hub)
2. Choose up to 3 missions to pursue during your run
3. Buy and equip gear, and assign abilities to prepare for battle
4. Enter a series of dungeon rounds (waves 0–9), each wave is a new dungeon
5. At wave 10, face one of three random final bosses—defeat them to earn their unique gem
6. Collect gold and rewards from loot and completed missions
7. Repeat runs to collect all three gems; after all are collected, the game is reset for replayability

### Menu Overview

- **Sanctuary:** The main hub and starting point of your adventure
- **Contracts:** Menu where you choose missions for your run (up to 3)
- **Armory:** Shop where you can buy new gear and equipment
- **Loadout:** Menu to equip your character with weapons and armor
- **Skills:** Menu to assign and upgrade your abilities

---

## 🛠 Technical Documentation

### Core Room Structure

- Room transitions are handled by direct calls to `room_goto()` in menu actions (no central controller object)
- Main rooms:
  - **rom_start:** Main menu (continue, new run, or tutorial)
  - **rom_nextFloor:** Main navigation and menu (store, change equipment, home, abilities, mission selection)
  - **rom_dungeon:** Dungeon gameplay room
  - **rom_boss:** Boss encounter room
  - **rom_tutorial:** Tutorial room

### Systems

#### Touch System
- Multi-touch support via the object `obj_touch_split` and related objects
- Touch areas are defined in code for user interface and controls

#### Progress System
- Dungeon progression is wave-based (10 waves per run)
- Boss encounter at the final wave (wave 10)
- Each boss defeated grants a unique gem; collecting one three gems resets the game, all gems are required to complete the game

#### Mission System
- Players select up to 3 missions per wave, which affect objectives and rewards

#### Currency
- Gold is earned from loot and completing missions

---

## 📱 Android Development Setup

### Requirements

- Windows 10 or newer
- GameMaker Studio 2 (latest version)
- Java JDK 11 or newer
- Android SDK and NDK
- Android device or emulator
- USB Debugging enabled
- USB drivers for your device
- Gradle 8 or newer (included with GameMaker Studio 2)

### Setup Steps

1. Clone the repository:
   ```sh
   git clone https://github.com/OL3s/Gamemaker_Projects.git
   ```

2. Install:
   - GameMaker Studio 2: [YoYo Games](https://www.yoyogames.com/get)
   - Java JDK: [Adoptium](https://adoptium.net/)

3. Set up in GameMaker Studio 2:
   - Set the `JAVA_HOME` environment variable  
   This variable tells GameMaker Studio (and other tools) where to find your Java installation.  
      **To set it on Windows:**
      1. Find your Java installation directory (e.g., `C:\Program Files\Eclipse Adoptium\jdk-11.x.x`)
      2. Open the Start Menu, search for "Environment Variables", and select "Edit the system environment variables"
      3. In the System Properties window, click the "Environment Variables..." button
      4. Under "System variables", click "New..."
      5. For "Variable name", enter `JAVA_HOME`
      6. For "Variable value", enter the path to your Java JDK folder (from step 1)
      7. Click OK to save

      After setting this, restart GameMaker Studio and your PC if needed.
   - Set Android SDK and NDK paths in preferences

4. Connect your device:
   - Enable Developer Mode
   - Install USB drivers
   - Use USB or emulator

### Building

- Open the project in GameMaker Studio 2
- Set the target platform to **Android**
- Click Run or Build

### Troubleshooting

- Check all paths (SDK, NDK, JAVA)
- Ensure correct Gradle version