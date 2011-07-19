#!/usr/bin/env python

import os
import time
import sys
import traceback # 4 nice errors
import select


def message (m):
    print >> sys.stderr, '#sending: ', [m]
    sys.stderr.flush()
    print m
    sys.stdout.flush()

old = ""

while 1:
    si,so,se = select.select([sys.stdin],[],[], 0.01)
    for s in si:
	if s == sys.stdin:
	    inp = sys.stdin.readline().rstrip("\n")
	    if inp != "":
		message(inp)

    if not os.path.exists('./request'):
	continue

    f = open('request', 'r')
    c = f.read()
    f.close()
    
    if old == c: continue
    old = c

    if len(c) < 1: continue
    if c[0] != '*': continue

    c = c.splitlines(True)

    if len(c) > 2:
	message("request")


