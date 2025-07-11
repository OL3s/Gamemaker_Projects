[Back to index](../README.md)
# Path of Salvation

A pixel-style, real-time dungeon crawler for mobile platforms. Your ultimate goal is to collect all three legendary gems, each earned by defeating a unique final boss. After collecting a gem, the game resets for a new challenge.

---

# 📘 General Overview

## Gameplay Loop

1. Start in the Sanctuary (main hub)
2. Choose up to 3 missions for your run
3. Buy and equip gear, assign abilities
4. Enter a series of dungeon rounds (waves 0–9)
5. Face a random final boss at wave 10 to earn a unique gem
6. Collect gold and rewards from loot and missions
7. After collecting a gem, the game resets; repeat to collect all three gems

## Menu Overview

- **Home:** Main hub and starting point
- **Contracts:** Choose missions (up to 3 per run)
- **Market:** Shop for new gear and equipment
- **Loadout:** Equip weapons and armor
- **Skills:** Assign and upgrade abilities

## Biomes

- The game features multiple biomes, each with unique visuals and enemy types:
  - Woodland
  - Swamp
  - Desert
  - Mountain
  - Cave
  - Ice Cave
  - Volcanic
  - Ruins
  - Crypt
  - Abyss

- The current biome determines the available choices to choose from for the next biome, as well as which contract types and enemy groups are available. It also affects the selection of shop items.

## Mob Families

- Enemy groups ("mob families") are categorized and vary by biome and contract:
  - Wild (forest, desert, tundra, cave)
  - Elemental
  - Goblin
  - Bandit
  - Undead
  - Cultist
  - Abyssal

- Each family has unique abilities and combat behaviors, influencing mission difficulty and rewards.

## Combat Overhaul

The combat system has been overhauled to add more depth and tactical options:

- **Damage Types:** Physical Slash, Pierce, Crush, Heat, Cold, Acid
- **Status Effects:** Hit, Stun, Slow, Burn, Freeze
- **Armor:** Physical and effect armor reduce incoming damage and status effects
- **Interactions:** Each attack can apply one or more damage types and effects, which interact with enemy and player armor
- **Status Tracking:** Effects like stun, burn, and freeze are tracked and updated each frame, with visual feedback

---

# 🛠 Technical Documentation

## Core Room Structure

Room transitions are handled by direct calls to `room_goto()` in menu actions (no central controller object).

**Main Rooms:**
- `rom_start`: Main menu (continue, new run, tutorial)
- `rom_nextFloor`: Main navigation and menu (store, equipment, home, abilities, missions)
- `rom_dungeon`: Dungeon gameplay
- `rom_boss`: Boss encounter to collect one of the three legendary gems, based on boss type
- `rom_end`: Game over screen (after collecting a gem)
- `rom_tutorial`: Tutorial

## Combat System

Combat logic is handled by `global.service_combat`:

- **Initialization:** `init` sets up combat stats for each entity
- **Damage Application:** `apply_physical` and `apply_effect` handle physical and effect-based damage on the combat struct.
- **Status Effects:** `effect_update` updates ongoing effects like burn or freeze every frame
- **Damage Types:** Each attack can apply multiple damage and effect types based on its physical and effect arrays, which interact with armor and status.
- **Armor:** Armor values are stored as arrays, with each index corresponding to a specific damage or effect type
- **Rendering:** `draw` displays health, armor, and effect bars for entities

## Touch System

- Multi-touch support via `obj_touch_split` object
- Touch areas defined in code for UI and controls

Menu interaction uses `global.service_touch_several` for:
- Multi-touch area detection
- Tap gesture recognition
- UI boundary checking

## Start Screen
- The start screen is displayed in the `rom_start` room.
- Shows the game logo and three gem icons representing collected legendary gems.
- Gems are stored in `components` array, with each gem represented as a struct containing:
  - `image_index`: (number) Sprite frame index for the gem icon
  - `obtained`: (boolean) Whether the gem has been collected
  - `type`: (string) Always `"gem"`
  - `text`: (string, optional) Label such as "continue" or "new run"
- Touch input:
  - **Tap:** Starts or continues a run (`room_goto(rom_nextFloor)`)
  - **Hold:** Opens the tutorial (`room_goto(rom_tutorial)`)
- Uses `obj_start` to handle input and display logic.

## Menu System

Managed by `obj_menu`, providing navigation between screens using a state-based system with touch input.

### Menu Structure

- **Bottom Navigation `gui_bottom` array, (`menu_index`):**
  - **Market (0):** Buy and sell gear, weapons, and consumables
  - **Loadout (1):** Manage and equip your weapons and armor
  - **Home (2):** Return to the Home screen
  - **Skills (3):** Assign and upgrade character abilities
  - **Contracts (4):** Select and review missions for your run

- **Top Status Bar (`gui_top` array):**
  - Gold display (uses `spr_menu_icon_gold`)
  - Secondary resource (placeholder)

### Menu States

- **default:** Main menu view (item/contract lists)
- **selected:** Item/contract details, Contract confirmation.

Menus create touch areas with `create_area()` for responsive UI across screen sizes.

### Market (0)
- Displays items for sale in the array `data_shop` generated by [`global.service_item`](../Mobile_Project/scripts/service_item/service_item.yy)
- Allows players to view item details and purchase gear, weapons, and consumables
- Item selection and purchase actions are handled via touch input and the menu state

### Loadout (1)
- Manage and equip your weapons and armor (2 active equipment slots available for touch selection)
- View and compare gear stats
- Select and equip items using touch input; menu state updates to reflect equipped gear

### Home (2)
- Return to the Home screen

### Skills (3)
- Assign and upgrade character abilities

### Contracts (4)
- Allows players to select up to 3 contracts per run
- Missions are defined in the `data_contracts` array, generated by `global.service_filemanager`
- Each contract is stored in a struct with the following properties:
  - `name`: (string) Mission name
  - `description`: (string) Mission details
  - `reward`: (string) Reward for completing the mission
  - `difficulty`: (number) Difficulty level
  - `type`: (string) Type of mission (e.g., "kill", "collect")
- Shows mission details, sidequests, and rewards
- Contract selection and confirmation are handled via touch input and the menu state

### Currency

- Gold is earned from loot and completing missions
- Displayed in the top status bar using `spr_menu_icon_gold`

---

# 📱 Android Development Setup

## Requirements

- Windows 10 or newer
- GameMaker Studio 2 (latest)
- Java JDK 11+
- Android SDK and NDK
- Android device or emulator
- USB Debugging enabled
- USB drivers for your device
- Gradle 8+ (included with GameMaker Studio 2)

## Setup Steps

1. Clone the repository:
   ```sh
   git clone https://github.com/OL3s/Gamemaker_Projects.git
   ```

2. Install:
   - [GameMaker Studio 2](https://www.yoyogames.com/get)
   - [Java JDK (Adoptium)](https://adoptium.net/)

3. Set up in GameMaker Studio 2:
   - Set the `JAVA_HOME` environment variable to your Java installation directory
   - Set Android SDK and NDK paths in preferences

4. Connect your device:
   - Enable Developer Mode
   - Install USB drivers
   - Use USB or emulator

## Building

- Open the project in GameMaker Studio 2
- Set the target platform to **Android**
- Click Run or Build

## Troubleshooting

- Check all paths (SDK, NDK, JAVA)
- Ensure correct Gradle version

---

For more details, see the [Projects/README.md](../README.md).