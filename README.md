# keygen
Tools for generating physical keys.

![Key in Inkscape](doc/inkscape.png "SC4")
![Key in OpenSCAD](doc/key.png "152698")

## How to use it
```
usage: keygen.py [-h] [-b BITTING] [-u OUTLINE] [-w WARDING] [-o OUTPUT]
                 filename

Generates keys.

positional arguments:
  filename              OpenSCAD source file for the key

optional arguments:
  -h, --help            show this help message and exit
  -b BITTING, --bitting BITTING
                        Key bitting
  -u OUTLINE, --outline OUTLINE
                        Key blank outline
  -w WARDING, --warding WARDING
                        Key warding
  -o OUTPUT, --output OUTPUT
                        Output file (defaults to a.stl)

All remaining arguments are passed to OpenSCAD.
```

### Examples

```bin/keygen.py scad/schlage_classic.scad --bitting 25536 -o housekey.stl```

```bin/keygen.py scad/schlage_classic.scad -u 6-pin -w L -b 999999 -o all_section_bump_key.stl```

```bin/keygen.py scad/schlage_classic.scad -o key.png --render```

## Contributing

There is a very limited selection of keys right now, to help out, see the guide on [how to model keys](doc/how_to_model_keys.md).

## Music

There is no keygen music yet, in the meantime, try [here](https://soundcloud.com/dualtrax/sets/orion-keygen-music)
