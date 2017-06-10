use <keygen.scad>
include <fm.gen.scad>

bitting_code = "1526985";

// The FM keyblank can be used in many key systems
// This is the depth table for Best A2 system

cut_locations = [for(i=[.080, .230, .380, .530, .680, .830, .980]) -i*25.4];

depth_table = [for(i=[0.318:-0.0125:0.205]) i*25.4];

heights = key_code_to_heights(bitting_code, depth_table);

difference() {
    key_blank(outline_points,
              warding_points,
              outline_paths=outline_paths,
              engrave_right_points=engrave_points,
              engrave_right_paths=engrave_paths,
              engrave_left_points=engrave_points,
              engrave_left_paths=engrave_paths,
              offset=[-outline_points[103][0], -outline_points[96][1]],
              milling_offset=30,
              plug_diameter=10.8712);
    key_bitting(heights, cut_locations, .7874);
}