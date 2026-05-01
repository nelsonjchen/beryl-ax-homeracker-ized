// Cisco AP keyhole fit coupon matrix
//
// Small test prints for checking the recessed Cisco AP slider hole, narrow
// slot diameter, and retention detent before printing the full HomeRacker mount.

/* [Coupon] */
coupon_thickness = 5; // [3:0.1:10]
coupon_lip_thickness = 1; // [0.6:0.1:2]
coupon_pad_diameter = 32; // [24:0.1:48]
coupon_arm_width = 13; // [8:0.1:24]
coupon_arm_length = 30; // [12:0.1:80]
coupon_spacing = 48; // [40:0.1:70]

/* [Cisco AP Slider Hole] */
slider_big_diameter = 10.5; // [8:0.1:14]
slider_length = 21.25; // [16:0.1:30]
slider_clearance = 0.25; // [0:0.05:1]
slider_recess_scale = 1.1; // [1:0.01:1.25]

/* [AP Retention Detent] */
detent_enabled = true; // [false,true]
detent_length = 2.6; // [1:0.1:5]
detent_offset_from_seat = 0.8; // [0:0.1:4]

/* [Labels] */
label_enabled = true; // [false,true]
label_size = 3.8; // [1.5:0.1:5]
label_depth = 0.35; // [0.1:0.05:0.8]

/* [Hidden] */
$fn = 100;
EPSILON = 0.01;
COUPON_BODY_THICKNESS = coupon_thickness - coupon_lip_thickness;

// Columns vary the narrow slot diameter. 6.42mm is the current full-bracket value.
SMALL_DIAMETER_VALUES = [6.00, 6.25, 6.42, 6.75, 7.00];

// Rows vary detent bite into each side of the narrow slot. 0.00 is a no-detent baseline.
DETENT_DEPTH_VALUES = [0.00, 0.25, 0.50, 0.75];

function matrix_width() = (len(SMALL_DIAMETER_VALUES) - 1) * coupon_spacing;
function matrix_height() = (len(DETENT_DEPTH_VALUES) - 1) * coupon_spacing;

module rounded_rect_2d(size, radius) {
    safe_radius = min(radius, min(size[0], size[1]) / 2 - EPSILON);
    offset(r = safe_radius)
        square([size[0] - 2 * safe_radius, size[1] - 2 * safe_radius], center = true);
}

module slider_hole_2d(small_diameter, recess = false) {
    big_d = slider_big_diameter + slider_clearance;
    small_d = small_diameter + slider_clearance;
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

module detent_bump_2d(small_diameter, detent_depth) {
    small_d = small_diameter + slider_clearance;
    detent_y = -slider_length / 2 + small_d / 2 + detent_offset_from_seat;

    if (detent_enabled && detent_depth > 0) {
        for (side = [-1, 1]) {
            translate([side * small_d / 2, detent_y])
                rounded_rect_2d([2 * detent_depth, detent_length], detent_depth);
        }
    }
}

module slider_cutout_2d(small_diameter, detent_depth, recess = false) {
    if (detent_enabled && detent_depth > 0 && !recess) {
        difference() {
            slider_hole_2d(small_diameter, recess);
            detent_bump_2d(small_diameter, detent_depth);
        }
    } else {
        slider_hole_2d(small_diameter, recess);
    }
}

module coupon_base_2d() {
    union() {
        circle(d = coupon_pad_diameter);
        translate([0, coupon_arm_length / 2])
            rounded_rect_2d([coupon_arm_width, coupon_arm_length], coupon_arm_width / 2);
        translate([coupon_arm_length / 2, 0])
            rounded_rect_2d([coupon_arm_length, coupon_arm_width], coupon_arm_width / 2);
    }
}

module coupon_layer_2d(small_diameter, detent_depth, recess = false) {
    difference() {
        coupon_base_2d();
        rotate(-90)
            slider_cutout_2d(small_diameter, detent_depth, recess);
    }
}

module label_text(text_value, position, spin = 0) {
    translate(position)
        rotate(spin)
        text(text_value, size = label_size, halign = "center", valign = "center", font = "Liberation Sans:style=Bold");
}

module coupon_labels_2d(small_diameter, detent_depth) {
    if (label_enabled) {
        label_text(str("S", small_diameter), [coupon_arm_length / 2 + 5, 0]);
        label_text(str("D", detent_depth), [0, coupon_arm_length / 2 + 2], spin = 90);
    }
}

module keyhole_fit_coupon(small_diameter, detent_depth) {
    assert(coupon_lip_thickness > 0 && coupon_lip_thickness < coupon_thickness, "Coupon lip thickness must be less than coupon thickness.");
    assert(coupon_pad_diameter > slider_big_diameter * slider_recess_scale + 8, "Coupon pad is too small for recessed slider hole.");
    assert(detent_depth * 2 < small_diameter + slider_clearance, "Detent bumps close the slider slot completely.");

    difference() {
        union() {
            linear_extrude(COUPON_BODY_THICKNESS)
                coupon_layer_2d(small_diameter, detent_depth, recess = true);
            translate([0, 0, COUPON_BODY_THICKNESS])
                linear_extrude(coupon_lip_thickness)
                coupon_layer_2d(small_diameter, detent_depth, recess = false);
        }

        translate([0, 0, coupon_thickness - label_depth + EPSILON])
            linear_extrude(label_depth + EPSILON)
            coupon_labels_2d(small_diameter, detent_depth);
    }
}

module keyhole_fit_matrix() {
    for (row = [0 : len(DETENT_DEPTH_VALUES) - 1], col = [0 : len(SMALL_DIAMETER_VALUES) - 1]) {
        small_diameter = SMALL_DIAMETER_VALUES[col];
        detent_depth = DETENT_DEPTH_VALUES[row];
        translate([
            col * coupon_spacing - matrix_width() / 2,
            -row * coupon_spacing + matrix_height() / 2,
            0
        ])
            keyhole_fit_coupon(small_diameter, detent_depth);
    }
}

keyhole_fit_matrix();
