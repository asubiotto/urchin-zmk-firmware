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
// Desk to top of the D key (mm). Advantage2: A, S, D ~30, F ~40. The board is placed so D lands here
d_key_height = 30;
// Desk to top of the palm pad at its back-inner corner, the corner nearest the F key (mm)
palm_back_inner = 50;
// Palm rest rises toward the keys. Advantage2: front 20/30 mm, back 40/50 mm = 20 mm over ~75 mm
palm_slope = 15; // [0:1:25]
// Palm rest rises toward the thumbs. Advantage2: 10 mm over ~95 mm
palm_side = 6; // [0:1:25]

/* [Ergonomics] */
// Tenting, inner (thumb) edge raised. 10.7 puts A 10 mm below F, as on your Advantage2
tent_angle = 10.7; // [0:0.1:35]
// Front-to-back tilt of the keyboard (the palm rest has its own palm_slope)
tilt_angle = 0; // [-10:1:10]
// How deep the case sits in the pocket (mm)
pocket_depth = 5;
// Palm rest depth toward you (mm)
palm_depth = 68;
// Palm rest width (mm). Its inner edge runs through the F key centre, like the Advantage2;
// it reaches past the board's outer edge by palm_width - ~63 mm
palm_width = 80;
// Gap between case front edge and palm rest, room for thumb knuckle (mm)
palm_gap = 7;
// Rounding on the palm rest top edges (mm)
palm_round = 6;
/* [Palm pad] */
// Recess depth for a stick-on foam pad, 0 = none. 2 mm suits 3 mm foam (pad stands 1 mm proud)
pad_recess = 2;
// Foam pad thickness (mm). palm heights are measured to the top of the pad
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
// home row centres A, S, D (SW6-SW8), from duckyb/urchin main.kicad_pcb
A_KEY = [9.1, 45.5]; S_KEY = [27.1, 57.5]; D_KEY = [45.1, 63.5];
// thumb keys (SW16 inner-left, SW17), for the clearance report
THUMBS = [[73.0, 19.8], [91.6, 12.1]];

// rotation used by tented(): rotate([tilt, -tent, 0]) = Ry(-tent) * Rx(tilt)
function Rx(a) = [[1, 0, 0], [0, cos(a), -sin(a)], [0, sin(a), cos(a)]];
function Ry(a) = [[cos(a), 0, sin(a)], [0, 1, 0], [-sin(a), 0, cos(a)]];
ROT = Ry(-tent_angle) * Rx(tilt_angle);
pivot_off = [case_off + rim, 0, 0];
// height of a local point above the deck pivot, before the base lift
function zr(p) = (ROT * (p + pivot_off))[2];

// 1) lift the stand so the D key top lands on d_key_height ...
base_for_d = d_key_height - zr([D_KEY[0], D_KEY[1], key_above_rim]);
// ... unless that would leave less than min_floor under the pocket
floor_pts = [for (x = [-case_off, pcb_w + case_off], y = [-case_off, pcb_h + case_off]) [x, y, -pocket_depth]];
base_for_floor = min_floor - min([for (p = floor_pts) zr(p)]);
base = max(base_for_d, base_for_floor);
function base_h() = base;

// 2) palm rest: a plane in desk coordinates, inner edge under the F key centre
function world(p) = ROT * (p + pivot_off) + [0, 0, base];
x_in = world([F_KEY[0], F_KEY[1], key_above_rim])[0];
x_out = x_in - palm_width;
y_front = -case_off - palm_depth;
y_back = 12.5 - case_off - palm_gap;            // back edge at the inner corner (PCB front edge there is y ~12.5)
pad_dz = pad_thickness - pad_recess;           // pad surface above the plastic
// height of the pad surface at a desk (x, y)
function palm_z(x, y) = palm_back_inner + (x - x_in) * tan(palm_side) + (y - y_back) * tan(palm_slope);
pad_x = (x_in + x_out) / 2 - pad_w / 2;
pad_y = -63;

echo(str("Tent: ", tent_angle, " deg"));
echo(str("Home row tops A S D F: ", [for (k = [A_KEY, S_KEY, D_KEY, F_KEY]) world([k[0], k[1], key_above_rim])[2]], " mm"));
echo(str("Palm pad top, front-outer / front-inner / back-inner / back-outer: ",
         [palm_z(x_out, y_front), palm_z(x_in, y_front), palm_z(x_in, y_back), palm_z(x_out, y_back)], " mm"));
echo(str("Palm pad centre: ", palm_z(pad_x + pad_w / 2, pad_y + pad_d / 2), " mm"));
echo(str("Thumb key tops: ", [for (t = THUMBS) world([t[0], t[1], key_above_rim])[2]], " mm"));
if (base_for_floor > base_for_d)
    echo("WARNING: D key sits higher than d_key_height, to keep min_floor under the pocket");

module pcb() { polygon(URCHIN_PCB_LEFT); }
// case outline: PCB grown by the wall, notches smoothed shut
module case2d(extra = 0) {
    offset(r = case_off + extra) offset(delta = -8) offset(delta = 8) pcb();
}
module deck2d() { case2d(rim); }
// the deck outline as seen from above, in desk coordinates
M2 = [[ROT[0][0], ROT[0][1], 0, (ROT * pivot_off)[0]], [ROT[1][0], ROT[1][1], 0, (ROT * pivot_off)[1]],
      [0, 0, 1, 0], [0, 0, 0, 1]];
module on_desk() { multmatrix(M2) children(); }
// palm rest footprint, desk coordinates
module palm2d() {
    difference() {
        translate([x_out, y_front]) offset(r = 10) offset(delta = -10) square([palm_width, palm_depth + 30]);
        // back edge follows the board's front swoop
        on_desk() case2d(palm_gap);
        translate([-100, 25]) square([400, 400]);
    }
}
// low web joining palm rest and deck so it prints as one piece
module bridge2d() {
    difference() {
        offset(r = -12) offset(r = 12) union() { on_desk() deck2d(); palm2d(); }
        on_desk() case2d(1);
    }
}
// shear flat z = 0 onto the palm plane (plastic top, pad_dz below the pad surface)
module palm_plane() {
    a = tan(palm_side); b = tan(palm_slope);
    multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [a, b, 1, palm_z(0, 0) - pad_dz], [0, 0, 0, 1]]) children();
}

// rounded-top extrusion of a 2D shape, height h, top edge radius r.
// Stacked thin layers rather than hull(), so concave outlines stay concave.
module rounded_slab(h, r, base = -150) {
    steps = 16;
    translate([0, 0, base]) linear_extrude(h - base - r + eps) children();
    for (i = [0 : steps - 1]) {
        a1 = 90 * (i + 1) / steps;
        z0 = h - r + r * sin(90 * i / steps); z1 = h - r + r * sin(a1);
        translate([0, 0, z0]) linear_extrude(z1 - z0 + eps) offset(delta = -(r - r * cos(a1))) children();
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
            union() {
                tented() translate([0, 0, -150]) linear_extrude(150) deck2d();
                palm_plane() rounded_slab(0, palm_round) palm2d();
                linear_extrude(base) bridge2d();
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
        }
        // stick-on pad recess
        if (pad_recess > 0) palm_plane()
            translate([0, 0, -pad_recess]) linear_extrude(50) offset(delta = pad_fit) pad2d();
        // bumpon recesses
        if (foot_recess_h > 0) for (p = feet()) translate([p[0], p[1], -eps])
            cylinder(d = foot_recess_d, h = foot_recess_h + eps);
    }
}
// desk-space foot spots (palm front-outer, palm front-inner, back-outer, back-inner, thumb corner)
function feet() = let(xd = world([pcb_w + case_off + rim, 0, 0])[0])
    [[x_out + 10, y_front + 10], [x_in - 10, y_front + 10],
     [10, 82], [xd - 22, 66], [xd - 18, 2]];

module left() { stand_left(); }

// the pad: rounded rectangle on the palm rest, desk coordinates
module pad2d() {
    translate([pad_x, pad_y]) offset(r = pad_corner) offset(delta = -pad_corner) square([pad_w, pad_d]);
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
