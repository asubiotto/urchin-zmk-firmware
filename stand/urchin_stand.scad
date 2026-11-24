// Urchin tenting stand + palm rest (one per half)
// Fits a Bambu Lab A1 mini (180 x 180 x 180 mm). Open in OpenSCAD, use the
// Customizer panel to change values, F6 render, then File > Export > STL.
//
// The pocket follows the real Urchin PCB outline (duckyb/urchin), grown by the
// case wall. Measure your case and print the "fit_test" part first (~10 min).

include <urchin_outline.scad>

/* [What to print] */
part = "left"; // [left, right, fit_test_left, fit_test_right, pad_template]

/* [Your Urchin case — measure these] */
// How far the case sticks out past the PCB edge, per side (mm)
case_wall = 3.0;
// Extra gap around the case so it drops in (mm)
clearance = 0.6;
// Desk to top of the home-row keycaps with the case flat on the desk (mm). NOT YET MEASURED: this shifts every key height 1:1
key_top_height = 15;

/* [Targets: measured on your Kinesis Advantage2] */
// Desk to top of the F key (mm)
f_key_height = 40;
// Desk to top of the palm pad, at its centre (mm)
palm_height = 50;

/* [Ergonomics] */
// Tenting: inner (thumb) edge raised. Advantage2 spec: 20 deg
tent_angle = 20; // [0:1:35]
// Front-to-back tilt. 0 keeps the palm rest the same height wherever your palm lands
tilt_angle = 0; // [-10:1:10]
// How deep the case sits in the pocket (mm)
pocket_depth = 5;
// Sideways tilt of the palm rest only. Lower than tent_angle keeps its outer edge from dropping low; it pivots on the pad centre, so the palm-to-keys drop stays the same
palm_tent = 10; // [0:1:35]
// Palm rest depth toward you (mm)
palm_depth = 68;
// Palm rest width, from the outer edge inward (mm). Keep it short of the thumb keys
palm_width = 76;
// Gap between case front edge and palm rest, room for thumb knuckle (mm)
palm_gap = 7;
// Rounding on the palm rest top edges (mm)
palm_round = 6;
/* [Palm pad] */
// Recess depth for a stick-on foam pad, 0 = none. 2 mm suits 3 mm foam (pad stands 1 mm proud)
pad_recess = 2;
// Foam pad thickness (mm). palm_height is measured to the top of the pad
pad_thickness = 3;
// Pad size: a plain rounded rectangle, easy to cut from a foam sheet (mm)
pad_w = 58;
pad_d = 56;
// Corner radius (mm). Round a cut pad's corners around a 2-euro coin (~13 mm)
pad_corner = 6.5;
// Gap around the pad inside the recess (mm)
pad_fit = 0.5;

/* [Stand body] */
// Rim around the case (mm)
rim = 4;
// Thickness under the pocket at its lowest corner (mm)
min_floor = 3;
// Bumpon recesses on the bottom (10 mm silicone feet), 0 = none
foot_recess_d = 10.5;
foot_recess_h = 1.0;
// Cable/charging slot at the nice!nano USB port
usb_slot = true;

$fn = 48;
eps = 0.01;

// ---------- derived ----------
pcb_w = 109.3;
pcb_h = 89.6;
case_off = case_wall + clearance;
// local frame: x right, y away from you, z = 0 at the pocket rim, before tenting
key_above_rim = key_top_height - pocket_depth;
// F key centre on the left half, from duckyb/urchin main.kicad_pcb (SW9)
F_KEY = [63.1, 57.0];
// thumb keys (SW16 inner-left, SW17), for the clearance report
THUMBS = [[73.0, 19.8], [91.6, 12.1]];

// rotation used by tented(): rotate([tilt, -tent, 0]) = Ry(-tent) * Rx(tilt)
function Rx(a) = [[1, 0, 0], [0, cos(a), -sin(a)], [0, sin(a), cos(a)]];
function Ry(a) = [[cos(a), 0, sin(a)], [0, 1, 0], [-sin(a), 0, cos(a)]];
ROT = Ry(-tent_angle) * Rx(tilt_angle);
pivot_off = [case_off + rim, 0, 0];
// height of a local point above the deck pivot, before the base lift
function zr(p) = (ROT * (p + pivot_off))[2];

// 1) lift the stand so the F key top lands on f_key_height ...
base_for_f = f_key_height - zr([F_KEY[0], F_KEY[1], key_above_rim]);
// ... unless that would leave less than min_floor under the pocket
floor_pts = [for (x = [-case_off, pcb_w + case_off], y = [-case_off, pcb_h + case_off]) [x, y, -pocket_depth]];
base_for_floor = min_floor - min([for (p = floor_pts) zr(p)]);
base = max(base_for_f, base_for_floor);
function base_h() = base;

// 2) raise the palm rest so the pad surface at its centre lands on palm_height
pad_c = [1 + pad_w / 2, -63 + pad_d / 2];
pad_dz = pad_thickness - pad_recess;           // pad surface above the palm rest top
d_tent = tent_angle - palm_tent;
row = ROT[2];
palm_raise = (palm_height - base
              - row[0] * (pad_c[0] + pad_dz * sin(d_tent) + pivot_off[0])
              - row[1] * pad_c[1]
              - row[2] * pad_dz * cos(d_tent)) / row[2];

echo(str("F key top: ", base + zr([F_KEY[0], F_KEY[1], key_above_rim]), " mm (target ", f_key_height, ")"));
echo(str("Palm pad centre: ", palm_height, " mm; palm rest ", palm_raise - key_above_rim, " mm above the key plane"));
echo(str("Thumb key tops: ", [for (t = THUMBS) base + zr([t[0], t[1], key_above_rim])], " mm"));
if (base_for_floor > base_for_f)
    echo("WARNING: F key sits higher than f_key_height, to keep min_floor under the pocket");

module pcb() { polygon(URCHIN_PCB_LEFT); }
// case outline: PCB grown by the wall, notches smoothed shut
module case2d(extra = 0) {
    offset(r = case_off + extra) offset(delta = -8) offset(delta = 8) pcb();
}
module deck2d() { case2d(rim); }
// whole footprint: deck + palm, bridged so it prints as one piece
module base2d() { offset(r = -12) offset(r = 12) union() { deck2d(); palm2d(); } }
module palm2d() {
    difference() {
        // rounded block in front of the board
        translate([-case_off - rim, -case_off - palm_depth])
            offset(r = 10) offset(delta = -10)
                square([palm_width, palm_depth + 30]);
        // back edge follows the board's front swoop
        case2d(palm_gap);
        // nothing behind the swoop
        translate([-100, 25]) square([400, 400]);
    }
}

// rounded-top extrusion of a 2D shape, height h, top edge radius r
module rounded_slab(h, r, base = -150) {
    steps = 10;
    translate([0, 0, base]) linear_extrude(h - base - r + eps) children();
    for (i = [0 : steps - 1]) {
        a0 = 90 * i / steps; a1 = 90 * (i + 1) / steps;
        z0 = h - r + r * sin(a0); z1 = h - r + r * sin(a1);
        inset = r - r * cos(a1);
        hull() {
            translate([0, 0, z0]) linear_extrude(eps) offset(delta = -(r - r * cos(a0))) children();
            translate([0, 0, z1 - eps]) linear_extrude(eps) offset(delta = -inset) children();
        }
    }
}

// maps the flat local frame onto the tented/tilted deck
module tented() {
    // pivot on the outer edge so the outer side stays low
    translate([0, 0, base_h()])
        rotate([tilt_angle, -tent_angle, 0])
            translate(pivot_off) children();
}

module stand_left() {
    difference() {
        intersection() {
            tented() union() {
                translate([0, 0, -150]) linear_extrude(150) base2d();
                palm_frame() rounded_slab(palm_raise, palm_round) palm2d();
            }
            // keep everything above the desk
            translate([-500, -500, 0]) cube([1000, 1000, 400]);
        }
        tented() {
            // pocket
            translate([0, 0, -pocket_depth]) linear_extrude(200) case2d();
            // finger notch on the outer edge to lift the board out
            translate([-case_off - rim, 50, -pocket_depth + 1.5])
                rotate([0, 90, 0]) cylinder(d = 26, h = 2 * (case_off + rim), center = true);
            // USB-C slot at the nice!nano
            if (usb_slot)
                translate([93, 55, -pocket_depth + 1.5]) cube([17, 60, 50]);
            // stick-on pad recess
            if (pad_recess > 0) palm_frame()
                translate([0, 0, palm_raise - pad_recess])
                    linear_extrude(50) offset(delta = pad_fit) pad2d();
        }
        // bumpon recesses
        if (foot_recess_h > 0) for (p = feet()) translate([p[0], p[1], -eps])
            cylinder(d = foot_recess_d, h = foot_recess_h + eps);
    }
}
// world-space foot spots (front-outer, front-inner, back-outer, back-inner, thumb corner)
function feet() = let(xin = (pcb_w + 2 * (case_off + rim)) * cos(tent_angle))
    [[10, -case_off - palm_depth + 10], [(palm_width - 15) * cos(tent_angle), -case_off - palm_depth + 10],
     [10, 82], [xin - 22, 66], [xin - 18, 2]];

module left() { stand_left(); }

// re-tilts the palm rest from tent_angle to palm_tent, pivoting on the pad centre
module palm_frame() {
    px = 1 + pad_w / 2;
    translate([px, 0, palm_raise]) rotate([0, tent_angle - palm_tent, 0])
        translate([-px, 0, -palm_raise]) children();
}

// the pad: rounded rectangle on the flat top of the palm rest
module pad2d() {
    translate([1, -63]) offset(r = pad_corner) offset(delta = -pad_corner) square([pad_w, pad_d]);
}
// 1:1 cutting template (export as SVG, print at 100 %)
module pad_template() {
    difference() { offset(delta = 0.3) pad2d(); offset(delta = -0.3) pad2d(); }
}

module fit_test() {
    linear_extrude(2.4) difference() { deck2d(); case2d(); }
}

if (part == "left")  left();
if (part == "right") mirror([1, 0, 0]) left();
if (part == "pad_template") pad_template();
if (part == "fit_test_left")  fit_test();
if (part == "fit_test_right") mirror([1, 0, 0]) fit_test();
