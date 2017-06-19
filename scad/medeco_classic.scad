use <keygen.scad>
include <medeco.scad>

module medeco_classic(bitting="",
                      outline_name="1515",
                      warding_name="1515") {

    name = "Medeco Classic";

    /*
        "A" variants of key outlines indicates 6-pin version.

        Bitting is specified from bow to tip, 1-6, with 1 being the shallowest cut and 6 being the deepest.

        After each number, a letter L, C, or R is specified for the cut angle: left, center or right.

        Example: 2L5C3C6R3R
    */

    outlines_k = ["A1515",
                  "1515",
                  "A1517",
                  "1517",
                  "1518",
                  "1542",
                  "1543",
                  "A1638",
                  "1638",
                  "1644",
                  "1655"];

    wardings_k = ["1515",
                  "1517",
                  "1518",
                  "1542",
                  "1543",
                  "1638",
                  "1644",
                  "1655"];

    outline_param = key_lkup(outlines_k, outlines_v, outline_name);
    outline_points = outline_param[0];
    outline_paths = outline_param[1];
    offset = outline_param[2];
    engrave_points = outline_param[3];
    engrave_paths = outline_param[4];

    warding_points = key_lkup(wardings_k, wardings_v, warding_name);
    
    cut_locations = [for(i=[0.244, 0.414, 0.584, 0.754, 0.924, 1.094]) i*25.4];
    depth_table = [for(i=[0.266+0.025:-0.025:0.115]) i*25.4];
    angles_k = ["L", "C", "R"];
    angles_v = [20, 0, -20];

    bitting_depth = [for(i=[0:2:len(bitting)-1]) bitting[i]];
    bitting_angle = [for(i=[1:2:len(bitting)-1]) bitting[i]];
    heights = key_code_to_heights(bitting_depth, depth_table);
    angles = [for(c=bitting_angle) key_lkup(angles_k, angles_v, c)];

    difference() {
        if($children == 0) {
            key_blank(outline_points,
                      warding_points,
                      outline_paths=outline_paths,
                      engrave_right_points=engrave_points,
                      engrave_right_paths=engrave_paths,
                      engrave_left_points=engrave_points,
                      engrave_left_paths=engrave_paths,
                      offset=offset,
                      plug_diameter=12.7);
        } else {
            children(0);
        }
        key_bitting(heights, cut_locations,
                    flat=.381, angle=86, // from CW-1012 cutter specs
                    angles=angles);
    }
}

// Defaults
bitting="5L5L4R1C1R";
outline="1515";
warding="1515";
medeco_classic(bitting, outline, warding);
