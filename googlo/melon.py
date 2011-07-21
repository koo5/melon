import cgi
from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app
import urllib
from google.appengine.api import urlfetch
import string
import sys

def get_secret():
    try:
	f = open('../secret', 'r')
	return f.read()
    except Exception:
	f = open('secret', 'r')
	return f.read()

secret = get_secret()

def get_server():
    try:
        f = open('../server', 'r')
	return f.read()
    except Exception:
        f = open('server', 'r')
	return f.read()

server = get_server()

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
	args['user nick'] = ""
	args['user'] = ""
    args['path'] = request.path
    args['method'] = method
    args['secret'] = secret
    return args

def fetch(user, request, method):
    args = urllib.urlencode(herp(user, request, method))
    try:
	return urlfetch.fetch(url = server,
			payload = args,
			method = urlfetch.POST,
			headers={'Content-Type': 'application/x-www-form-urlencoded'},
			deadline = 10).content
    except urlfetch.DownloadError:
	return 'X'#'cant connect to '+server

openIdProviders = (
    'Google.com/accounts/o8/id', # shorter alternative: "Gmail.com"
        'Yahoo.com',
            'MySpace.com',
                'AOL.com',
                    'MyOpenID.com'
                        # add more here
                        )


class MainPage(webapp.RequestHandler):

    def login_form(self):
	x=  "<form action=\"/login_redirect\" method=\"get\">"
	x+=  "<select name=\"url\">"
	for p in openIdProviders:
    	    p_name = p.split('.')[0] # take "AOL" from "AOL.com"
	    p_url = p.lower()        # "AOL.com" -> "aol.com"
	    x+='<option value="'+users.create_login_url(federated_identity=p_url)+'">'+p_name+'</option>'
	x+='</select>'
	x+='<input type="submit" value="Go Log in">'
	x+='</form>'
	x+="<form action=\"/login_redirect\" method=\"get\">"
	x+='<input type="text" name="url">'
	x+='</form>'
	return x
	
    def serve(self, user, method):
	res = fetch(user, self.request, method)
	res = string.replace(res, "<page source>", cgi.escape(res))
	res = string.replace(res, "<login>", self.login_form())
	self.response.out.write(res)

    def req(self, method):
	user = users.get_current_user()
	if (self.request.path == "/login_redirect"):
	    self.redirect(self.request.get('url'))
	elif (self.request.path == "/_ah/login_requered") or (self.request.path == "/") or user:
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