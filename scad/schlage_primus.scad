use <keygen.scad>
include <schlage.gen.scad>

module side_bit_milling(cut_locations, bitting="") {
    sbm_cut_locations = [for(i=[0:len(cut_locations)-2]) 0.5 * (cut_locations[i] + cut_locations[i+1])];
    
    sbm_offsets_mil = [[], [-32, 48], [-32, 24], [0, 60], [0, 36], [32, 48], [32, 24]];
    sbm_offsets = [for(p=sbm_offsets_mil) [for(e=p) e * 0.0254]];
    sbm_angle = 120;
    sbm_max_height = 140 * 0.0254;
    sbm_cutter_radius= 29 * 0.0254;
    sbm_dist = 5;
    sbm_eps = 0.1;
    sbm_on_ramp = 29;

    heights = key_code_to_heights(bitting, sbm_offsets);

    rotate(-90, [0, 1, 0]) rotate(-90, [0, 0, 1])
        linear_extrude(height=sbm_dist)
            minkowski() {
                union() {
                    for(i=key_enum(heights)) {
                        translate([sbm_cut_locations[i], 0])
                            polygon([[heights[i][0], heights[i][1] + sbm_cutter_radius],
                                    [tan(0.5 * sbm_angle) * (sbm_max_height-heights[i][1]-2*sbm_cutter_radius), sbm_max_height - sbm_cutter_radius],
                                    [-tan(0.5 * sbm_angle) * (sbm_max_height-heights[i][1]-2*sbm_cutter_radius), sbm_max_height - sbm_cutter_radius]]);
                    }
                    translate([sbm_on_ramp + sbm_cutter_radius, 0])
                        polygon([[0, 0],
                                 [tan(0.5 * sbm_angle) * (sbm_max_height-2*sbm_cutter_radius), sbm_max_height - sbm_cutter_radius],
                                 [-tan(0.5 * sbm_angle) * (sbm_max_height-2*sbm_cutter_radius), sbm_max_height - sbm_cutter_radius]]);
                    polygon([[sbm_cut_locations[0], sbm_max_height - sbm_cutter_radius],
                              [sbm_on_ramp, sbm_max_height - sbm_cutter_radius],
                              [sbm_on_ramp, sbm_max_height - sbm_cutter_radius - sbm_eps],
                              [sbm_cut_locations[0], sbm_max_height - sbm_cutter_radius - sbm_eps]]);
                }
                circle(r=sbm_cutter_radius, center=true, $fn=$fn ? 4*$fn : 48);
            }
}

module schlage_primus(bitting="",
                      outline_name="6-pin",
                      warding_name="C") {

    name = "Schlage Primus Classic";

    /*
        Bitting is specified from bow to tip, 0-9, with 0 being the shallowest cut and 9 being the deepest.

        Then, side-bit milling is specified from bow to tip, 1-6.

        A dash separates the two.

        Example: 253636-24436
    */

    // TODO is 5-pin primus a thing??

    outlines_k = ["6-pin"];
    outlines_v = [[outline_6pin_points, outline_6pin_paths,
                   [-outline_6pin_points[92][0], -outline_6pin_points[98][1]],
                   engrave_6pin_points,
                   engrave_6pin_paths]];

    // TODO add primus keyways

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

    bitting_list = key_split_on_dash(bitting);
    top_bitting = bitting_list[0];
    side_bitting = len(bitting_list) > 1 ? bitting_list[1] : "";

    heights = key_code_to_heights(top_bitting, depth_table);


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
        side_bit_milling(cut_locations, side_bitting);
    }
}

// Defaults
bitting="";
outline="6-pin";
warding="C";
schlage_primus(bitting, outline, warding);
