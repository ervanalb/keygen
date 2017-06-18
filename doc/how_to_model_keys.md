# How to model a new key

![Key in Inkscape](inkscape.png "SC4")
![Key in OpenSCAD](key.png "152698")

## How it Works
1. Get some nice pictures of the side and tip of your key.
I recommend a flatbed scanner.
You may also consider finding a profile of your key in a [PDF
from the manufacturer](https://www.imlss.com/images/pdf/KBD12.pdf).
2. Using Inkscape, trace the key outline, warding, and engraving.
If you got your image from a PDF, your job is much easier,
and you only need to clean up the paths.
3. Select a path and press `Control-Shift-O`. Give it a useful name, such as "outline" or "warding".
4. Save the result as a SVG in the `resources` folder. Run `make` to generate OpenSCAD polygons from your paths.
5. Look up online the various parameters of your key, such as plug diameter,
cut depths and locations.
5. Use the provided OpenSCAD functions `key_code_to_heights`,
`key_blank` and `key_bitting` to generate a 3D model of your key.
Use the provided OpenSCAD files as a template.
6. To add your key to the database,
edit the `Makefile` to include your `.scad` file in the `SCAD_SRC` variable.

For this to work, your final file must look like this:

```
module key_name(...) {
    name = "Human-readable name of your key";
    /*
        Description of your key, including
        how to properly format a bitting,
        possibly with examples
    */

    ...
}

// These defaults are overridden by
// -D on the command line
bitting = "default-bitting";
outline = "default-outline";
warding = "default-warding";
key_name(...);
```
