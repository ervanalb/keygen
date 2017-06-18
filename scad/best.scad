use <keygen.scad>
include <best.gen.scad>

module best(bitting="",
            outline_name="1A Standard",
            warding_name="A") {

    name = "Best SFIC";

    /*
        Bitting is specified from tip to bow, 0-9, with 0 being the shallowest cut and 9 being the deepest.
        Example: 2536326
    */

    outlines_k = ["1A Standard"];
    outlines_v = [[outline_points, outline_paths,
                   [-outline_points[42][0], -outline_points[37][1]],
                   engrave_points,
                   engrave_paths]];
    wardings_k = ["A",
                  "B",
                  "C",
                  "FM"];
    wardings_v = [warding_a_points,
                  warding_b_points,
                  warding_c_points,
                  warding_fm_points];

    outline_param = key_lkup(outlines_k, outlines_v, outline_name);
    outline_points = outline_param[0];
    outline_paths = outline_param[1];
    offset = outline_param[2];
    engrave_points = outline_param[3];
    engrave_paths = outline_param[4];

    warding_points = key_lkup(wardings_k, wardings_v, warding_name);

    // Best A2 system    
    cut_locations = [for(i=[.080, .230, .380, .530, .680, .830, .980]) -i*25.4];
    depth_table = [for(i=[0.318:-0.0125:0.205]) i*25.4];

    heights = key_code_to_heights(bitting, depth_table);

    difference() {
        if($children == 0) {
            key_blank(outline_points,
                      warding_points,
                      outline_paths=outline_paths,
                      //engrave_right_points=engrave_points,
                      //engrave_right_paths=engrave_paths,
                      //engrave_left_points=engrave_points,
                      //engrave_left_paths=engrave_paths,
                      offset=offset,
                      milling_offset=30,
                      plug_diameter=10.8712);
        } else {
            children(0);
        }
        key_bitting(heights, cut_locations, .7874);
    }
}

// Defaults
bitting="";
outline="1A Standard";
warding="A";
best(bitting, outline, warding);
