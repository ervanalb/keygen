use <keygen.scad>
include <X103-KW12.gen.scad>

module X103_KW12(bitting="",
               outline_name="X103-KW12",
               warding_name="X103-KW12",
               series_name="5001-6000") {

    name = "X103_KW12";

    /*
        Bitting is specified from bow to tip, 0-4, with 0 being the shallowest cut and 1 being the deepest.
                   The 4th (5th?) entry in the depth table that seems way higher is the key I was trying to replicate seemed to skip the first cut location so I added that as a "Skip" value to use. 
        Example: 412221
                   
        This model is for a Kawasaki Key sometimes called a X103 or a KA14 I think
        I pulled the outline and such from the motorcycle guide I have added and the main 2 depth and cut location tables from the Framon Key depth guide (v8) 
    */
                   
    warding_min = min([for(e=warding_points) e[1]]);
    warding_max = max([for(e=warding_points) e[1]]);
    wardingHeight = warding_max-warding_min;
    echo ("wardingHeight", wardingHeight);
    offset = [-outline_points[23][0], -outline_points[23][1]];
    depth_table= 
        series_name=="801-845"  ? [for(i=[.255, .235, .215, .195, 20]) i*25.4] :
        series_name=="5001-6000"? [for(i=[.260, .240, .220, .200, 20]) i*25.4] :
        series_name=="custom"   ? [for(i=[.245, .215, .220, .200, 20]) i*25.4] :[];
    cut_locations=
        series_name=="801-845"  ? [for(i=[.1, .2, .3, .4, .5, .6]) i*25.4] :
        series_name=="5001-6000"? [for(i=[.1, .2, .3, .4, .5, .6]) i*25.4] :
        series_name=="custom"   ? [for(i=[.1, .2, .3, .4, .5, .6]) i*25.4] :[];

    // Kwikset starts with 1??

    heights = key_code_to_heights(bitting, depth_table);
    echo("series_name", series_name);
    echo("bitting", bitting);
    echo ("heights", heights);
    echo ("heightsIN", [for(e=heights)e/25.4]);
    difference() 
    {
        if($children == 0) {
            key_blank(outline_points,
                      warding_points,
                      outline_paths=outline_paths,
                      engrave_right_points=engraving_points,
                      engrave_right_paths=engraving_paths,
                      engrave_left_points=engraving_points,
                      engrave_left_paths=engraving_paths,
                      offset=offset,
                      plug_diameter=12.7);
        } else {
            children(0);
        }
        key_bitting(heights, cut_locations, 1.4, 90);
        //This is my attempt at adding double sidded cutting Hopefully it works for others.
        translate([0,0,wardingHeight]){ 
        rotate([0,180,0]){
            key_bitting(heights, cut_locations, 1.4, 90);
        }
        }
    }
}

// Defaults
//bitting="412221";
bitting ="";
outline="X103-KW12";
warding="X103-KW12";
series_name="5001-6000";
X103_KW12(bitting, outline, warding, series_name);
