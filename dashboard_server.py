#!/usr/bin/env python3
"""
Simple server to run the Gift Genie Trends Dashboard
Usage: python dashboard_server.py
Then open: http://localhost:PORT/gift-trends.html
"""

import http.server
import socketserver
import webbrowser
import os
import socket

def find_free_port():
    """Find a free port to use"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(('', 0))
        s.listen(1)
        port = s.getsockname()[1]
    return port

PORT = find_free_port()
DIRECTORY = os.path.dirname(os.path.abspath(__file__))

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

print(f"🎁 Gift Genie Trends Dashboard Server")
print(f"📁 Serving from: {DIRECTORY}")
print(f"🌐 Opening: http://localhost:{PORT}/gift-trends.html")
print(f"⏹️  Press Ctrl+C to stop\n")

# Open browser automatically
webbrowser.open(f'http://localhost:{PORT}/gift-trends.html')

with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
    print(f"✅ Server running at http://localhost:{PORT}/")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n👋 Server stopped")
