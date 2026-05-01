// Cisco AP HomeRacker Mount
//
// CC BY-SA 4.0
//
// Slider/keyhole dimensions are based on "Cisco AIR-AP-BRACKET-1"
// by nicba1010, Thingiverse thing 5491712, BSD licensed.

/* [Plate] */
plate_size = 142.5; // [120:0.1:180]
plate_thickness = 5; // [3:0.1:10]
plate_lip_thickness = 1; // [0.6:0.1:2]
plate_corner_radius = 20; // [4:0.1:35]

/* [Cisco AP Slider Holes] */
slider_holes_span = 108; // [80:0.1:130]
slider_big_diameter = 10.5; // [8:0.1:14]
slider_small_diameter = 7; // [5:0.1:10]
slider_length = 21.25; // [16:0.1:30]
slider_clearance = 0.25; // [0:0.05:1]
slider_recess_scale = 1.1; // [1:0.01:1.25]

/* [Ventilation] */
vent_enabled = true; // [false,true]
vent_rows = 3; // [1:1:7]
vent_columns = 7; // [3:1:11]
vent_slot_length = 16; // [8:0.1:28]
vent_slot_width = 4; // [2:0.1:8]
vent_spacing_x = 16; // [8:0.1:24]
vent_spacing_y = 15; // [8:0.1:24]

/* [HomeRacker Sleeve] */
sleeve_units = 9; // [3:1:12]
sleeve_wall = 2; // [1.2:0.1:4]
sleeve_tolerance = 0.2; // [0:0.05:0.6]
lockpin_holes_enabled = true; // [false,true]

/* [Debug] */
debug_colors = false; // [false,true]
disable_chamfer = false; // [false,true]

/* [Hidden] */
$fn = 100;
EPSILON = 0.01;

// HomeRacker-compatible dimensions, mirrored locally so the model also
// compiles when opened directly in the OpenSCAD GUI.
BASE_UNIT = 15;
BASE_STRENGTH = 2;
BASE_CHAMFER = 1;
TOLERANCE = 0.2;
LOCKPIN_HOLE_SIDE_LENGTH = 4;
LOCKPIN_HOLE_CHAMFER = 0.8;
HR_BLUE = "#0056b3";
HR_YELLOW = "#f7b600";
HR_CHARCOAL = "#333333";

LOCKPIN_SIDE = LOCKPIN_HOLE_SIDE_LENGTH;
LOCKPIN_CHAMFER = LOCKPIN_HOLE_CHAMFER;
SLEEVE_INNER_SIDE = BASE_UNIT + sleeve_tolerance;
SLEEVE_OUTER_WIDTH = BASE_UNIT + 2 * sleeve_wall + sleeve_tolerance;
SLEEVE_OUTER_HEIGHT = BASE_UNIT + sleeve_wall + sleeve_tolerance;
SLEEVE_LENGTH = sleeve_units * BASE_UNIT - sleeve_tolerance;
PLATE_BODY_THICKNESS = plate_thickness - plate_lip_thickness;

module centered_box(size) {
    cube(size, center = true);
}

module rounded_plate_2d(size, radius) {
    safe_radius = min(radius, size / 2 - EPSILON);
    hull() {
        for (x = [-1, 1], y = [-1, 1]) {
            translate([x * (size / 2 - safe_radius), y * (size / 2 - safe_radius)])
                circle(r = safe_radius);
        }
    }
}

module slider_hole_2d(recess = false) {
    big_d = slider_big_diameter + slider_clearance;
    small_d = slider_small_diameter + slider_clearance;
    square_len = slider_length - (big_d / 2 + small_d / 2);

    scale(recess ? slider_recess_scale : 1)
    translate([0, -slider_length / 2])
    union() {
        if (recess) {
            translate([0, slider_length - big_d / 2])
                circle(d = big_d);
            translate([0, big_d / 2])
                circle(d = big_d);
            translate([0, slider_length - big_d])
                square([big_d, slider_length - big_d + EPSILON], center = true);
        } else {
            translate([0, slider_length - big_d / 2])
                circle(d = big_d);
            translate([0, small_d / 2])
                circle(d = small_d);
            translate([0, slider_length - (big_d / 2 + square_len / 2)])
                square([small_d, square_len + EPSILON], center = true);
        }
    }
}

module slider_holes_2d(recess = false) {
    for (x = [-1, 1], y = [-1, 1]) {
        translate([x * slider_holes_span / 2, y * slider_holes_span / 2])
            slider_hole_2d(recess);
    }
}

module vent_slot_2d() {
    hull() {
        translate([-vent_slot_length / 2 + vent_slot_width / 2, 0])
            circle(d = vent_slot_width);
        translate([vent_slot_length / 2 - vent_slot_width / 2, 0])
            circle(d = vent_slot_width);
    }
}

module vent_holes_2d() {
    if (vent_enabled) {
        for (row = [0 : vent_rows - 1], col = [0 : vent_columns - 1]) {
            x = (col - (vent_columns - 1) / 2) * vent_spacing_x;
            y = (row - (vent_rows - 1) / 2) * vent_spacing_y;
            // Keep vents away from the AP slider/keyhole cluster corners.
            if (abs(x) < slider_holes_span / 2 - 14 || abs(y) < slider_holes_span / 2 - 22) {
                translate([x, y])
                    vent_slot_2d();
            }
        }
    }
}

module plate_layer_2d(recess = false) {
    difference() {
        rounded_plate_2d(plate_size, plate_corner_radius);
        slider_holes_2d(recess);
        vent_holes_2d();
    }
}

module ap_plate() {
    color(debug_colors ? HR_BLUE : HR_CHARCOAL)
    union() {
        linear_extrude(PLATE_BODY_THICKNESS)
            plate_layer_2d(recess = true);
        translate([0, 0, PLATE_BODY_THICKNESS])
            linear_extrude(plate_lip_thickness)
            plate_layer_2d(recess = false);
    }
}

module lockpin_hole() {
    centered_box([SLEEVE_OUTER_WIDTH + EPSILON, LOCKPIN_SIDE, LOCKPIN_SIDE]);
}

module lockpin_holes() {
    if (lockpin_holes_enabled) {
        for (y = [-(sleeve_units - 1) / 2 : 1 : (sleeve_units - 1) / 2]) {
            translate([0, y * BASE_UNIT, SLEEVE_OUTER_HEIGHT - BASE_UNIT / 2])
                lockpin_hole();
        }
    }
}

module homeracker_sleeve() {
    color(debug_colors ? HR_YELLOW : HR_YELLOW)
    difference() {
        translate([0, 0, SLEEVE_OUTER_HEIGHT / 2])
            centered_box([SLEEVE_OUTER_WIDTH, SLEEVE_LENGTH, SLEEVE_OUTER_HEIGHT]);

        translate([0, 0, SLEEVE_INNER_SIDE / 2 - EPSILON])
            centered_box([SLEEVE_INNER_SIDE, SLEEVE_LENGTH + 2 * EPSILON, SLEEVE_INNER_SIDE + 2 * EPSILON]);

        lockpin_holes();
    }
}

module mount() {
    assert(plate_size > slider_holes_span + slider_big_diameter + 8, "Plate is too small for slider-hole span.");
    assert(plate_lip_thickness > 0 && plate_lip_thickness < plate_thickness, "Plate lip thickness must be less than total plate thickness.");
    assert(sleeve_units > 0, "Sleeve units must be positive.");
    assert(vent_slot_length >= vent_slot_width, "Vent slot length must be greater than or equal to vent slot width.");

    union() {
        homeracker_sleeve();
        translate([0, 0, SLEEVE_OUTER_HEIGHT])
            ap_plate();
    }
}

mount();
