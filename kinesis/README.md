# Urchin layout on a Kinesis Advantage2

The Advantage2 can't run ZMK. Its controller only supports SmartSet remaps,
with no layers or hold-taps. So the Urchin layout runs on the Mac instead,
through [kanata](https://github.com/jtroo/kanata).
[`urchin-on-advantage2.kbd`](./urchin-on-advantage2.kbd) mirrors
[`config/urchin.keymap`](../config/urchin.keymap) key for key:

- Same 34 letter keys, home-row mods `⌃ ⌥ ⌘ ⇧`, W+E = Esc.
- NAV, NAV-lock, NUM, SYM and SYS layers, with the same timings (200 ms tap, 175 ms quick-tap, 100 ms prior-idle).
- Thumbs keep the Urchin's outer/inner order:

| Kinesis key | Urchin thumb | Tap / hold |
|---|---|---|
| Backspace | left outer | Tab / NUM |
| Delete | left inner | ⌫ / NAV |
| Enter | right inner | Space / SYM |
| Space | right outer | ⏎ / ⇧ |

**Switching back:** press the Kinesis **Insert** key (bottom row, left hand) to
turn the Urchin layout off and get the stock Kinesis. Press Insert again to
turn it back on. To stop kanata entirely, press `Ctrl+C` in its terminal.

Everything else on the Kinesis (number row, F-keys, arrows, Cmd/Alt/Ctrl and
Home/End/PgUp/PgDn thumb keys) passes through unchanged. To force yourself to
use the layers, set those keys to `XX` by adding them to `defsrc` and to every
layer.

The layout assumes the Kinesis sends its default keys: QWERTY, no SmartSet
remaps. Mac mode (`=` + `m`) only changes the small Cmd/Option/Ctrl thumb keys,
and the config doesn't touch those.

## Setup (macOS)

1. Install the Karabiner-DriverKit-VirtualHIDDevice **v6.2.0** `.pkg`. Activate it as described in
   [kanata's macOS guide](https://github.com/jtroo/kanata/blob/main/docs/setup-macos.md).
   If Karabiner-Elements is running, quit it: only one remapper can grab a keyboard.
2. Install kanata **1.12.0 or newer**:

   ```bash
   brew install kanata
   ```

3. Find the Kinesis's device name:

   ```bash
   sudo kanata --list
   ```

   Put that exact name in `macos-dev-names-include` at the top of the `.kbd` file.
   This step matters: without it, kanata also grabs the Urchin (over Bluetooth)
   and the MacBook keyboard, and remaps them a second time.
4. Check the config, then run it:

   ```bash
   kanata --cfg kinesis/urchin-on-advantage2.kbd --check
   ```

   ```bash
   sudo kanata --cfg kinesis/urchin-on-advantage2.kbd
   ```

   Grant Input Monitoring and Accessibility to your terminal when macOS asks.
   `Ctrl+C` in that terminal stops it. To start it at boot, see the
   LaunchDaemon section of the kanata macOS guide.

## Tuning

Same knobs as the ZMK file: `tt` (tapping term) and `qt` (quick tap) in
`defvar`, and `require-prior-idle` inside the `hrm` template. If home-row
mods misfire when you type fast, raise prior-idle in 10–20 ms steps.
