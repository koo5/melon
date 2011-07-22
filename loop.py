#!/usr/bin/env python

import cgi
import os
import time
import sys
import traceback # 4 nice errors
import select
import BaseHTTPServer
import urllib
import urlparse

def debug (m):
    print >> sys.stderr, m
    sys.stderr.flush()


try:
    f = open('dev', 'r')
    import googlo.dev as settings
    debug ('dev')
    
except Exception:
    import googlo.prod as settings


def message (m):
    print >> sys.stderr, '#sending: ', [m]
    sys.stderr.flush()
    print m
    sys.stdout.flush()

def request_header(f, leng):
    f.write("* //72B4F7AB-F525-45F0-B5C7-FF9C0D38BCD7// request\n")
    f.write("! table of arguments (")
    f.write(str(leng))
    f.write(")\n")

def to_inform_indexed_text(t):
    r = "S"
    for c in t:
	r += str(ord(c)) + ","
    r += "0;"
    return r

def write_args(args):
    f = open('request', 'w')
    request_header(f,((len(args))))
    for name, val in args.items():
	f.write(to_inform_indexed_text(name) + " " + to_inform_indexed_text(val) + "\n")
    f.close()



class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
	def do_POST(s):
		s.send_response(200)
		s.send_header("Content-type", "text/html")
		s.end_headers()
		try:
		    os.remove('./readiness')
		except OSError:
		    pass
		    
		ctype, pdict = cgi.parse_header(s.headers.getheader('content-type'))
		if ctype == 'multipart/form-data':
            	    postvars = cgi.parse_multipart(s.rfile, pdict)
                elif ctype == 'application/x-www-form-urlencoded':
                    length = int(s.headers.getheader('content-length'))
                    postvars = cgi.parse_qs(s.rfile.read(length))
                else:
                    postvars = {}

		for name, val in postvars.items():
		    postvars[name] = val[0]
                    
		debug(postvars)
		
		if settings.secret != postvars['secret']:
		    return
		
		write_args(postvars)
		
		message('request')
		sys.stdout.flush()
		
		while not os.path.exists('readiness'):
		    time.sleep(0.01)
		
		r = open('result', 'r')
		o = r.read()
		r.close()
		o = o.splitlines(True)
		del o[0]
		o = ''.join(o)
		
		s.wfile.write(o)

httpd = BaseHTTPServer.HTTPServer(('0.0.0.0', 8081), MyHandler)
httpd.timeout = 0.01

while 1:
    si,so,se = select.select([sys.stdin],[],[], 0)
    for s in si:
	if s == sys.stdin:
	    inp = sys.stdin.readline().rstrip("\n")
	    if inp != "":
		message(inp)

    httpd.handle_request()
	
