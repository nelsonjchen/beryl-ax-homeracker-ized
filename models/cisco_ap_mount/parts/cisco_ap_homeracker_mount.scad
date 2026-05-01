// Cisco AP HomeRacker Mount
//
// CC BY-SA 4.0
//
// Slider/keyhole dimensions are based on "Cisco AIR-AP-BRACKET-1"
// by nicba1010, Thingiverse thing 5491712, BSD licensed.

/* [Bracket] */
plate_size = 142.5; // [120:0.1:180]
plate_thickness = 5; // [3:0.1:10]
plate_lip_thickness = 1; // [0.6:0.1:2]
corner_pad_diameter = 32; // [24:0.1:48]
spine_width = 24; // [16:0.1:36]
rib_width = 13; // [8:0.1:24]
end_rail_width = 12; // [8:0.1:24]
skeleton_corner_radius = 6; // [2:0.1:12]

/* [Cisco AP Slider Holes] */
slider_holes_span = 108; // [80:0.1:130]
slider_big_diameter = 10.5; // [8:0.1:14]
slider_small_diameter = 10.5*(22/36); // [5:0.1:10]
slider_length = 21.25; // [16:0.1:30]
slider_clearance = 0.25; // [0:0.05:1]
slider_recess_scale = 1.1; // [1:0.01:1.25]

/* [AP Retention Detent] */
detent_enabled = true; // [false,true]
detent_depth = 0.5; // [0.1:0.05:1.2]
detent_length = 2.6; // [1:0.1:5]
detent_clearance_from_seat = 0; // [0:0.1:4]

/* [HomeRacker Sleeve] */
sleeve_units = 9; // [3:1:12]
sleeve_holes_per_end = 2; // [1:1:4]
sleeve_roof_overhang = 4; // [0:0.1:10]
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
SLEEVE_SIDE_HEIGHT = SLEEVE_INNER_SIDE;
SLEEVE_ATTACH_OVERLAP = 0.05;
SLEEVE_SEGMENT_LENGTH = sleeve_holes_per_end * BASE_UNIT - sleeve_tolerance;
SLEEVE_ROOF_SEGMENT_LENGTH = SLEEVE_SEGMENT_LENGTH + 2 * sleeve_roof_overhang;
SLEEVE_SEGMENT_OFFSET = (sleeve_units - sleeve_holes_per_end) * BASE_UNIT / 2;
SLEEVE_LOCKPIN_CENTER_Z = BASE_UNIT / 2 + sleeve_tolerance / 2;
PLATE_BODY_THICKNESS = plate_thickness - plate_lip_thickness;

module centered_box(size) {
    cube(size, center = true);
}

module rounded_rect_2d(size, radius) {
    safe_radius = min(radius, min(size[0], size[1]) / 2 - EPSILON);
    offset(r = safe_radius)
        square([size[0] - 2 * safe_radius, size[1] - 2 * safe_radius], center = true);
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

module detent_bump_2d() {
    small_d = slider_small_diameter + slider_clearance;
    small_circle_center_y = -slider_length / 2 + small_d / 2;
    detent_y = small_circle_center_y + detent_clearance_from_seat + detent_length / 2;

    difference() {
        union() {
            for (side = [-1, 1]) {
                translate([side * small_d / 2, detent_y])
                    rounded_rect_2d([2 * detent_depth, detent_length], detent_depth);
            }
        }

        translate([0, small_circle_center_y])
            circle(d = small_d);
    }
}

module slider_cutout_2d(recess = false) {
    if (detent_enabled && !recess) {
        difference() {
            slider_hole_2d(recess);
            detent_bump_2d();
        }
    } else {
        slider_hole_2d(recess);
    }
}

module slider_holes_2d(recess = false) {
    for (x = [-1, 1], y = [-1, 1]) {
        translate([x * slider_holes_span / 2, y * slider_holes_span / 2])
            slider_cutout_2d(recess);
    }
}

module rib_between_2d(start, end, width) {
    hull() {
        translate(start)
            circle(d = width);
        translate(end)
            circle(d = width);
    }
}

module sleeve_segments_2d(width) {
    for (y = [-1, 1]) {
        translate([0, y * SLEEVE_SEGMENT_OFFSET])
            rounded_rect_2d([width, SLEEVE_ROOF_SEGMENT_LENGTH], skeleton_corner_radius);
    }
}

module skeleton_base_2d() {
    union() {
        sleeve_segments_2d(spine_width);

        for (y = [-1, 1]) {
            translate([0, y * slider_holes_span / 2])
                rounded_rect_2d([plate_size - corner_pad_diameter, end_rail_width], skeleton_corner_radius);
        }

        for (x = [-1, 1], y = [-1, 1]) {
            pad_center = [x * slider_holes_span / 2, y * slider_holes_span / 2];
            translate(pad_center)
                circle(d = corner_pad_diameter);
            rib_between_2d([0, y * slider_holes_span / 2], pad_center, rib_width);
            rib_between_2d([x * slider_holes_span / 2, 0], pad_center, rib_width);
        }
    }
}

module bracket_layer_2d(recess = false) {
    difference() {
        skeleton_base_2d();
        slider_holes_2d(recess);
    }
}

module ap_bracket() {
    color(debug_colors ? HR_BLUE : HR_CHARCOAL)
    union() {
        linear_extrude(PLATE_BODY_THICKNESS)
            bracket_layer_2d(recess = true);
        translate([0, 0, PLATE_BODY_THICKNESS])
            linear_extrude(plate_lip_thickness)
            bracket_layer_2d(recess = false);
    }
}

module lockpin_hole() {
    centered_box([SLEEVE_OUTER_WIDTH + EPSILON, LOCKPIN_SIDE, LOCKPIN_SIDE]);
}

module lockpin_holes() {
    if (lockpin_holes_enabled) {
        for (segment_side = [-1, 1]) {
            for (hole = [0 : 1 : sleeve_holes_per_end - 1]) {
                local_y = (hole - (sleeve_holes_per_end - 1) / 2) * BASE_UNIT;

                translate([0, segment_side * SLEEVE_SEGMENT_OFFSET + local_y, SLEEVE_LOCKPIN_CENTER_Z])
                    lockpin_hole();
            }
        }
    }
}

module homeracker_sleeve() {
    color(debug_colors ? HR_YELLOW : HR_YELLOW)
    difference() {
        // The AP bracket's center spine acts as the sleeve roof.
        union() {
            for (segment_side = [-1, 1]) {
                for (wall_side = [-1, 1]) {
                    translate([
                        wall_side * (SLEEVE_INNER_SIDE / 2 + sleeve_wall / 2),
                        segment_side * SLEEVE_SEGMENT_OFFSET,
                        (SLEEVE_SIDE_HEIGHT + SLEEVE_ATTACH_OVERLAP) / 2
                    ])
                        centered_box([sleeve_wall, SLEEVE_SEGMENT_LENGTH, SLEEVE_SIDE_HEIGHT + SLEEVE_ATTACH_OVERLAP]);
                }
            }
        }

        lockpin_holes();
    }
}

module mount() {
    assert(plate_size >= slider_holes_span + corner_pad_diameter, "Bracket is too small for the corner pads.");
    assert(plate_lip_thickness > 0 && plate_lip_thickness < plate_thickness, "Plate lip thickness must be less than total plate thickness.");
    assert(corner_pad_diameter > slider_big_diameter * slider_recess_scale + 8, "Corner pads are too small for recessed slider holes.");
    assert(spine_width > SLEEVE_OUTER_WIDTH, "Spine width must be wider than the HomeRacker sleeve.");
    assert(detent_depth * 2 < slider_small_diameter + slider_clearance, "Detent bumps close the slider slot completely.");
    assert(sleeve_units > 0, "Sleeve units must be positive.");
    assert(sleeve_holes_per_end > 0, "At least one sleeve hole per end is required.");
    assert(sleeve_holes_per_end * 2 <= sleeve_units, "Sleeve end segments overlap; reduce holes per end or increase sleeve units.");
    assert(SLEEVE_ROOF_SEGMENT_LENGTH < sleeve_units * BASE_UNIT, "Sleeve roof overhang is too large.");

    union() {
        homeracker_sleeve();
        translate([0, 0, SLEEVE_SIDE_HEIGHT])
            ap_bracket();
    }
}

mount();
