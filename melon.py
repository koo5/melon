import cgi

from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

import time
import string

requestcounter = 0

def table(request):
    args = dict()
    names = request.get('request').split(',')
    for each in names:
	args[each] = cgi.escape(request.get(each))
    return args


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

def bla(user, request):
    global requestcounter
    requestcounter += 1
    args = table(request)
    args['request counter'] = str(requestcounter)
    args['user nick'] = cgi.escape(user.nickname())
    args['user'] = user.user_id()
    args['path'] = request.path
    args['time'] = str(time.time())
    f = open('request', 'w')
    request_header(f,((len(args))))
    for name, val in args.iteritems():
	f.write(to_inform_indexed_text(name) + " " + to_inform_indexed_text(val) + "\n")
    f.close()
    while 1:
	try:
    	    f = open('readiness', 'r')
	    c = f.read()
	    f.close()
	    lines = c.splitlines()
	    if lines[1] == str(requestcounter):
		r = open('result', 'r')
		o = r.read()
		r.close()
		o = o.splitlines()
		del o[0]
		o = ''.join(o)
		return o
	    else:
		raise UserWarning
	except (IOError, IndexError, UserWarning):
    	    time.sleep(0.05)


class MainPage(webapp.RequestHandler):
    def get(self):
	user = users.get_current_user()
	if user:
		res = bla(user, self.request)
		res = string.replace(res, "<page source>", cgi.escape(res))
		
		self.response.out.write(res)
	else:
		self.redirect(users.create_login_url(self.request.uri))


application = webapp.WSGIApplication(
                                     [('/.*', MainPage)],
                                     debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()