#!/usr/bin/env python3

import sys
import os
import re
import json
import string
import itertools

scad_fn = sys.argv[1]
json_fn = sys.argv[2]

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

json_obj = {
    "name": n,
    "filename": scad_fn,
    "description": d,
    "outlines": os,
    "wardings": ws
}

with open(json_fn, "w") as f:
    print(json.dumps(json_obj), file=f)
