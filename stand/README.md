# Urchin tenting stand with palm rest

![Left stand](out/preview.png)

One stand per half. It tents the board, holds the case in a pocket, and puts a
palm rest in front at about home-row height, like the pads on a Kinesis
Advantage. Each half is 147 × 169 × 55 mm, so it fits a **Bambu Lab A1 mini**
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
   case flat on the desk. The default 15 mm is an estimate. Every key height
   on the stand shifts 1:1 with it, so this one matters most.

## How the heights are set

The stand is designed backwards from two measurements on an Advantage2,
desk to top:

| | Advantage2 (measured) | Stand |
|---|---|---|
| F key | ~40 mm | `f_key_height` = 40 |
| Palm pad, centre | ~50 mm | `palm_height` = 50 (includes the foam pad) |
| Tent | 20° (Kinesis spec) | `tent_angle` = 20 |

The model lifts the stand until the F key top lands on `f_key_height`, then
raises the palm rest until the pad centre lands on `palm_height`. It prints
the results in OpenSCAD's console, including the thumb key heights. Change
the two targets and everything else follows. The F key position comes from
the Urchin's KiCad file.

## Settings worth trying

- `f_key_height`, `palm_height`: the drop between them (10 mm) puts the keys
  below your wrist, like the Advantage2's key wells. Raise `palm_height` for
  more drop, lower it for less.
- `tent_angle` (default 20°): matches the Advantage2. Lower it if 20° feels too steep.
- `tilt_angle` (default 0°): front-to-back tilt. At 0° the palm rest is the
  same height wherever your palm lands front to back.
- `palm_tent` (default 10°): sideways tilt of the palm rest alone. Across the
  pad centre its top runs from about 43 mm (outer edge) to 55 mm (inner edge).
  It pivots on the pad centre, so `palm_height` is unaffected.
- `palm_width` (default 76 mm): kept short of the thumb keys, so the raised palm
  rest doesn't sit right in front of them.
- `palm_gap`, `palm_width`: move the rest if it gets in the thumb's way.
- `pad_recess`, `pad_w`, `pad_d`: the palm pad recess (see below). `pad_recess = 0` removes it.

## Palm pads

Each palm rest has a 2 mm deep recess for a **58 × 56 mm** rounded-rectangle
pad. It's a plain rectangle so it's easy to cut, and easy to replace when it
wears out.

- **Material:** self-adhesive closed-cell foam sheet, 3 mm thick (neoprene or
  EPDM). A 300 × 200 mm sheet makes about 12 pads. With 3 mm foam the pad
  stands 1 mm proud of the plastic, so no hard edge touches your palm.
  Thicker or softer foam: set `pad_recess` to foam thickness − 1 mm.
- **Cutting:** print `out/palm_pad_template.svg` at 100 % (no "fit to page"),
  or just measure 58 × 56 mm with a ruler. Round the corners around a
  2-euro coin.
- **Kinesis's own pads** (AC005PP-BLK, 95 × 75 mm) are too big for this palm
  rest, and hard to find in Europe.

## Printing (A1 mini)

- PLA or PETG, 0.2 mm layers, 3 walls, 10–15 % gyroid infill.
- Print flat on its base, no supports. The USB and finger notches are open at the top.
- About 170–200 g and roughly 7–9 h per half.
- Optional: 10 mm silicone bumpons in the five recesses underneath.

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
