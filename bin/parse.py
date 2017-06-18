#!/usr/bin/env python3

import sys
import os
import re
import json
import string
import itertools

scad_fn = sys.argv[1]
d_fn = sys.argv[2]
json_fn = sys.argv[3]

with open(scad_fn) as f:
    scad_text = f.read()

poly_reqs = re.findall(r'<(.+\.gen\.scad)>', scad_text)

modules = re.findall(r"module\s+([^\s\(]+)\s*\("
                     r".+"
                     r'name\s*=\s*("[^"]+")'
                     r".+"
                     r'/\*(.+?)\*/'
                     r".+"
                     r"outlines_k\s*=\s*(\[[^\]]+\])"
                     r".+"
                     r"wardings_k\s*=\s*(\[[^\]]+\])"
                     , scad_text, flags=re.S)

if len(modules) == 0:
    print("Could not find any compatible modules in {}".format(scad_fn), file=sys.stderr)
    sys.exit(1)

module = modules[0]

(m, n, d, os, ws) = module

# Dirty hack to parse OpenSCAD types
n = json.loads(n)
d = d.strip()
os = json.loads(os)
ws = json.loads(ws)

def sanitize(s):
    return "".join([c for c in s.lower() if c in string.ascii_lowercase + string.digits])

all_keys = [(n, o, w) for o in os for w in ws]

def stl_filename(n, o, w):
    return "$(STL_DIR)/{n_s}_{o_s}_{w_s}.stl".format(n_s=sanitize(n), o_s=sanitize(o), w_s=sanitize(w))

all_keys_makefile = ["{stl_fn}: {scad_fn} {deps}\n\t$(SCAD) $(SCADFLAGS) -D 'outline=\"{o}\"' -D 'warding=\"{w}\"' {scad_fn} -o $@"
    .format(n=n, o=o, w=w,
    scad_fn=scad_fn, stl_fn=stl_filename(n, o, w), deps=" ".join(["$(POLY_DIR)/{}".format(r) for r in poly_reqs]))
    for (n, o, w) in all_keys]
all_stl = [stl_filename(n, o, w) for (n, o, w) in all_keys]
all_keys_makefile.append("STL_OBJ += {}".format(" \\\n ".join(all_stl)))

with open(d_fn, "w") as f:
    print("\n".join(all_keys_makefile), file=f
)

json_obj = {
    "name": n,
    "description": d,
    "outlines": os,
    "wardings": ws
}

with open(json_fn, "w") as f:
    print(json.dumps(json_obj), file=f)
