use <keygen.scad>
include <medeco.scad>

module medeco_m3(bitting="",
                      outline_name="M3",
                      warding_name="M3",
                      slider_depth=.6) {

    name = "Medeco M3";

    /*
        "A" variants of key outlines indicates 6-pin version.

        Bitting is specified from bow to tip, 1-6, with 1 being the shallowest cut and 6 being the deepest.

        After each number, a letter K,B,Q,L,C,R,M,D,S is specified for the cut angle and offset.

        Example: 2K5B3Q6M3S
                          
        Note: KBQ & MDS Biaxial cuts (Fore & Aft) do not appear to be used in conjunction with LCR Classic cuts(Centered)
        
        Example: 2K5B3Q6M3S or 2L5C3R6L3R
                          
        Note: On non-Biaxial(locks not utilizing Fore or Aft cuts) M3 Cam locks, only the deepest 4 cut depths are used (3,4,5,6) and only the deepest 3 cut depths (4,5,6) on Biaxial M3 Cam locks
        
        Example: 3L5C3R6L4R or 4K5B4Q6M4S
        
        The M3 slider variable has been added and can be measured in inches from either the key or the face of a gutted lock.
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
                  "1655",
                  "M3"];

    wardings_k = ["1515",
                  "1517",
                  "1518",
                  "1542",
                  "1543",
                  "1638",
                  "1644",
                  "1655",
                  "M3"];

    outline_param = key_lkup(outlines_k, outlines_v, outline_name);
    outline_points = outline_param[0];
    outline_paths = outline_param[1];
    offset = outline_param[2];
    engrave_points = outline_param[3];
    engrave_paths = outline_param[4];

    warding_points = key_lkup(wardings_k, wardings_v, warding_name);
    
    cut_locations = [for(i=[0.244, 0.414, 0.584, 0.754, 0.924, 1.094]) i*25.4];
    depth_table = [for(i=[0.280+0.025:-0.025:0.154]) i*25.4];
    angles_k = ["K", "B", "Q", "M", "D", "S", "L", "C", "R"];
    angles_v = [[20, -.7874], [0, -.7874], [-20, -.7874],
                [20, .7874],  [0, .7874],  [-20, .7874], 
                [20, 0],      [0, 0],      [-20, 0]];

    bitting_depth = [for(i=[0:2:len(bitting)-1]) bitting[i]];
    bitting_angle = [for(i=[1:2:len(bitting)-1]) bitting[i]];
    heights = key_code_to_heights(bitting_depth, depth_table);
    angles_and_offsets = [for(c=bitting_angle) key_lkup(angles_k, angles_v, c)];
    angles = [for(c=angles_and_offsets) c[0]];
    offsets = [for(c=angles_and_offsets) c[1]];
    
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
        key_bitting(heights, cut_locations + offsets,
                    flat=.381, angle=86, // from CW-1012 cutter specs
                    angles=angles);
        m3_slider(slider*25.4);
    }
}

// Defaults
bitting="";
outline="M3";
warding="M3";
slider=0.6;
medeco_m3(bitting, outline, warding, slider);