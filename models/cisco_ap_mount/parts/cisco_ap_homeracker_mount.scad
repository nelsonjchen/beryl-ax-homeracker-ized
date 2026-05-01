// Cisco AP HomeRacker Mount
//
// CC BY-SA 4.0
//
// Slider/keyhole dimensions are based on "Cisco AIR-AP-BRACKET-1"
// by nicba1010, Thingiverse thing 5491712, BSD licensed.

/* [Bracket] */
plate_size = 142.5; // [120:0.1:180]
plate_thickness = 3; // [2:0.1:10]
plate_lip_thickness = 1; // [0.6:0.1:2]
corner_pad_diameter = 32; // [24:0.1:48]
spine_width = 24; // [16:0.1:36]
rib_width = 13; // [8:0.1:24]
end_rail_width = 12; // [8:0.1:24]
skeleton_corner_radius = 6; // [2:0.1:12]
part_mode = 0; // [0:Full mount,1:Two-piece pair,2:Left clip,3:Right clip]

/* [Cisco AP Slider Holes] */
slider_holes_span = 108; // [80:0.1:130]
slider_big_diameter = 10.5; // [8:0.1:14]
slider_small_diameter = 6.6; // [5:0.1:10]
clip_slider_small_diameter = 6.42; // [5:0.1:10]
slider_length = 21.25; // [16:0.1:30]
slider_clearance = 0.25; // [0:0.05:1]
slider_recess_scale = 1.1; // [1:0.01:1.25]

/* [AP Retention Detent] */
detent_enabled = true; // [false,true]
detent_depth = 0.25; // [0.1:0.05:1.2]
clip_detent_depth = 0.4; // [0.1:0.05:1.2]
detent_length = 2.6; // [1:0.1:5]
detent_clearance_from_seat = 0; // [0:0.1:4]

/* [Production Label] */
label_enabled = true; // [false,true]
label_size = 4; // [2:0.1:6]
identity_label_size = 3.6; // [2:0.1:6]
repo_label_size = 2.8; // [1.5:0.1:4]
label_depth = 0.35; // [0.1:0.05:0.8]
clip_label_size = 2.8; // [2:0.1:5]

/* [HomeRacker Sleeve] */
sleeve_units = 9; // [3:1:12]
sleeve_holes_per_end = 2; // [1:1:4]
sleeve_roof_overhang = 4; // [0:0.1:10]
sleeve_rotation = 90; // [0,90]
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
BRACKET_WHITE = "#f5f5f0";

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
CLIP_ARM_LABEL_OFFSET = (spine_width / 2 + slider_holes_span / 2 - corner_pad_diameter / 2) / 2;
ACTIVE_SLIDER_SMALL_DIAMETER = part_mode == 0 ? slider_small_diameter : clip_slider_small_diameter;
ACTIVE_DETENT_DEPTH = part_mode == 0 ? detent_depth : clip_detent_depth;

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
    small_d = ACTIVE_SLIDER_SMALL_DIAMETER + slider_clearance;
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
    small_d = ACTIVE_SLIDER_SMALL_DIAMETER + slider_clearance;
    small_circle_center_y = -slider_length / 2 + small_d / 2;
    detent_y = small_circle_center_y + detent_clearance_from_seat + detent_length / 2;

    difference() {
        union() {
            for (side = [-1, 1]) {
                translate([side * small_d / 2, detent_y])
                    rounded_rect_2d([2 * ACTIVE_DETENT_DEPTH, detent_length], ACTIVE_DETENT_DEPTH);
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

module slider_holes_for_side_2d(side, recess = false) {
    for (y = [-1, 1]) {
        translate([side * slider_holes_span / 2, y * slider_holes_span / 2])
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

module clip_sleeve_roof_2d(side) {
    translate([side * SLEEVE_SEGMENT_OFFSET, 0])
        rounded_rect_2d([SLEEVE_ROOF_SEGMENT_LENGTH, spine_width], skeleton_corner_radius);
}

module clip_base_2d(side) {
    union() {
        translate([side * slider_holes_span / 2, 0])
            rounded_rect_2d([end_rail_width, slider_holes_span + corner_pad_diameter], skeleton_corner_radius);

        for (y = [-1, 1]) {
            pad_center = [side * slider_holes_span / 2, y * slider_holes_span / 2];
            translate(pad_center)
                circle(d = corner_pad_diameter);
        }

        clip_sleeve_roof_2d(side);
    }
}

module oriented_sleeve_2d() {
    rotate(sleeve_rotation)
        children();
}

module oriented_sleeve_3d() {
    rotate([0, 0, sleeve_rotation])
        children();
}

module skeleton_base_2d() {
    union() {
        oriented_sleeve_2d()
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

module clip_layer_2d(side, recess = false) {
    difference() {
        clip_base_2d(side);
        slider_holes_for_side_2d(side, recess);
    }
}

module label_text(text_value, position, spin = 0, size = label_size) {
    translate(position)
        rotate(spin)
        text(text_value, size = size, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
}

function sleeve_label_position(position) =
    sleeve_rotation == 90 ? [-position[1], position[0]] : position;

module production_labels_2d() {
    if (label_enabled) {
        if (sleeve_rotation == 90) {
            label_text("CISCO AP HOMERACKER", [0, slider_holes_span / 2], spin = 0, size = identity_label_size);
            label_text("GitHub: nelsonjchen/", [0, -slider_holes_span / 2 + 3], spin = 0, size = repo_label_size);
            label_text("cisco-ap-homeracker-mount-openscad", [0, -slider_holes_span / 2 - 3], spin = 0, size = repo_label_size);
        } else {
            label_text("CISCO AP HOMERACKER", [slider_holes_span / 2, 0], spin = 90, size = identity_label_size);
            label_text("GitHub: nelsonjchen/", [-slider_holes_span / 2 + 3, 0], spin = -90, size = repo_label_size);
            label_text("cisco-ap-homeracker-mount-openscad", [-slider_holes_span / 2 - 3, 0], spin = -90, size = repo_label_size);
        }

        label_text(str("S", ACTIVE_SLIDER_SMALL_DIAMETER), sleeve_label_position([0, -SLEEVE_SEGMENT_OFFSET]), spin = sleeve_rotation == 90 ? 0 : 90);
        label_text(str("D", ACTIVE_DETENT_DEPTH), sleeve_label_position([0, SLEEVE_SEGMENT_OFFSET]), spin = sleeve_rotation == 90 ? 0 : 90);
    }
}

module clip_labels_2d(side) {
    if (label_enabled) {
        side_name = side < 0 ? "LEFT" : "RIGHT";

        label_text(side_name, [side * SLEEVE_SEGMENT_OFFSET, 5], spin = 0, size = label_size);
        label_text(str("S", ACTIVE_SLIDER_SMALL_DIAMETER, " D", ACTIVE_DETENT_DEPTH), [side * SLEEVE_SEGMENT_OFFSET, -5], spin = 0, size = clip_label_size);
        label_text("CISCO AP", [side * slider_holes_span / 2, CLIP_ARM_LABEL_OFFSET], spin = 90, size = clip_label_size);
        label_text("HOMERACKER", [side * slider_holes_span / 2, -CLIP_ARM_LABEL_OFFSET], spin = 90, size = clip_label_size);
    }
}

module ap_bracket() {
    color(debug_colors ? HR_BLUE : BRACKET_WHITE)
    difference() {
        union() {
            linear_extrude(PLATE_BODY_THICKNESS)
                bracket_layer_2d(recess = true);
            translate([0, 0, PLATE_BODY_THICKNESS])
                linear_extrude(plate_lip_thickness)
                bracket_layer_2d(recess = false);
        }

        translate([0, 0, plate_thickness - label_depth + EPSILON])
            linear_extrude(label_depth + EPSILON)
            production_labels_2d();
    }
}

module ap_clip(side) {
    color(debug_colors ? HR_BLUE : BRACKET_WHITE)
    difference() {
        union() {
            linear_extrude(PLATE_BODY_THICKNESS)
                clip_layer_2d(side, recess = true);
            translate([0, 0, PLATE_BODY_THICKNESS])
                linear_extrude(plate_lip_thickness)
                clip_layer_2d(side, recess = false);
        }

        translate([0, 0, plate_thickness - label_depth + EPSILON])
            linear_extrude(label_depth + EPSILON)
            clip_labels_2d(side);
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
    oriented_sleeve_3d()
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

module clip_lockpin_holes(side) {
    if (lockpin_holes_enabled) {
        for (hole = [0 : 1 : sleeve_holes_per_end - 1]) {
            local_x = (hole - (sleeve_holes_per_end - 1) / 2) * BASE_UNIT;

            translate([side * SLEEVE_SEGMENT_OFFSET + local_x, 0, SLEEVE_LOCKPIN_CENTER_Z])
                centered_box([LOCKPIN_SIDE, SLEEVE_OUTER_WIDTH + EPSILON, LOCKPIN_SIDE]);
        }
    }
}

module homeracker_clip_sleeve(side) {
    color(debug_colors ? HR_YELLOW : HR_YELLOW)
    difference() {
        union() {
            for (wall_side = [-1, 1]) {
                translate([
                    side * SLEEVE_SEGMENT_OFFSET,
                    wall_side * (SLEEVE_INNER_SIDE / 2 + sleeve_wall / 2),
                    (SLEEVE_SIDE_HEIGHT + SLEEVE_ATTACH_OVERLAP) / 2
                ])
                    centered_box([SLEEVE_SEGMENT_LENGTH, sleeve_wall, SLEEVE_SIDE_HEIGHT + SLEEVE_ATTACH_OVERLAP]);
            }
        }

        clip_lockpin_holes(side);
    }
}

module clip_mount(side, centered = false) {
    translate(centered ? [-side * slider_holes_span / 2, 0, 0] : [0, 0, 0])
    union() {
        homeracker_clip_sleeve(side);
        translate([0, 0, SLEEVE_SIDE_HEIGHT])
            ap_clip(side);
    }
}

module clip_pair_mount() {
    for (side = [-1, 1])
        clip_mount(side);
}

module mount() {
    assert(plate_size >= slider_holes_span + corner_pad_diameter, "Bracket is too small for the corner pads.");
    assert(plate_lip_thickness > 0 && plate_lip_thickness < plate_thickness, "Plate lip thickness must be less than total plate thickness.");
    assert(corner_pad_diameter > slider_big_diameter * slider_recess_scale + 8, "Corner pads are too small for recessed slider holes.");
    assert(spine_width > SLEEVE_OUTER_WIDTH, "Spine width must be wider than the HomeRacker sleeve.");
    assert(ACTIVE_DETENT_DEPTH * 2 < ACTIVE_SLIDER_SMALL_DIAMETER + slider_clearance, "Detent bumps close the slider slot completely.");
    assert(label_depth > 0 && label_depth < plate_lip_thickness, "Label depth must be less than the plate lip thickness.");
    assert(sleeve_units > 0, "Sleeve units must be positive.");
    assert(sleeve_holes_per_end > 0, "At least one sleeve hole per end is required.");
    assert(sleeve_holes_per_end * 2 <= sleeve_units, "Sleeve end segments overlap; reduce holes per end or increase sleeve units.");
    assert(SLEEVE_ROOF_SEGMENT_LENGTH < sleeve_units * BASE_UNIT, "Sleeve roof overhang is too large.");
    assert(sleeve_rotation == 0 || sleeve_rotation == 90, "Sleeve rotation must be 0 or 90 degrees.");
    assert(part_mode >= 0 && part_mode <= 3, "Part mode must be 0, 1, 2, or 3.");

    if (part_mode == 0) {
        union() {
            homeracker_sleeve();
            translate([0, 0, SLEEVE_SIDE_HEIGHT])
                ap_bracket();
        }
    } else if (part_mode == 1) {
        clip_pair_mount();
    } else if (part_mode == 2) {
        clip_mount(-1, centered = true);
    } else if (part_mode == 3) {
        clip_mount(1, centered = true);
    }
}

mount();
