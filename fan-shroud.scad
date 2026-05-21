$fn=128;


fan_dia = 120 - 7; // 7mm less so we don't expose edges too much
shroud_upper_dia = 125;
screw_hole_distance = 105;
screw_hole_dia = 4.5;
material_thickness = 1.5;

fan_count = 3;

side_length = 498+2+5;

extra_border = 5;
overall_depth = shroud_upper_dia + extra_border;
in_between_gap = 0.5;

shroud_thickness = 1;
shroud_gap = 10;
shroud_height = 20;
shroud_angle = 3;

center_circle_dia = 30;

finger_protection_gap = 11;
finger_protection_thickness = 1.5;

screw_protection_thickness = 1;

// middle circle to cover fan brand -> done
// finger protection -> done
// 1mm extra to the holes sides -> done
// extra protection on the screw holes -> done
// center grills -> done

module draw_circle_outlines(dia, height, thickness) {
    difference() {
        cylinder(h=height, d=dia+thickness);
        translate([0, 0, -0.05]) cylinder(h=height+0.1, d=dia);
    }
}

module draw_fan_holes() {
    difference() {
    union() {
        for (alt = [0:90:359]) {
            union() {
                // screw hole attachment things
                hull() {
                    rotate([0, 0, alt]) translate([screw_hole_distance/2, screw_hole_distance/2]) cylinder(h=material_thickness, d=screw_hole_dia+3);
                    cylinder(h=material_thickness+5, d=40);
                }
                // screw hole attachment protection
                hull() {
                    rotate([0, 0, alt]) translate([screw_hole_distance/2, screw_hole_distance/2, - screw_hole_dia - screw_protection_thickness - 15]) cylinder(h=material_thickness, d=screw_protection_thickness);
                    rotate([0, 0, alt-45]) translate([0, (shroud_upper_dia+(material_thickness/2))/2, shroud_height]) cylinder(h=0.01, d=screw_protection_thickness);
                    rotate([0, 0, alt-45]) translate([0, (fan_dia+(material_thickness/2))/2, 0]) cylinder(h=0.01, d=screw_protection_thickness);
                }
            }
        }
    }
    union() {
        translate([0, 0, -0.05]) cylinder(h=shroud_height, d1=fan_dia+material_thickness, d2=shroud_upper_dia+material_thickness);
        for (rot =[0:90:360]) {
            rotate([0, 0, rot]) translate([screw_hole_distance/2, screw_hole_distance/2, -0.05]) cylinder(h=material_thickness+10, d=screw_hole_dia);
        }
    }
    }
}

module draw_cylinder_around_fan() {
    difference() {
        cylinder(h=shroud_height, d1=fan_dia+material_thickness, d2=shroud_upper_dia+material_thickness);
        translate([0, 0, -0.5]) cylinder(h=shroud_height+1, d1=fan_dia, d2=shroud_upper_dia);
    }
}

module draw_fan_shroud() {
    fan_gap = (side_length - (fan_count * fan_dia)) / fan_count;

    intersection() {
        // cutting off sides
        translate([overall_depth/-2, (shroud_upper_dia+extra_border)/-2, 0]) cube([overall_depth, shroud_upper_dia + (extra_border*2), material_thickness + shroud_height]);

        // shroud
        union() {
        // cylinder around fan
        draw_cylinder_around_fan();

        intersection() {
            offset_shroud_overall_by = overall_depth % (shroud_thickness+shroud_gap);
            cylinder(h=shroud_height, d1=fan_dia+material_thickness, d2=shroud_upper_dia+material_thickness);
            for (shroud_offset = [offset_shroud_overall_by:shroud_thickness+shroud_gap:overall_depth]) {
                translate([overall_depth/-2 +shroud_offset, (fan_dia + fan_gap - in_between_gap)/-2, 0]) rotate([0, shroud_angle, 0]) cube([shroud_thickness, fan_dia + fan_gap - in_between_gap, shroud_height + 5]);
            }
        }
        // middle circle for fan logo
        cylinder(h=material_thickness, d=center_circle_dia);
        // finger protection
        for (finger_protection_dia = [center_circle_dia:finger_protection_thickness+finger_protection_gap:fan_dia]) {
            draw_circle_outlines(dia=finger_protection_dia, height=material_thickness, thickness=finger_protection_thickness);
        }
        // finger protection strengthening
        intersection() {
            translate([shroud_upper_dia/-2, finger_protection_thickness/-2, 0]) cube([shroud_upper_dia, finger_protection_thickness, material_thickness]);
            cylinder(h=shroud_height, d1=fan_dia, d2=shroud_upper_dia);
        }
        // bottom part
        draw_fan_holes();
        }
    }
}

draw_fan_shroud();
