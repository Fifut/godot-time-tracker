# Project Time Tracker

Fork of [Godot Time Traker](https://github.com/YuriSizov/godot-time-tracker) by [YuriSizov](https://github.com/YuriSizov)

Modified to suit my personal use

A small editor widget which provides basic functions for tracking your time with the Godot editor. Track which main screen view you are using the most.

![Plugin preview](/images/preview-1.png)

Developed in and tested against Godot 4.4

## Update

### v2.0.5
- Fix: Counts being in the embeded game mode as 'external' [#4](https://github.com/Fifut/godot-time-tracker/issues/4)
- Mono font
- Total hours for sections
- Add project settings to show/hide sections and graphs
- Add project settings to define AFK timer (in seconds)

### v2.0.4
- Gogot 4.4
- Add section for Game
- Add total hours in main timer
- Fix: Popup menus count as “external” [#5](https://github.com/Fifut/godot-time-tracker/issues/5)

### v2.0.3
- AFK refactor
- Add sections for AFK and External
[#2](https://github.com/Fifut/godot-time-tracker/issues/2)
[#3](https://github.com/Fifut/godot-time-tracker/issues/3)

### v2.0.2
- AFK management

### v2.0.1
- Days management to fix hours overflow



## Godot Time Traker features (added or modified compared to Project Time Tracker)
- No session
- Start when project is loaded
- Graphs shows the percentages of sections
- Timer are saved every time a scene or script are saved
- Timer stops after 5 min of inactivity and resumes automatically (AFK management)
	- Editable in project settings
- When godot editor is not focused, time is count as External. For users that use external code editor
- Sections and graphs can be hide separately
	- Editable in project settings

## Knows issues
:heavy_exclamation_mark: Floating windows count as selected workspace in the main window.

:heavy_exclamation_mark: AFK can not handle floating windows and external section

## Installation
Clone this repository or download it as ZIP. You only need to put `addons/project-time-tracker` folder inside your project folder. ZIP already has only necessary files.

Also available from AssetLib within the Editor: https://godotengine.org/asset-library/asset/.
