// GL.iNet Beryl AX HomeRacker sleeve source scaffold
//
// CC BY-SA 4.0

/* [Part] */
part_mode = 0; // [0:Complete mount,1:Reference STL only,2:HomeRacker sleeve only]

/* [Reference STL] */
reference_alpha = 1; // [0:0.05:1]
reference_scale = 1000; // [1:1:2000]
reference_translate = [0, 0, 0];
reference_rotate = [0, 0, 0];

/* [HomeRacker Sleeve] */
sleeve_holes = 5; // [1:1:8]
sleeve_rotation = 90; // [0,90]
sleeve_wall = 2; // [1.2:0.1:4]
sleeve_roof_thickness = 3; // [1.6:0.1:6]
sleeve_tolerance = 0.2; // [0:0.05:0.6]
sleeve_embed_depth = 3; // [0:0.1:4]
sleeve_offset = [0, 0];
upward_channel_cut_enabled = true; // [false,true]
lockpin_holes_enabled = true; // [false,true]

/* [Debug] */
debug_colors = false; // [false,true]

/* [Hidden] */
$fn = 100;
EPSILON = 0.01;

// HomeRacker-compatible dimensions, mirrored locally so the model also
// compiles when opened directly in the OpenSCAD GUI.
BASE_UNIT = 15;
LOCKPIN_HOLE_SIDE_LENGTH = 4;
HR_YELLOW = "#f7b600";
REFERENCE_BLUE = "#4c78a8";

// Bounds measured from GL-INET-BERYL-AX-HOLSTER.stl after the default 1000x
// unit conversion. If the STL transform changes, adjust this bottom datum too.
BERYL_BOTTOM_Z = -2.5;
Z_INF = 200;

LOCKPIN_SIDE = LOCKPIN_HOLE_SIDE_LENGTH;
SLEEVE_INNER_SIDE = BASE_UNIT + sleeve_tolerance;
SLEEVE_OUTER_WIDTH = BASE_UNIT + 2 * sleeve_wall + sleeve_tolerance;
SLEEVE_LENGTH = sleeve_holes * BASE_UNIT - sleeve_tolerance;
SLEEVE_LOCKPIN_CENTER_Z = BASE_UNIT / 2 + sleeve_tolerance / 2;
SLEEVE_TOP_Z = SLEEVE_INNER_SIDE + sleeve_roof_thickness;
SLEEVE_MOUNT_Z = BERYL_BOTTOM_Z + sleeve_embed_depth - SLEEVE_TOP_Z;

module centered_box(size) {
    cube(size, center = true);
}

module beryl_ax_homeracker_sleeve_source() {
    color(REFERENCE_BLUE, reference_alpha)
    translate(reference_translate)
    rotate(reference_rotate)
    scale(reference_scale)
        import("../../../reference/GL-INET-BERYL-AX-HOLSTER.stl", convexity = 10);
}

module side_lockpin_hole() {
    centered_box([SLEEVE_OUTER_WIDTH + EPSILON, LOCKPIN_SIDE, LOCKPIN_SIDE]);
}

module roof_lockpin_hole() {
    translate([0, 0, SLEEVE_INNER_SIDE + sleeve_roof_thickness / 2])
        centered_box([LOCKPIN_SIDE, LOCKPIN_SIDE, sleeve_roof_thickness + 2 * EPSILON]);
}

module local_lockpin_holes() {
    if (lockpin_holes_enabled) {
        for (hole = [0 : 1 : sleeve_holes - 1]) {
            local_y = (hole - (sleeve_holes - 1) / 2) * BASE_UNIT;

            translate([0, local_y, SLEEVE_LOCKPIN_CENTER_Z]) {
                side_lockpin_hole();
            }

            translate([0, local_y, 0])
                roof_lockpin_hole();
        }
    }
}

module local_upward_channel_cut() {
    if (upward_channel_cut_enabled) {
        translate([0, 0, SLEEVE_TOP_Z + Z_INF / 2])
            centered_box([SLEEVE_INNER_SIDE + 2 * EPSILON, SLEEVE_LENGTH + 2 * EPSILON, Z_INF]);
    }
}

module homeracker_sleeve_segment() {
    union() {
        for (wall_side = [-1, 1]) {
            translate([
                wall_side * (SLEEVE_INNER_SIDE / 2 + sleeve_wall / 2),
                0,
                SLEEVE_INNER_SIDE / 2
            ])
                centered_box([sleeve_wall, SLEEVE_LENGTH, SLEEVE_INNER_SIDE]);
        }

        translate([0, 0, SLEEVE_INNER_SIDE + sleeve_roof_thickness / 2])
            centered_box([SLEEVE_OUTER_WIDTH, SLEEVE_LENGTH, sleeve_roof_thickness]);
    }
}

module homeracker_sleeve_positive() {
    color(HR_YELLOW)
    rotate([0, 0, sleeve_rotation])
        homeracker_sleeve_segment();
}

module homeracker_sleeve_holes() {
    rotate([0, 0, sleeve_rotation])
        union() {
            local_lockpin_holes();
            local_upward_channel_cut();
        }
}

module bottom_homeracker_sleeve_positive() {
    translate([sleeve_offset[0], sleeve_offset[1], SLEEVE_MOUNT_Z])
        homeracker_sleeve_positive();
}

module bottom_homeracker_sleeve_holes() {
    translate([sleeve_offset[0], sleeve_offset[1], SLEEVE_MOUNT_Z])
        homeracker_sleeve_holes();
}

module bottom_homeracker_sleeve() {
    difference() {
        bottom_homeracker_sleeve_positive();
        bottom_homeracker_sleeve_holes();
    }
}

module model() {
    assert(part_mode >= 0 && part_mode <= 2, "Part mode must be 0, 1, or 2.");
    assert(sleeve_holes > 0, "At least one sleeve hole is required.");
    assert(sleeve_rotation == 0 || sleeve_rotation == 90, "Sleeve rotation must be 0 or 90 degrees.");
    assert(sleeve_wall > 0, "Sleeve wall thickness must be positive.");
    assert(sleeve_roof_thickness > 0, "Sleeve roof thickness must be positive.");
    assert(sleeve_embed_depth >= 0, "Sleeve embed depth cannot be negative.");
    assert(Z_INF > 100, "Z_INF must be tall enough to clear the source holster.");

    if (part_mode == 0) {
        difference() {
            union() {
                beryl_ax_homeracker_sleeve_source();
                bottom_homeracker_sleeve_positive();
            }

            bottom_homeracker_sleeve_holes();
        }
    } else if (part_mode == 1) {
        beryl_ax_homeracker_sleeve_source();
    } else if (part_mode == 2) {
        bottom_homeracker_sleeve();
    }
}

model();
