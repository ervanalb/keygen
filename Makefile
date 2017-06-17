# Makefile for keygen

# Executables
SCAD = OPENSCADPATH=src:build openscad
POLY = PYTHONPATH=/usr/share/inkscape/extensions bin/paths2openscad.py

SCAD_DIR = src
SVG_DIR = resources
POLY_DIR = build
STL_DIR = build

# Files to include
SVG_SRC  = $(wildcard $(SVG_DIR)/*.svg)
SCAD_SRC  = $(wildcard $(SCAD_DIR)/*.scad)

# Generated polygon files
POLY_OBJ = $(patsubst $(SVG_DIR)/%.svg,$(POLY_DIR)/%.gen.scad,$(SVG_SRC))

# Generated STL
STL_OBJ = 

OBJECTS = $(POLYGON_OBJ) $(STL_OBJ)

# Assembler, compiler, and linker flags
POLYFLAGS  = 
SCADFLAGS  = 

# Targets
all: $(STL_OBJ)
poly: $(POLY_OBJ)
clean:
	-rm -f $(OBJECTS)
$(POLY_DIR)/%.gen.scad: $(SVG_DIR)/%.svg
	$(POLY) $(POLYFLAGS) --fname $@ $<
