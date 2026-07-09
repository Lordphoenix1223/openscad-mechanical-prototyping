/*
Render-only scene file for bench_mechanism_v3.

This does not change the printable geometry.
It exists to make the preview package easier to inspect from multiple angles.

Scenes:
- scene = 1 -> base only
- scene = 2 -> carriage only
- scene = 3 -> M3 test block only
- scene = 4 -> all parts laid out together
- scene = 5 -> assembled preview
- scene = 6 -> assembled top view with scale card
*/

use <bench_mechanism_v3.scad>

scene = 4;

// Duplicated from bench_mechanism_v3.scad for render-only placement math.
rail_start = 16;
rail_length = 54;
base_width = 38;
carriage_width = 14;
base_thickness = 6;
vertical_clearance = 0.35;
front_stop_length = 6;
front_stop_height = 12;

// Cosmetic-only colors for clearer previews.
base_color = [0.68, 0.08, 0.10];
carriage_color = [0.78, 0.80, 0.84];
test_color = [0.42, 0.46, 0.50];
accent_color = [0.95, 0.82, 0.16];

module scale_card(size = [110, 70, 1.2], tick = 10) {
    color([0.96, 0.96, 0.98, 0.35])
        cube(size);

    color([0.55, 0.55, 0.60, 0.65]) {
        for (x = [0 : tick : size[0]]) {
            translate([x, 0, size[2]])
                cube([0.35, size[1], 0.25]);
        }

        for (y = [0 : tick : size[1]]) {
            translate([0, y, size[2]])
                cube([size[0], 0.35, 0.25]);
        }
    }
}

module base_pretty() {
    color(base_color) base_module();
}

module carriage_pretty() {
    color(carriage_color) carriage_module();
}

module test_block_pretty() {
    color(test_color) m3_test_block();
}

module all_parts_layout() {
    base_pretty();
    translate([106, 5, 0]) carriage_pretty();
    translate([106, 28, 0]) test_block_pretty();
}

module assembled_pretty() {
    base_pretty();
    translate([rail_start + 8, (base_width - carriage_width) / 2, base_thickness + vertical_clearance])
        carriage_pretty();

    // Cosmetic string line for preview only.
    color(accent_color)
        translate([rail_start + rail_length + front_stop_length - 1, base_width / 2 - 0.6, base_thickness + front_stop_height - 4])
            cube([18, 1.2, 1.2]);
}

module assembled_top_with_scale() {
    translate([-9, -16, -1.2]) scale_card();
    assembled_pretty();
}

if (scene == 1) {
    base_pretty();
} else if (scene == 2) {
    carriage_pretty();
} else if (scene == 3) {
    test_block_pretty();
} else if (scene == 4) {
    all_parts_layout();
} else if (scene == 5) {
    assembled_pretty();
} else if (scene == 6) {
    assembled_top_with_scale();
}
