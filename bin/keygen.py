#!/usr/bin/env python3

import argparse
import os
import string
import sys
import subprocess

parser = argparse.ArgumentParser(description='Generates keys', epilog='All remaining arguments are passed to OpenSCAD.')
parser.add_argument("filename",
                    help="OpenSCAD source file for the key")
parser.add_argument("-b", "--bitting", dest='bitting',
                    help="Key bitting")
parser.add_argument("-u", "--outline", dest='outline',
                    help="Key blank outline")
parser.add_argument("-w", "--warding", dest='warding',
                    help="Key warding")
parser.add_argument("-o", "--output", dest='output', default="a.stl",
                    help="Output file (defaults to a.stl)")

(args, remaining) = parser.parse_known_args()

def escape(s):
    return s.translate(str.maketrans({'"':  '\\"',
                                      '\\': '\\\\'}));

scad = os.environ.get("SCAD", "openscad")
opts = []
if args.bitting is not None:
    opts += ["-D", 'bitting="{}"'.format(escape(args.bitting))]
if args.outline is not None:
    opts += ["-D", 'outline="{}"'.format(escape(args.outline))]
if args.warding is not None:
    opts += ["-D", 'warding="{}"'.format(escape(args.warding))]

r = subprocess.call([scad, args.filename, "-o", args.output] + opts + remaining)
sys.exit(r)
