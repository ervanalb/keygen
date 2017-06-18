# Makefile for keygen

# Executables
POLY = PYTHONPATH=/usr/share/inkscape/extensions bin/paths2openscad.py

SCAD_DIR = scad
SVG_DIR = resources
POLY_DIR = scad
JSON_DIR = build

# Files to include
SVG_SRC  = $(wildcard $(SVG_DIR)/*.svg)
SCAD_SRC  = $(SCAD_DIR)/schlage_classic.scad \
            $(SCAD_DIR)/kwikset.scad \
            $(SCAD_DIR)/best.scad \

# Generated polygon files
POLY_OBJ = $(patsubst $(SVG_DIR)/%.svg,$(POLY_DIR)/%.gen.scad,$(SVG_SRC))

# Generated JSON files
JSON_OBJ = $(patsubst $(SCAD_DIR)/%.scad,$(JSON_DIR)/%.json,$(SCAD_SRC))

POLYFLAGS  = 

# Targets
all: $(JSON_DIR)/keys.json poly
poly: $(POLY_OBJ)
$(JSON_DIR)/%.json: $(SCAD_DIR)/%.scad
	bin/parse.py $< $@
$(POLY_DIR)/%.gen.scad: $(SVG_DIR)/%.svg
	$(POLY) $(POLYFLAGS) --fname $@ $<
$(JSON_DIR)/keys.json: $(JSON_OBJ)
	bin/json_merge.py $^ >$(JSON_DIR)/keys.json
clean:
	-rm -f $(POLY_DIR)/*.gen.scad $(JSON_DIR)/*.json
