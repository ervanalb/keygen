#!/usr/bin/env python3

import sys
import os
import re
import json
import string
import itertools

def handle(fn):
    with open(fn) as f:
        scad_text = f.read()

    poly_reqs = re.findall(r'<(.+\.gen\.scad)>', scad_text)

    modules = re.findall(r"module\s+([^\s\(]+)\s*\("
                         r".+"
                         r"outlines_k\s*=\s*(\[[^\]]+\])"
                         r".+"
                         r"wardings_k\s*=\s*(\[[^\]]+\])"
                         , scad_text, flags=re.S)

    modules_parsed = [(n, json.loads(o), json.loads(w)) for (n, o, w) in modules]

    def sanitize(s):
        return "".join([c for c in s.lower() if c in string.ascii_lowercase + string.digits])

    all_keys = [(n, o, w) for (n, os, ws) in modules_parsed for o in os for w in ws]

    def stl_filename(n, o, w):
        return "$(STL_DIR)/{n}_{o_s}_{w_s}.stl".format(n=n, o=o, w=w, o_s=sanitize(o), w_s=sanitize(w))

    all_keys_makefile = ["{stl_fn}: {scad_fn} {deps}\n\t$(SCAD) $(SCADFLAGS) -D 'outline=\"{o}\"' -D 'warding=\"{w}\"' {scad_fn} -o $@"
        .format(n=n, o=o, w=w,
        scad_fn=fn, stl_fn=stl_filename(n, o, w), deps=" ".join(["$(POLY_DIR)/{}".format(r) for r in poly_reqs]))
        for (n, o, w) in all_keys]
    all_stl = [stl_filename(n, o, w) for (n, o, w) in all_keys]
    all_keys_makefile.append("all_stl: {}".format(" \\\n ".join(all_stl)))

    return all_keys, all_keys_makefile

all_keys, all_keys_makefile = (list(itertools.chain.from_iterable(e)) for e in zip(*[handle(fn) for fn in sys.argv[1:]]))

d = os.environ.get("BUILD_DIR", "")

with open(os.path.join(d, "key_blanks.d"), "w") as f:
    print("\n".join(all_keys_makefile), file=f)
with open(os.path.join(d, "key_blanks.json"), "w") as f:
    print(json.dumps(all_keys), file=f)
