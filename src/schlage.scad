use <keygen.scad>
include <schlage.gen.scad>

module schlage_classic(bitting="",
                       outline_name="5-pin",
                       warding_name="C") {

    name = "Schlage Classic";

    outlines_k = ["5-pin",
                  "6-pin"];
    outlines_v = [[outline_5pin_points, outline_5pin_paths,
                   [-outline_5pin_points[92][0], -outline_5pin_points[98][1]],
                   engrave_5pin_points,
                   engrave_5pin_paths],
                  [outline_6pin_points, outline_6pin_paths,
                   [-outline_6pin_points[92][0], -outline_6pin_points[98][1]],
                   engrave_6pin_points,
                   engrave_6pin_paths]];
    wardings_k = ["C",
                  "CE",
                  "E",
                  "EF",
                  "F",
                  "FG",
                  "H",
                  "J",
                  "K",
                  "L"];
    wardings_v = [warding_c_points,
                  warding_ce_points,
                  warding_e_points,
                  warding_ef_points,
                  warding_f_points,
                  warding_fg_points,
                  warding_h_points,
                  warding_j_points,
                  warding_k_points,
                  warding_l_points];

    outline_param = key_lkup(outlines_k, outlines_v, outline_name);
    outline_points = outline_param[0];
    outline_paths = outline_param[1];
    offset = outline_param[2];
    engrave_points = outline_param[3];
    engrave_paths = outline_param[4];

    warding_points = key_lkup(wardings_k, wardings_v, warding_name);
    
    cut_locations = [for(i=[.231, .3872, .5434, .6996, .8558, 1.012]) i*25.4];
    depth_table = [for(i=[0.335:-0.015:0.199]) i*25.4];

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
        key_bitting(heights, cut_locations, .7874);
    }
}

// Defaults
bitting="";
outline="5-pin";
warding="C";
schlage_classic(bitting, outline, warding);
