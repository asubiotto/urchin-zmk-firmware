# Urchin tenting stand with palm rest

![Left stand](out/preview.png)

One stand per half. It tents the board, holds the case in a pocket, and puts a
palm rest in front at about home-row height, like the pads on a Kinesis
Advantage. Each half is 135 × 171 × 48 mm, so it fits a **Bambu Lab A1 mini**
(180 mm bed).

The pocket follows the real Urchin PCB outline (from
[duckyb/urchin](https://github.com/duckyb/urchin) `main.kicad_pcb`), grown by
`case_wall` + `clearance`.

## Files

| File | What |
|---|---|
| `out/urchin_stand_fit_test_left.stl` / `_right` | 2.4 mm ring of the pocket wall. **Print this first** (~10 min) |
| `out/urchin_stand_left.stl` / `_right` | The stands |
| `urchin_stand.scad` | Source. Open in OpenSCAD and use the Customizer |
| `urchin_outline.scad` | Urchin PCB outline (generated, don't edit) |

## Before the big print

1. Print a fit-test ring and drop the case in.
   - Too tight: raise `case_wall`.
   - Rattles: lower `case_wall`.
   - Re-export.
   The STLs assume a 3.0 mm case wall and 0.6 mm clearance. That's an estimate for the Coral case, not a measurement.
2. Measure `key_top_height`: desk to the top of a home-row keycap with the
   case flat on the desk (default 15 mm). It sets the palm rest height.

## Settings worth trying

- `tent_angle` (default 15°): the Advantage is roughly in the 10–20° range.
  Start lower if 15° feels odd.
- `tilt_angle` (default −3°): back slightly lower than front, which keeps your wrists
  straight, like typing into the Advantage's key well.
- `palm_vs_keys` (default −1 mm): palm rest top relative to the key tops.
- `palm_gap`, `palm_width`: move the rest if it gets in the thumb's way.
- `pad_recess`: cuts a recess for a stick-on felt or neoprene pad on the palm rest.

## Printing (A1 mini)

- PLA or PETG, 0.2 mm layers, 3 walls, 10–15 % gyroid infill.
- Print flat on its base, no supports. The USB and finger notches are open at the top.
- About 150–180 g and roughly 6–8 h per half.
- Optional: 10 mm silicone bumpons in the five recesses underneath.
- The printed palm surface is hard. A felt or neoprene pad (or `pad_recess`)
  makes it closer to the Kinesis pads.

## Re-exporting

```bash
openscad -o out/urchin_stand_left.stl -D 'part="left"' urchin_stand.scad
```

```bash
openscad -o out/urchin_stand_right.stl -D 'part="right"' urchin_stand.scad
```

# Travel case

![Case open on its hinge, and closed](out/travel_case_preview.png)

A clamshell made of two trays. Each tray holds one half face-up with the
keycaps 1 mm below the rim. The two halves are mirror images, so the trays
close face to face: the bottom tray's lip fits into a groove in the top tray,
and nothing presses the keys. A hinge joins them along the back, and a snap
latch holds the front shut. Closed, it's about 124 × 114 × 35 mm.

| File | What |
|---|---|
| `out/urchin_travel_case_bottom.stl` | Holds the **right** half, has the lip |
| `out/urchin_travel_case_top.stl` | Holds the **left** half, has the groove. Flip it over to close |
| `urchin_travel_case.scad` | Source |

- The pockets use the same `case_wall` and `clearance` as the stand. If the
  stand's fit-test ring fits your case, these fit too.
- Measure `tallest_point`: desk to the highest part of a half (keycap, or the
  nice!nano if it sits higher). Default 15 mm. Too low, and the halves press
  each other's keys in the bag.
- `lip_fit` sets how snugly the trays close. Raise it if they're too tight,
  lower it if they rattle.
- Each tray takes about 45–55 g and 2–3 h. Print open side up, no supports.

**Hinge.** The trays are too wide to print already joined (about 250 mm
open), so each prints with its own knuckles. The pin is a 62 mm piece of
1.75 mm filament: push it through all three knuckles, then flatten each end
with a soldering iron or a lighter so it can't slide out. If the pin is loose,
lower `pin_d` to 1.9. The case opens all the way to 180°.

**Latch.** A flexible tab on the bottom tray's front edge has a tooth that
snaps into a slot in the top tray. Press the lid down to close it. To open,
pull the top of the tab outward with a fingernail and lift. If it's too stiff,
lower `tab_t` (1.4 mm). If it doesn't hold, raise `tooth` (1.2 mm).

`hinge` and `latch` can each be switched off. `band_w` adds a groove for a
rubber band instead.

Re-export:

```bash
openscad -o out/urchin_travel_case_bottom.stl -D 'part="bottom"' urchin_travel_case.scad
```

```bash
openscad -o out/urchin_travel_case_top.stl -D 'part="top"' urchin_travel_case.scad
```
