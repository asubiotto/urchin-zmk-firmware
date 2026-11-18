// Urchin travel case: a clamshell of two trays.
// Each tray holds one half face-up with the keycaps below the rim. The halves
// are mirror images, so the trays close face to face and line up exactly.
// The bottom tray has a raised lip that fits into a groove in the top tray.
//
// Fits a Bambu Lab A1 mini. Print both trays open side up, no supports.
// Uses the same case_wall / clearance as urchin_stand.scad, so if the stand's
// fit-test ring fits your case, these pockets will too.

include <urchin_outline.scad>

/* [What to print] */
part = "bottom"; // [bottom, top, both_closed_preview, open_preview]

/* [Your Urchin case — same values as the stand] */
// How far the case sticks out past the PCB edge, per side (mm)
case_wall = 3.0;
// Extra gap around the case so it drops in (mm)
clearance = 0.6;
// Desk to top of the home-row keycaps, case flat on the desk (mm)
key_top_height = 15;
// Tallest point of the half (MCU, nice!view or keycap), if higher than the keys
tallest_point = 15;

/* [Case] */
// Gap between the tallest point and the tray rim (mm)
top_gap = 1.0;
// Side wall thickness (mm)
wall = 4.0;
// Floor thickness (mm)
floor_t = 1.6;
// Lip height on the bottom tray (mm)
lip_h = 2.5;
// Lip width (mm)
lip_w = 1.2;
// Lip-to-groove gap per side. Raise if too tight, lower if it rattles
lip_fit = 0.15;
// Finger notch to lift the half out (width, mm)
notch_w = 22;
// Groove for a rubber band / elastic strap around the closed case (mm), 0 = none
band_w = 0;
band_d = 1.0;

/* [Hinge (back edge)] */
hinge = true;
// Pin hole. 2.0 suits a piece of 1.75 mm filament as the pin
pin_d = 2.0;
// Knuckle radius (mm)
knuckle_r = 4;
// Gap between knuckles of the two trays (mm)
knuckle_gap = 0.4;
// Hinge span along the back edge, in tray x (mm)
hinge_x0 = 17;
hinge_x1 = 77;

/* [Latch (front edge)] */
latch = true;
// Snap tab width (mm)
tab_w = 14;
// Snap tab thickness: thinner = easier to open (mm)
tab_t = 1.6;
// How far the tooth hooks into the other tray (mm)
tooth = 1.0;

// outline landmarks (outer wall), measured from urchin_outline.scad
back_y = 97.2;   // highest point of the back edge
front_y = 5.9;   // flat stretch of the front edge, x = 25..55
latch_x = 40;

$fn = 64;
eps = 0.01;

case_off = case_wall + clearance;
pocket_h = max(key_top_height, tallest_point) + top_gap;
tray_h = floor_t + pocket_h;

module pcb() { polygon(URCHIN_PCB_LEFT); }
// case outline grown by `extra` beyond the pocket wall
module case2d(extra = 0) {
    offset(r = case_off + extra) offset(delta = -8) offset(delta = 8) pcb();
}
module outer2d() { offset(r = 2) offset(delta = -2) case2d(wall); }

// lip ring sits in the middle of the wall
lip_in = (wall - lip_w) / 2;

// ---------- hinge ----------
axis_y = back_y + 1 + knuckle_r;
seg = (hinge_x1 - hinge_x0) / 3;
// bottom tray gets the two outer knuckles, top tray the middle one
function knuckles(lip) = lip == "lip"
    ? [[hinge_x0, hinge_x0 + seg - knuckle_gap / 2], [hinge_x1 - seg + knuckle_gap / 2, hinge_x1]]
    : [[hinge_x0 + seg + knuckle_gap / 2, hinge_x1 - seg - knuckle_gap / 2]];
module knuckle_body(x0, x1) {
    translate([x0, 0, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) {
        // profile in (y, z): rounded knuckle on a post, plus a web into the wall
        hull() {
            translate([axis_y, tray_h]) circle(r = knuckle_r);
            translate([axis_y - knuckle_r, 0]) square([knuckle_r, tray_h]);
        }
        translate([axis_y - 25, 0]) square([25, tray_h]);
    }
}
module pin_hole() {
    translate([hinge_x0 - 1, axis_y, tray_h]) rotate([0, 90, 0])
        cylinder(d = pin_d, h = hinge_x1 - hinge_x0 + 2, $fn = 24);
}

// ---------- latch ----------
// snap tab on the bottom tray: stands 0.8 mm off the front wall, joined at the foot
tab_gap = 0.8;
tooth_z = tray_h + 4;      // flat underside of the tooth (world height)
tab_top = tray_h + 9;
module snap_tab() {
    yo = front_y - tab_gap - tab_t;
    translate([latch_x - tab_w / 2, 0, 0]) rotate([90, 0, 90]) linear_extrude(tab_w) {
        translate([yo, 0]) square([tab_t, tab_top]);                    // tab
        translate([yo, 0]) square([tab_t + tab_gap + 0.5, 3]);          // foot into the wall
        polygon([[yo + tab_t - eps, tooth_z], [front_y + tooth, tooth_z],
                 [yo + tab_t - eps, tooth_z + 2.5]]);                   // tooth: flat catch, ramp on top
    }
}
// matching recess in the top tray's front wall (top-tray coordinates, before flipping)
module latch_recess() {
    z_lo = 2 * tray_h - (tooth_z + 3);
    z_hi = 2 * tray_h - (tooth_z - 0.3);
    translate([latch_x - tab_w / 2 - 1, front_y - 1, z_lo])
        cube([tab_w + 2, 1 + tooth + 0.2, z_hi - z_lo]);
}

module tray(lip) {
    difference() {
        union() {
            linear_extrude(tray_h) outer2d();
            if (hinge) for (k = knuckles(lip)) knuckle_body(k[0], k[1]);
            if (latch && lip == "lip") snap_tab();
            if (lip == "lip")
                translate([0, 0, tray_h - eps]) linear_extrude(lip_h + eps)
                    difference() {
                        case2d(lip_in + lip_w); case2d(lip_in);
                        // no lip along the back: it would bind as the hinge swings,
                        // and the hinge already keeps that edge aligned
                        if (hinge) translate([-50, back_y - 22]) square([300, 100]);
                    }
        }
        // pocket
        translate([0, 0, floor_t]) linear_extrude(tray_h + lip_h + 1) case2d();
        // groove for the other tray's lip
        if (lip == "groove")
            translate([0, 0, tray_h - lip_h - 0.4]) linear_extrude(lip_h + 1)
                difference() { case2d(lip_in + lip_w + lip_fit); case2d(lip_in - lip_fit); }
        // finger notch on the outer (left) side
        translate([-wall - case_off - 1, 45 - notch_w / 2, floor_t + 3])
            cube([wall + case_off + 2, notch_w, tray_h]);
        if (hinge) pin_hole();
        if (latch && lip == "groove") latch_recess();
        // band groove across the bottom, front to back
        if (band_w > 0)
            translate([42 - band_w / 2, -50, -eps]) cube([band_w, 300, band_d]);
    }
}

// bottom tray: holds the RIGHT half (mirror of the left outline), has the lip
module bottom() { mirror([1, 0, 0]) tray("lip"); }
// top tray: holds the LEFT half, has the groove. Flip it over to close.
module top() { tray("groove"); }

if (part == "bottom") bottom();
if (part == "top") top();
if (part == "both_closed_preview") {
    color("teal") bottom();
    // flip the top tray about the y axis onto the bottom one
    color("orange", 0.6) translate([0, 0, 2 * tray_h]) rotate([0, 180, 0]) top();
}
if (part == "open_preview") {
    color("teal") bottom();
    color("orange") translate([0, axis_y, tray_h]) rotate([-150, 0, 0]) translate([0, -axis_y, -tray_h])
        translate([0, 0, 2 * tray_h]) rotate([0, 180, 0]) top();
}
