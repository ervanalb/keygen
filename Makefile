# Makefile for keygen

# Executables
ifdef OS
	POLY = python3 bin/paths2openscad.py
	RM = del /Q
	FixPath = $(subst /,\,$1)
else
	RM = -rm -f
	POLY = PYTHONPATH=/usr/share/inkscape/extensions bin/paths2openscad.py
    FixPath = $1
endif

SCAD_DIR = scad
SVG_DIR = resources
POLY_DIR = scad
JSON_DIR = build

# Files to include
SVG_SRC  = $(wildcard $(SVG_DIR)/*.svg)
SCAD_SRC  = $(SCAD_DIR)/schlage_classic.scad \
            $(SCAD_DIR)/kwikset.scad \
            $(SCAD_DIR)/best.scad \
            $(SCAD_DIR)/schlage_primus.scad \
            $(SCAD_DIR)/medeco_classic.scad \
            $(SCAD_DIR)/medeco_biaxial.scad \
            $(SCAD_DIR)/master.scad \
            $(SCAD_DIR)/X103-KW12.scad \

# Generated polygon files
POLY_OBJ = $(patsubst $(SVG_DIR)/%.svg,$(POLY_DIR)/%.gen.scad,$(SVG_SRC))

# Generated JSON files
JSON_OBJ = $(patsubst $(SCAD_DIR)/%.scad,$(JSON_DIR)/%.json,$(SCAD_SRC))

POLYFLAGS  = 

# Targets
all: $(JSON_DIR)/keys.json poly
poly: $(POLY_OBJ)
$(JSON_DIR)/%.json: $(SCAD_DIR)/%.scad
	python3 bin/parse.py $< $@
$(POLY_DIR)/%.gen.scad: $(SVG_DIR)/%.svg
	$(POLY) $(POLYFLAGS) --fname $@ $<
$(JSON_DIR)/keys.json: $(JSON_OBJ)
	python3 bin/json_merge.py $^ >$(JSON_DIR)/keys.json
clean:
	$(RM) $(call FixPath, $(POLY_DIR)/*.gen.scad $(JSON_DIR)/*.json)
