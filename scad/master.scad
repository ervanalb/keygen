use <keygen.scad>
include <master.gen.scad>

module kwikset(bitting="",
               outline_name="K1",
               warding_name="K1") {

    name = "Master";

    /*
        Bitting is specified from bow to tip, 0-7, with 0 being the shallowest cut and 7 being the deepest.
        Example: 5437
    */

    outlines_k = ["K1"];
    outlines_v = [[outline_k1_points, outline_k1_paths,
                   [-outline_k1_points[61][0], -outline_k1_points[40][1]],
                   engrave_k1_points,
                   engrave_k1_paths]];
    wardings_k = ["K1",
                  "K2"];
    wardings_v = [warding_k1_points,
                  warding_k2_points];

    outline_param = key_lkup(outlines_k, outlines_v, outline_name);
    outline_points = outline_param[0];
    outline_paths = outline_param[1];
    offset = outline_param[2];
    engrave_points = outline_param[3];
    engrave_paths = outline_param[4];

    warding_points = key_lkup(wardings_k, wardings_v, warding_name);
    
    cut_locations = [for(i=[.187:.125:.563]) i*25.4];
    depth_table = [for(i=[0.2720, 0.2565, 0.2410, 0.2255, 0.2100, 0.1945, 0.1790, 0.1635]) i*25.4];

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
        key_bitting(heights, cut_locations, 1.27, cutter_height=3);
    }
}

// Defaults
bitting="";
outline="K1";
warding="K1";
kwikset(bitting, outline, warding);
