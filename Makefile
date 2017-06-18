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
SCAD_SRC  = $(SCAD_DIR)/schlage.scad

# Generated polygon files
POLY_OBJ = $(patsubst $(SVG_DIR)/%.svg,$(POLY_DIR)/%.gen.scad,$(SVG_SRC))

# Generated STL
STL_OBJ = 

OBJECTS = $(POLYGON_OBJ) $(STL_OBJ)

POLYFLAGS  = 
SCADFLAGS  = 

# Targets
all: stl
poly: $(POLY_OBJ)
$(STL_DIR)/%.d: $(SCAD_DIR)/%.scad
	bin/parse.py $< $@
clean:
	-rm -f $(POLY_DIR)/*.gen.scad $(STL_DIR)/*.stl $(STL_DIR)/*.d
$(POLY_DIR)/%.gen.scad: $(SVG_DIR)/%.svg
	$(POLY) $(POLYFLAGS) --fname $@ $<

include $(patsubst $(SCAD_DIR)/%.scad,$(STL_DIR)/%.d,$(SCAD_SRC))

stl: $(STL_OBJ)
