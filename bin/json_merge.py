#!/usr/bin/env python3

import sys
import json

def read_json_file(fn):
    with open(fn) as f:
        return json.load(f)

combined = [read_json_file(fn) for fn in sys.argv[1:]]

print(json.dumps(combined))
