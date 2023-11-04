#!/usr/bin/env python3

import http.server
import socketserver

# Define the IP address and port
IP_ADDRESS = "10.0.0.1"
PORT = 9101

class MetricsHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Content-Type', 'text/plain; version=0.0.4')
        self.send_header('Access-Control-Allow-Origin', f'http://{IP_ADDRESS}')  # Allow access from the specified IP
        http.server.SimpleHTTPRequestHandler.end_headers(self)

    def do_GET(self):
        # Handle GET request, serve metrics from METRICS_FILE
        with open('/tmp/metrics.txt', 'r') as f:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(f.read().encode())

Handler = MetricsHandler

httpd = socketserver.TCPServer((IP_ADDRESS, PORT), Handler)

print(f"Serving metrics at http://{IP_ADDRESS}:{PORT}/metrics")
httpd.serve_forever()
