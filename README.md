Firmware for: [Urchin Keyboard](https://github.com/duckyb/urchin)

## Getting started

**Are you trying to make your own ZMK firmware?**  
[Here are the steps you need to take.](./GETTING_STARTED.md)

**Do you want to download this keymap?**

This keymap assumes macOS with the keyboard input set to US English (ABC / U.S.).

Download the firmware zip from the latest successful run of the Build workflow in this repository's Actions tab. Check [the ZMK docs](https://zmk.dev/docs/user-setup#installing-the-firmware) for instructions on how to flash it.

## Keymap Cheat Sheet

Open [`keymap.html`](./keymap.html) in a browser for an interactive view of every layer, with animated walkthroughs of common shortcuts.

- **Base:** plain QWERTY. Home-row mods `⌃ ⌥ ⌘ ⇧` on pinky / ring / middle / index, mirrored on both hands ("timeless" settings from [urob/zmk-config](https://github.com/urob/zmk-config)).
- **Thumbs:** `Tab`/NUM, `⌫`/NAV (left) · `Space`/SYM, `⏎`/`⇧` (right). Tap for the key, hold for the layer or mod.
- **Esc:** press `W` + `E` together.
- **NAV** (hold `⌫`): arrows on `hjkl`, word/line jumps, page up/down, tab and history keys, undo/cut/copy/paste/redo, plain mods on the left home row. Tap `N` to lock NAV on, tap `⌫` to leave.
- **NUM** (hold `Tab`): right-hand numpad (1-2-3 on top, 0 on the thumb), plain mods on the left home row.
- **SYM** (hold `Space`): all symbols.
- **SYS** (hold both left thumbs): Bluetooth profiles, bootloader, ZMK Studio unlock, media, volume, brightness.

Originally based on the keymap by duckyb, inspired by [Seniply by Stevep99](https://stevep99.github.io/seniply/).
