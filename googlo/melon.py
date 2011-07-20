import cgi
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
import urllib
from google.appengine.api import urlfetch
import string

def get_secret():
    with open('secret', 'r') as f:
	return f.read()

secret = get_secret()

def table(request):
    args = dict()
    names = request.get('request').split(',')
    for each in names:
	args[each] = cgi.escape(request.get(each))
    return args

def herp(user, request, method):
    args = table(request)
    if user:
	args['user nick'] = cgi.escape(user.nickname())
	args['user'] = user.user_id()
    else:
	del args['user nick']
	del args['user'] 
    args['path'] = request.path
    args['method'] = method
    args['secret'] = secret
    return args

def fetch(user, request, method):
    args = urllib.urlencode(herp(user, request, method))
    return urlfetch.fetch(url = "http://localhost:8081",
			payload = args,
			method = urlfetch.POST,
			headers={'Content-Type': 'application/x-www-form-urlencoded'})

class MainPage(webapp.RequestHandler):

    def serve(self, user, method):
	res = fetch(user, self.request, method).content
	res = string.replace(res, "<page source>", cgi.escape(res))
	self.response.out.write(res)

    def req(self, method):
	user = users.get_current_user()
	if (self.request.path == "/") or user:
	    self.serve(user, method)
	else:
	    self.redirect(users.create_login_url(self.request.uri))

    def get(self):
	self.req("get")
    def post(self):
	self.req("post")


application = webapp.WSGIApplication(
                                     [('/.*', MainPage)],
                                     debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()