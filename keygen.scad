$inf=1000;
$eps=.01;

function key_move(points, offset) = [
    for(p=points) [p[0] + offset[0],
                   p[1] + offset[1]]
];

module key_outline(outline_points, thickness, outline_paths=undef) {
    rotate(-90, [0, 1, 0]) rotate(-90, [0, 0, 1]) // Rotate into the correct plane
        linear_extrude(height=thickness, center=true) // Extrude the key outline
            polygon(points=outline_points, paths=outline_paths); // Draw the outline
}

module key_blade(warding, plug_diameter=0) {
    // Draw the blade to infinity in -Y
    // optionally intersected with the plug cylinder
    // to round the bottom
    intersection() {
        rotate(90, [1, 0, 0])
            linear_extrude(height=2*$inf, center=true)
                polygon(warding);

        // Draw the plug, if a plug diameter is specified
        if(plug_diameter > 0) {
            // Draw infinite cylinder in -Y
            translate([0, 0, 0.5*plug_diameter]) rotate(90, [1, 0, 0])
                cylinder(r=0.5*plug_diameter, h=$inf, $fn=$fn ? 4*$fn : 48);
        }
    }
}

module key_x_line(length) {
    // Hack to draw a line in X
    // since OpenSCAD does not support line primitives
    // Take a 2D square and rotate it
    // When it is orthogonal to the XY plane,
    // it projects down to a line
    rotate(90, [1, 0, 0])
    square([length, length], center=true);
}

module key_warding_cutter(warding, blade_height, cutter_radius, left) {
    neg = left ? -1 : 1;
    translate([neg * -cutter_radius, 0, 0])
        rotate_extrude($fn=$fn ? 4*$fn : 48)
            translate([neg * cutter_radius, 0])
                difference() {
                    translate([0, 0.5*blade_height])
                        square([2 * cutter_radius, blade_height], center=true);
                    minkowski() {
                        translate([neg * 1.5 * cutter_radius, 0])
                            key_x_line(3 * cutter_radius);
                        polygon(warding);
                    }
                    polygon(warding);
                }
}

module key_emboss(emboss_points, emboss_depth, left, thickness, emboss_paths=undef) {
    translate([(left ? -1 : 1) * 0.5*thickness, 0, 0]) rotate(-90, [0, 1, 0]) rotate(-90, [0, 0, 1]) // Translate and rotate into the correct soot
        linear_extrude(height=2*emboss_depth, center=true) // Extrude the key outline
            polygon(points=emboss_points, paths=emboss_paths); // Draw the outline
}

module key_blank(outline_points,
                warding,
                outline_paths=undef,
                emboss_right_points=[],
                emboss_right_paths=undef,
                emboss_left_points=[],
                emboss_left_paths=undef,
                bow_thickness=0,
                emboss_depth=.1,
                plug_diameter=0,
                offset=[0, 0],
                cutter_radius=18) {

    // Find the bounding box of the warding
    warding_min = [min([for(e=warding) e[0]]), min([for(e=warding) e[1]])];
    warding_max = [max([for(e=warding) e[0]]), max([for(e=warding) e[1]])];

    // Apply the given offset to the outline,
    // holes, and emboss
    outline_adj = key_move(outline_points, offset);
    emboss_left_adj = key_move(emboss_left_points, offset);
    emboss_right_adj = key_move(emboss_right_points, offset);

    // Move the warding profile
    // so that it is centered in X
    // and non-negative in Y
    warding_offset = [-0.5 * (warding_min[0] + warding_max[0]),
                      -warding_min[1]];
    warding_adj = key_move(warding, warding_offset);

    // Infer various key properties
    thickness = (bow_thickness == 0) ? abs(warding_max[0] - warding_min[0]) : bow_thickness;
    blade_height = abs(warding_max[1] - warding_min[1]);

    // Cut out the warding milling artifacts
    // from the bow
    difference() {
        // Create the bulk of the keyblank
        // by intersecting the outline
        // with the warding profile
        // and the plug
        intersection() {
            // Draw the key outline and holes
            key_outline(outline_adj, thickness, outline_paths);
            
            // Draw the blade, and a giant box where the bow is
            // so that we don't wipe out the bow
            // when the intersection happens
            union() {
                // Fill +Y half-space
                translate([0, $inf/2, 0])
                    cube([$inf, $inf, $inf], center=true);

                key_blade(warding_adj, plug_diameter);
            }
        }
        // Draw the milling wheels that cut the warding
        if(cutter_radius != 0) {
            key_warding_cutter(warding_adj, blade_height, cutter_radius, false);
            key_warding_cutter(warding_adj, blade_height, cutter_radius, true);
        }

        // Draw the embossing
        key_emboss(emboss_right_adj, emboss_depth, false, thickness, emboss_right_paths);
        key_emboss(emboss_left_adj, emboss_depth, true, thickness, emboss_left_paths);
    }
}

function key_code_to_heights(code, depth_table) = [for(i=[0:len(code)-1]) depth_table[search(code[i], "0123456789")[0]]];

module key_bitting_cutter(flat, angle, tool_height) {
    polygon([[-0.5 * flat, 0],
            [0.5 * flat, 0],
            [0.5 * flat + tan(0.5 * angle) * tool_height, tool_height],
            [0.5 * flat - tan(0.5 * angle) * tool_height, tool_height]]);
}

module key_bitting(heights,
                   locations,
                   flat,
                   angle=100,
                   cutter_width=5,
                   cutter_height=5) {
    // Rotate the cutting tool to the proper orientation
    rotate(-90, [0, 0, 1]) rotate(90, [1, 0, 0])
        // Union together a handful of trapezoids
        // that comprise the cuts
        union() {
            for(i=[0:len(heights)-1]) {
                // Move to the proper location and height
                translate([locations[i], heights[i]])
                    linear_extrude(height=cutter_width, center=true)
                        key_bitting_cutter(flat, angle, cutter_height);
            }
        }
}