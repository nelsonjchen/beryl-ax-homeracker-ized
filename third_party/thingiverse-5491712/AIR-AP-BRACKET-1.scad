$fn = $preview ? 64 : 128;

MIRROR_MATRIX = [[1, 1], [1, -1], [-1, 1], [-1, -1]];

SLIDER_HOLES_SPAN = 108.00;

SLIDER_BIG_DIAMETER = 10.50;
SLIDER_SMALL_DIAMETER = 7.00;
SLIDER_LENGTH = 21.25;

SLIDER_SQUARE_LENGTH = SLIDER_LENGTH - (SLIDER_BIG_DIAMETER / 2 + SLIDER_SMALL_DIAMETER / 2);

CLEARANCE_SCALE = 1.10;

module SliderHole(CLEARANCE=false) {
    scale(CLEARANCE ? CLEARANCE_SCALE : 1)
    translate([0.00, -SLIDER_LENGTH / 2])
    union() {
        if (!CLEARANCE) {
            translate([0.00, SLIDER_LENGTH - (SLIDER_BIG_DIAMETER / 2)])
            circle(d=SLIDER_BIG_DIAMETER);
            translate([0.00, SLIDER_SMALL_DIAMETER / 2])
            circle(d=SLIDER_SMALL_DIAMETER);
            translate([0.00, SLIDER_LENGTH - (SLIDER_BIG_DIAMETER / 2+ SLIDER_SQUARE_LENGTH / 2)])
            square([SLIDER_SMALL_DIAMETER, SLIDER_SQUARE_LENGTH], center=true);
        } else {
            translate([0.00, SLIDER_LENGTH - (SLIDER_BIG_DIAMETER / 2)])
            circle(d=SLIDER_BIG_DIAMETER);
            translate([0.00, SLIDER_BIG_DIAMETER / 2])
            circle(d=SLIDER_BIG_DIAMETER);
            translate([0.00, SLIDER_LENGTH - SLIDER_BIG_DIAMETER])
            square([SLIDER_BIG_DIAMETER, SLIDER_LENGTH - SLIDER_BIG_DIAMETER], center=true);
        }
    }
}

module SliderHoles(CLEARANCE=false) {
    for(mirror_xy = MIRROR_MATRIX) {
        translate([(SLIDER_HOLES_SPAN / 2) * mirror_xy[0] , (SLIDER_HOLES_SPAN / 2) * mirror_xy[1]])
        SliderHole(CLEARANCE=CLEARANCE);
    }
}

MOUNTING_HOLE_DIAMETER = 4.70;
MOUNTING_HOLE_SPAN_X = 66.40;
MOUNTING_HOLE_SPAN_Y = 109.00;

module MountingHole() {
    circle(d=MOUNTING_HOLE_DIAMETER);
}

module MountingHoles() {
    for(mirror_xy = MIRROR_MATRIX) {
        translate([(MOUNTING_HOLE_SPAN_X / 2) * mirror_xy[0] , (MOUNTING_HOLE_SPAN_Y / 2) * mirror_xy[1]])
        MountingHole();
    }
}

TEXT_SIZE = 2.30;
TRIANGULAR_GROUP_HOLE_DIAMETER = 5.40;
TRIANGULAR_GROUPS = [
    [[49.10, 63.5], [0.00, 0.00], "A", [0.00, -5.00]],
    [[35.00, 63.5], [0.00, 5.40], "B", [-4.00, 4.00]],
    [[25.40, 63.5], [0.00, 0.00], "C", [5.00, 0.00]]
];

module TriangularGroupHole() {
    circle(d=TRIANGULAR_GROUP_HOLE_DIAMETER);
}

module TriangularGroupHoles() {
    for(triangular_group = TRIANGULAR_GROUPS) {
        translate(triangular_group[1])
        for(mirror_xy = MIRROR_MATRIX) {
            translate([(triangular_group[0][0] / 2) * mirror_xy[0], (triangular_group[0][1] / 2) * mirror_xy[1]])
            MountingHole();
        }
    }
}

module TriangularGroupMarkings() {
    for(triangular_group = TRIANGULAR_GROUPS) {
        translate(triangular_group[1])
        for(mirror_xy = MIRROR_MATRIX) {
            translate([(triangular_group[0][0] / 2) * mirror_xy[0] - triangular_group[3][0] * mirror_xy[0], (triangular_group[0][1] / 2) * mirror_xy[1] + triangular_group[3][1]])
            text(triangular_group[2], size=TEXT_SIZE, halign="center", valign="center");
        }
    }
}

MODULE_BASE_SIZE = 142.50;
MODULE_BASE_CORNER_RADIUS = 20.00;
module ModuleBase(CLEARANCE=false) {
    difference() {
        translate([MODULE_BASE_CORNER_RADIUS - MODULE_BASE_SIZE / 2, MODULE_BASE_CORNER_RADIUS - MODULE_BASE_SIZE / 2])
        minkowski() {
            square(MODULE_BASE_SIZE - 2 * MODULE_BASE_CORNER_RADIUS);
            circle(r=MODULE_BASE_CORNER_RADIUS);
        }
        
        SliderHoles(CLEARANCE=CLEARANCE);
        TriangularGroupHoles();
    }
}

PLATE_THICKNESS = 5.00;
PLATE_THICKNESS_THIN = 1.00;
PLATE_THICKNESS_THICK = PLATE_THICKNESS - PLATE_THICKNESS_THIN;
TEXT_DEPTH = 0.20;


module MountingCountersink() {
    translate([0.00, 0.00, PLATE_THICKNESS / 2])
    scale($preview ? 1.01 : 1.00)
    cylinder(h=PLATE_THICKNESS, d1=MOUNTING_HOLE_DIAMETER, d2=12.50, center=true);
}

module MountingCountersinks() {
    for(mirror_xy = MIRROR_MATRIX) {
        translate([(MOUNTING_HOLE_SPAN_X / 2) * mirror_xy[0] , (MOUNTING_HOLE_SPAN_Y / 2) * mirror_xy[1]])
        MountingCountersink();
    }
}

difference() {
    union() {
        translate([0.00, 0.00, PLATE_THICKNESS_THICK])
        linear_extrude(PLATE_THICKNESS_THIN)
        ModuleBase();
        linear_extrude(PLATE_THICKNESS_THICK)
        ModuleBase(CLEARANCE=true);
    }
        
    if(!$preview) {
        translate([0.00, 0.00, PLATE_THICKNESS - TEXT_DEPTH])
        linear_extrude(TEXT_DEPTH)
        TriangularGroupMarkings();
    }
    
    MountingCountersinks();
}

if($preview) {
    color("White")
    translate([0.00, 0.00, PLATE_THICKNESS - TEXT_DEPTH])
    linear_extrude(TEXT_DEPTH * 1.01)
    TriangularGroupMarkings();
}