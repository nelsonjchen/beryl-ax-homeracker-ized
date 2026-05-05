// GL.iNet Beryl AX HomeRacker sleeve source scaffold
//
// CC BY-SA 4.0

/* [Reference STL] */
reference_alpha = 1; // [0:0.05:1]
reference_scale = 1000; // [1:1:2000]
reference_translate = [0, 0, 0];
reference_rotate = [0, 0, 0];

/* [Hidden] */
$fn = 100;

module beryl_ax_homeracker_sleeve_source() {
    color("#4c78a8", reference_alpha)
    translate(reference_translate)
    rotate(reference_rotate)
    scale(reference_scale)
        import("../../../reference/GL-INET-BERYL-AX-HOLSTER.stl", convexity = 10);
}

module model() {
    beryl_ax_homeracker_sleeve_source();
}

model();
