use <keygen.scad>
include <sc4_polygons.scad>

key_blank(outline_points,
          warding_points,
          outline_paths=outline_paths,
          emboss_right_points=emboss_points,
          emboss_right_paths=emboss_paths,
          emboss_left_points=emboss_points,
          emboss_left_paths=emboss_paths,
          offset=-outline_points[187]);