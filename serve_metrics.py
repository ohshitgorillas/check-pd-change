#!/usr/bin/env python3

import http.server
import socketserver

PORT = 9101
METRICS_FILE = '/tmp/metrics.txt'

class MetricsHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Content-Type', 'text/plain; version=0.0.4')
        self.send_header('Access-Control-Allow-Origin', 'http://10.0.0.0')  # Allow access from the entire 10.0.0.0/24 subnet
        http.server.SimpleHTTPRequestHandler.end_headers(self)

    def do_GET(self):
        # Handle GET request, serve metrics from METRICS_FILE
        with open(METRICS_FILE, 'r') as f:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(f.read().encode())

Handler = MetricsHandler

httpd = socketserver.TCPServer(("", PORT), Handler)

print("Serving metrics at http://10.0.0.1:9101/metrics")
httpd.serve_forever()
