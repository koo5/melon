import cgi

from google.appengine.api import users
from google.appengine.ext import webapp
from google.appengine.ext.webapp.util import run_wsgi_app

class MainPage(webapp.RequestHandler):
    def get(self):
        self.response.out.write("""
          <html>
            <body>
              <form action="/sign" method="get">
                <div><input type="text" name="subject" cols="60" value="subjectum"></div>
                <div><textarea name="content" rows="3" cols="60">lala</textarea></div>
                <div><input type="submit" value="Send"></div>
                <input type="hidden" name="request" value="subject,content">
              </form>
            </body>
          </html>""")


def table(request):
    args = dict()
    names = request.get('request').split(',')
    for each in names:
	args[each] = request.get(each)
    return args


def header(f, leng):
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
    args = table(request)
    args['user'] = user.user_id()
    args['path'] = request.path
    f = open('request', 'w')
    header(f,((len(args))))
    print args
    for name, val in args.iteritems():
	f.write(to_inform_indexed_text(name) + " " + to_inform_indexed_text(val) + "\n")
    f.close()


class Guestbook(webapp.RequestHandler):
    def get(self):
	user = users.get_current_user()
	if user:
	    bla(user, self.request)
	else:
            self.redirect(users.create_login_url(self.request.uri))
            

application = webapp.WSGIApplication(
                                     [('/', MainPage),
                                      ('/sign', Guestbook)],
                                     debug=True)

def main():
    run_wsgi_app(application)

if __name__ == "__main__":
    main()