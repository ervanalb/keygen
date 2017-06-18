use <keygen.scad>
include <kwikset.gen.scad>

module kwikset(bitting="",
               outline_name="KW1",
               warding_name="KW1") {

    name = "Kwikset";

    /*
        Bitting is specified from bow to tip, 1-7, with 1 being the shallowest cut and 7 being the deepest.
        Example: 25363
    */

    outlines_k = ["KW1"];
    outlines_v = [[outline_points, outline_paths,
                   [-outline_points[34][0], -outline_points[26][1]],
                   engrave_points,
                   engrave_paths]];
    wardings_k = ["KW1"];
    wardings_v = [warding_kw1_points];

    outline_param = key_lkup(outlines_k, outlines_v, outline_name);
    outline_points = outline_param[0];
    outline_paths = outline_param[1];
    offset = outline_param[2];
    engrave_points = outline_param[3];
    engrave_paths = outline_param[4];

    warding_points = key_lkup(wardings_k, wardings_v, warding_name);
    
    cut_locations = [for(i=[.247, .397, .547, .697, .847]) i*25.4];
    // Kwikset starts with 1??
    depth_table = [for(i=[0.329+0.023:-0.023:0.190]) i*25.4];

    heights = key_code_to_heights(bitting, depth_table);

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
        key_bitting(heights, cut_locations, 2.1336, 90);
    }
}

// Defaults
bitting="";
outline="KW1";
warding="KW1";
kwikset(bitting, outline, warding);
