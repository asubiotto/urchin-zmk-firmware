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
part = "bottom"; // [bottom, top, both_closed_preview]

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
band_w = 8;
band_d = 1.0;

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

module tray(lip) {
    difference() {
        union() {
            linear_extrude(tray_h) outer2d();
            if (lip == "lip")
                translate([0, 0, tray_h - eps]) linear_extrude(lip_h + eps)
                    difference() { case2d(lip_in + lip_w); case2d(lip_in); }
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
