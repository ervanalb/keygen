# keygen
Tools for generating physical keys.

![Key in Inkscape](doc/inkscape.png "SC4")
![Key in OpenSCAD](doc/key.png "152698")

# Installation
Download the GitHub repository and extract the repository in the location you wish to use it.


## Prerequisites

Keygen requires OpenSCAD and Python to work properly. Both can be downloaded from their official websites.

https://openscad.org/

https://www.python.org/

## Windows 
Windows users will need to add OpenSCAD and python3 to the User Path; otherwise you will encounter errors. 

OpenSCAD will install in "C:\Program Files\OpenSCAD" by default

Add to Path:

```
C:\Program Files\OpenSCAD
```

## Linux
Linux installation is more straightforward, see OpenSCAD Installation Guide 

### Fedora 
```
sudo dnf install python3
```

```
sudo dnf install openscad
```


## How to use it
The keygen.py file located in \keygen-master\bin will be your main method of interacting with keygen.

Use the cd command to set your console's directory to keygen-master this will allow you to use the example commands as is.

keygen-master is located in the download's folder.

```
cd Downloads\keygen-master\keygen-master
```

To enter the help menu shown below.

```
bin/keygen.py -h
```

```
usage: keygen.py [-h] [scad/SCADFILE] [-b BITTING] [-u OUTLINE] [-w WARDING] [-o OUTPUT]
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

It is important to use the appropriate scad file with the key you are trying to generate, see examples below scad/kwikset.scad or scad/schlage_classic.scad. Do not use the files that have a .gen. In them, they are used for generating the keys in OpenSCAD.

If you do not get an output file, open the scad file you are trying to use and make sure you are using the correct variables as they are different across the key types some experimentation is required.

## Examples

```
python bin/keygen.py scad/kwikset.scad --bitting 25536 -o housekey.stl
```

```
python bin/keygen.py scad/schlage_classic.scad -u 6-pin -w L -b 999999 -o all_section_bump_key.stl
```

```
python bin/keygen.py scad/schlage_classic.scad -o key.png --render
```

## Contributing

There is a very limited selection of keys right now, to help out, see the guide on [how to model keys](doc/how_to_model_keys.md).

## Music

There is no keygen music yet, in the meantime, try [here](https://soundcloud.com/dualtrax/sets/orion-keygen-music)
