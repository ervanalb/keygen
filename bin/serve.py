#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
from socketserver import ForkingMixIn
from urllib.parse import urlparse, parse_qs
import tempfile
import subprocess
import os
import shutil

PORT_NUMBER = 8080
MAX_STR_LEN = 100

class MyHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        query_components = parse_qs(urlparse(self.path).query)
        if "key" not in query_components or len(query_components["key"]) != 1:
            with open("build/keys.json") as f:
                j = f.read()
            b = bytes(j, encoding="utf8")
            self.send_response(200)
            self.send_header("Content-type", "text/json; charset=utf-8")
            self.send_header("Content-length", len(b))
            self.end_headers()
            self.wfile.write(b)
        else:
            opts = [str(query_components["key"][0])]
            if "bitting" in query_components and len(query_components["bitting"]) == 1:
                opts += ["-b", str(query_components["bitting"][0])[0:MAX_STR_LEN]]
            if "outline" in query_components and len(query_components["outline"]) == 1:
                opts += ["-u", str(query_components["outline"][0])[0:MAX_STR_LEN]]
            if "warding" in query_components and len(query_components["warding"]) == 1:
                opts += ["-w", str(query_components["warding"][0])[0:MAX_STR_LEN]]

            with tempfile.NamedTemporaryFile(suffix=".stl") as tf:
                opts += ["-o", tf.name]
                r = subprocess.call(["bin/keygen.py"] + opts)
                if r != 0:
                    self.send_response(500)
                    self.send_header("Content-type", "text/plain; charset=utf-8")
                    self.end_headers()
                    self.wfile.write(b"Command exited with non-zero return code")
                else:
                    length = os.stat(tf.name).st_size
                    self.send_response(200)
                    self.send_header("Content-type", "application/sla")
                    self.send_header("Content-length", str(length))
                    self.send_header("Content-Disposition", 'inline; filename="key.stl"')
                    self.end_headers()
                    with open(tf.name, 'rb') as stl:
                        shutil.copyfileobj(stl, self.wfile)

class ForkingSimpleServer(ForkingMixIn, HTTPServer):
    pass

if __name__ == '__main__':
    httpd = ForkingSimpleServer(("", PORT_NUMBER), MyHandler)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
