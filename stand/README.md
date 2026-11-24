# Urchin tenting stand with palm rest

![Left stand](out/preview.png)

One stand per half. It tents the board, holds the case in a pocket, and puts a
palm rest in front at about home-row height, like the pads on a Kinesis
Advantage. Each half is 141 × 169 × 47 mm, so it fits a **Bambu Lab A1 mini**
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

The stand is designed backwards from measurements on an Advantage2, desk to
top (left half, with the foam pad):

| | Advantage2 (measured) | Stand |
|---|---|---|
| D key | ~30 mm | `d_key_height` = 30 |
| F key | ~40 mm (highest key) | 33 mm |
| S key | ~30 mm | 27 mm |
| A key | ~30 mm | 23 mm |
| Palm rest, back-inner corner | ~50 mm | `palm_back_inner` = 50 |
| Palm rest, back-outer | ~40 mm | 42 mm |
| Palm rest, front-inner | ~30 mm | 30 mm |
| Palm rest, front-outer | ~20 mm | 22 mm |
| Palm rest inner edge | runs through the F key centre | same |
| Keyboard tent | F→A drops 10 mm | `tent_angle` = 10.7° (same 10 mm drop) |

The Advantage2's palm rest isn't flat. Its four corners lie on one plane
that rises about 20 mm toward the keys over ~75 mm (`palm_slope` = 15°)
and about 10 mm toward the thumbs over ~95 mm (`palm_side` = 6°). The stand's
palm rest uses the same plane, anchored at the back-inner corner. It's 80 mm wide
against the Kinesis's ~95 mm, so the front-outer corner ends up 2 mm higher.

**Why not Kinesis's 20°?** That figure describes how far the key wells are
tipped, not the key tops. Inside the curved wells S and D sit deeper than F,
so on your board the home-row tops only drop 10 mm from F to A, which works
out to about 10.7° across a flat row. At 20° the pinky ended up 20 mm off the desk.

A flat board can't copy the well's curve, so the stand keeps the 10 mm F-to-A
drop and is placed so D, the middle finger, matches the Advantage2 at 30 mm.
F and A each come out about 7 mm lower than on the Kinesis.

The palm rest is tilted separately from the board, in desk coordinates. It
rises 6° toward the thumbs (`palm_side`) and 15° toward the keys (`palm_slope`),
anchored at 50 mm on its back-inner corner. The OpenSCAD console prints every
key and palm-corner height.

## Settings worth trying

- `d_key_height`, `palm_back_inner`: the 20 mm drop between them puts the keys
  below your wrist, like the Advantage2's key wells.
- `palm_slope`, `palm_side`: the palm rest's own tilts, independent of the board.
- `tent_angle` (default 10.7°): keyboard tent. It pivots around D, so more tent raises F and lowers A.
- `tilt_angle` (default 0°): front-to-back tilt of the board only.
- `palm_width` (default 80 mm): the inner edge stays on the F key, so this
  sets how far the rest reaches past the board's outer edge. It stops short
  of the thumb keys.
- `palm_gap`: room for the thumb knuckle between palm rest and board.
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
