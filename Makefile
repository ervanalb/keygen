# Makefile for keygen

# Executables
SCAD = OPENSCADPATH=src:build openscad
POLY = PYTHONPATH=/usr/share/inkscape/extensions bin/paths2openscad.py

SCAD_DIR = src
SVG_DIR = resources
POLY_DIR = build
STL_DIR = build
JSON_DIR = build

# Files to include
SVG_SRC  = $(wildcard $(SVG_DIR)/*.svg)
SCAD_SRC  = $(SCAD_DIR)/schlage.scad

# Generated polygon files
POLY_OBJ = $(patsubst $(SVG_DIR)/%.svg,$(POLY_DIR)/%.gen.scad,$(SVG_SRC))

# Generated STL
STL_OBJ = # populated in .d files

# Generated JSON files
JSON_OBJ = $(patsubst $(SCAD_DIR)/%.scad,$(JSON_DIR)/%.json,$(SCAD_SRC))

POLYFLAGS  = 
SCADFLAGS  = 

# Targets
all: stl $(JSON_DIR)/keys.json
poly: $(POLY_OBJ)
$(STL_DIR)/%.d: $(SCAD_DIR)/%.scad
	bin/parse.py $< $(STL_DIR)/$*.d $(JSON_DIR)/$*.json
$(JSON_DIR)/%.json: $(SCAD_DIR)/%.scad
	bin/parse.py $< $(STL_DIR)/$*.d $(JSON_DIR)/$*.json
$(POLY_DIR)/%.gen.scad: $(SVG_DIR)/%.svg
	$(POLY) $(POLYFLAGS) --fname $@ $<
$(JSON_DIR)/keys.json: $(JSON_OBJ)
	bin/json_merge.py $^ >$(JSON_DIR)/keys.json
clean:
	-rm -f $(POLY_DIR)/*.gen.scad $(STL_DIR)/*.stl $(STL_DIR)/*.d $(JSON_DIR)/*.json

include $(patsubst $(SCAD_DIR)/%.scad,$(STL_DIR)/%.d,$(SCAD_SRC))

stl: $(STL_OBJ)
