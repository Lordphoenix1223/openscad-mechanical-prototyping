/*
Bench mechanism v3

Purpose:
- smaller and cheaper than v2
- safer and simpler than a wearable shell
- built for a library or print-shop first run
- designed around M3 hardware and elastic-band testing

Part selector:
- part = 0 -> assembly preview
- part = 1 -> base
- part = 2 -> carriage
- part = 3 -> M3 test block
*/

$fn = 36;

part = 0;
eps = 0.05;

// --- Hardware baseline ------------------------------------------------------
// M3 clearance hole for screws that should pass through without tapping.
m3_clearance_d = 3.4;
// M3 insert bore for optional heat-set inserts in a future shell or fixture.
m3_insert_bore_d = 4.6;
// Across-flats dimension for a standard M3 hex nut trap.
m3_nut_flat = 5.7;
// Nut trap depth for a standard M3 nut.
m3_nut_depth = 2.6;

// --- Print / fit tuning -----------------------------------------------------
// Side clearance per rail face. Generous for cheap PLA service prints.
side_clearance = 0.40;
// Vertical clearance keeps the carriage from scraping the base immediately.
vertical_clearance = 0.35;

// --- Base dimensions --------------------------------------------------------
// Overall base length kept under 100 mm to stay cheap at a print shop.
base_length = 92;
// Overall base width kept narrow but still wide enough for stable taping.
base_width = 38;
// Flat plate thickness for stiffness without wasting plastic.
base_thickness = 6;

// Rail run starts after the rear bridge so the carriage has a hard back stop.
rail_start = 16;
// Rail length is short on purpose to limit print size and travel distance.
rail_length = 54;
// Rail thickness is chunky enough to survive repeated beginner handling.
rail_thickness = 4;
// Rail height is tall enough to guide the carriage without toppling.
rail_height = 10;

// Carriage width is the moving body width before clearances are added.
carriage_width = 14;
// Channel width is the free space between rails.
channel_width = carriage_width + side_clearance * 2;
// Outer guide span includes both rails.
function guide_outer_width() = channel_width + rail_thickness * 2;

// Rear bridge creates the back stop and elastic anchor wall.
rear_bridge_length = 8;
rear_bridge_height = 16;
// Elastic slots fit common office rubber bands or light elastic cord.
elastic_slot_w = 4.5;
elastic_slot_h = 8;
elastic_slot_spacing = 12;

// Front stop limits travel and keeps the tether centered.
front_stop_length = 6;
front_stop_height = 12;
// Open notch is intentionally top-open to avoid closed-hole manifold issues.
front_notch_w = 4.5;
front_notch_d = 6;

// M3 mounting holes let the base screw onto scrap wood or plastic if needed.
mount_hole_offset_x = 12;
mount_hole_offset_y = 7;

// Tie-down slots are backup mounting points for tape or zip ties.
tie_slot_len = 10;
tie_slot_w = 4;

// --- Carriage dimensions ----------------------------------------------------
// Carriage is short to keep mass low and elastic response predictable.
carriage_length = 22;
// Carriage body height before finger tab.
carriage_height = 8;
// Bottom relief reduces contact area and friction on cheap prints.
carriage_relief_depth = 1.2;
// Rear slot captures the elastic loop or tied cord.
carriage_elastic_slot_len = 7;
carriage_elastic_slot_w = 6;
carriage_elastic_slot_h = 4;
// Front tether hole for line or string attachment.
tether_hole_d = 2.6;
// Front soft-tip pocket gives tape or foam a repeatable landing spot.
tip_slot_len = 8;
tip_slot_w = 6;
tip_slot_h = 4;

module m3_hole(h) {
    cylinder(h = h, d = m3_clearance_d);
}

module hex_nut_cut(depth) {
    cylinder(h = depth, d = m3_nut_flat / 0.8660254, $fn = 6);
}

module base_module() {
    difference() {
        union() {
            cube([base_length, base_width, base_thickness]);

            // Rear bridge is the hard back stop and elastic anchor structure.
            translate([0, (base_width - guide_outer_width()) / 2, base_thickness - eps])
                cube([rear_bridge_length, guide_outer_width(), rear_bridge_height + eps]);

            // Left rail guides the carriage and overlaps the plate slightly.
            translate([rail_start, (base_width - guide_outer_width()) / 2, base_thickness - eps])
                cube([rail_length, rail_thickness, rail_height + eps]);

            // Right rail mirrors the left rail with the same overlap trick.
            translate([rail_start, (base_width + channel_width) / 2, base_thickness - eps])
                cube([rail_length, rail_thickness, rail_height + eps]);

            // Front stop is a simple rectangular bumper to avoid fragile tips.
            translate([rail_start + rail_length, (base_width - guide_outer_width()) / 2, base_thickness - eps])
                cube([front_stop_length, guide_outer_width(), front_stop_height + eps]);
        }

        // M3 mounting holes for a rigid test fixture.
        translate([mount_hole_offset_x, mount_hole_offset_y, -1]) m3_hole(base_thickness + 2);
        translate([mount_hole_offset_x, base_width - mount_hole_offset_y, -1]) m3_hole(base_thickness + 2);
        translate([base_length - mount_hole_offset_x, mount_hole_offset_y, -1]) m3_hole(base_thickness + 2);
        translate([base_length - mount_hole_offset_x, base_width - mount_hole_offset_y, -1]) m3_hole(base_thickness + 2);

        // Tie slots let you mount the base even if you have zero screws on day one.
        translate([28, 6, -1]) cube([tie_slot_len, tie_slot_w, base_thickness + 2]);
        translate([28, base_width - 10, -1]) cube([tie_slot_len, tie_slot_w, base_thickness + 2]);
        translate([58, 6, -1]) cube([tie_slot_len, tie_slot_w, base_thickness + 2]);
        translate([58, base_width - 10, -1]) cube([tie_slot_len, tie_slot_w, base_thickness + 2]);

        // Dual elastic slots keep the pull centered and reduce twist.
        translate([1, base_width / 2 - elastic_slot_spacing / 2 - elastic_slot_w / 2, base_thickness + 4])
            cube([rear_bridge_length + 2, elastic_slot_w, elastic_slot_h]);
        translate([1, base_width / 2 + elastic_slot_spacing / 2 - elastic_slot_w / 2, base_thickness + 4])
            cube([rear_bridge_length + 2, elastic_slot_w, elastic_slot_h]);

        // Open top notch guides the string without creating a closed tunnel.
        translate([rail_start + rail_length, base_width / 2 - front_notch_w / 2, base_thickness + front_stop_height - front_notch_d])
            cube([front_stop_length + 1, front_notch_w, front_notch_d + 1]);
    }
}

module carriage_module() {
    difference() {
        union() {
            cube([carriage_length, carriage_width, carriage_height]);

            // Finger tab helps manual pull-back tests without needing a tool.
            translate([5, carriage_width / 2 - 5, carriage_height - eps])
                cube([8, 10, 4 + eps]);
        }

        // Bottom relief cuts drag and gives cheap prints a better chance to slide.
        translate([2, 2, -1])
            cube([carriage_length - 4, carriage_width - 4, carriage_relief_depth + 1]);

        // Rear elastic capture slot is open to the back for fast re-threading.
        translate([-1, carriage_width / 2 - carriage_elastic_slot_w / 2, carriage_height / 2 - carriage_elastic_slot_h / 2])
            cube([carriage_elastic_slot_len + 1, carriage_elastic_slot_w, carriage_elastic_slot_h]);

        // Front horizontal tether hole for string or line.
        translate([carriage_length - 5, carriage_width / 2, carriage_height / 2 + 0.5])
            rotate([90, 0, 0]) cylinder(h = carriage_width + 2, d = tether_hole_d);

        // Tip slot is open at the front so foam or a suction cup stem can be inserted directly.
        translate([carriage_length - tip_slot_len, carriage_width / 2 - tip_slot_w / 2, carriage_height / 2 - tip_slot_h / 2])
            cube([tip_slot_len + 1, tip_slot_w, tip_slot_h]);
    }
}

module m3_test_block() {
    difference() {
        cube([24, 18, 6]);

        // M3 clearance hole test.
        translate([6, 9, -1]) cylinder(h = 8, d = m3_clearance_d);

        // M3 insert bore test.
        translate([12, 9, -1]) cylinder(h = 8, d = m3_insert_bore_d);

        // M3 screw + nut trap test for cheap print-shop tolerances.
        translate([18, 9, -1]) cylinder(h = 8, d = m3_clearance_d);
        translate([18, 9, 6 - m3_nut_depth]) hex_nut_cut(m3_nut_depth + 1);
    }
}

module assembly_preview() {
    color("lightgray") base_module();
    translate([rail_start + 8, (base_width - carriage_width) / 2, base_thickness + vertical_clearance])
        color("orange") carriage_module();
}

if (part == 1) {
    base_module();
} else if (part == 2) {
    carriage_module();
} else if (part == 3) {
    m3_test_block();
} else {
    assembly_preview();
}
