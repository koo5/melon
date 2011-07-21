"Melon" by kook.

The forum is a room.

Use MAX_STATIC_DATA of 39000000.
[big big tables]

File of request (owned by another project) is called "request".
File of posts (owned by another project) is called "posts".
File of result (owned by another project) is called "result".
File of readiness (owned by another project) is called "readiness".
File of users (owned by another project) is called "users";

table of arguments
name (indexed text)	value (indexed text)
with 10 blank rows

table of posts
user (indexed text)	subject (indexed text)	content (indexed text)	time (indexed text)
with 1000 blank rows

table of users
nick (indexed text)	id (indexed text)
with 100 blank rows

blank users is a number that varies;
blank posts is a number that varies;
max users is a number that varies;
max posts is a number that varies;

When play begins:
	read file of posts into table of posts;
	read file of users into table of users;
	now blank users is number of blank rows in table of users;
	now blank posts is number of blank rows in table of posts;
	now max users is number of rows in table of users;
	now max posts is number of rows in table of posts;
	check quotas;

Understand "request" as serving a request. Serving a request is an action applying to nothing.

Carry out serving a request:
	if the file of request exists:
		read file of request into table of arguments;
		let count be number of filled rows in table of arguments;
		if count > 0:
			repeat through table of arguments:
				say "[name entry]: [value entry][line break]";
			process the request;
			blank out the whole of the table of arguments;
			write file of request from table of arguments;

Understand "list [text]" as listing;
Listing is an action applying to one topic;
Carry out listing "lolz":
	say "many lolz";

Carry out listing "posts":
	list posts;
To list posts:
	repeat through table of posts:
		say "[user entry]: [subject entry] - '[content entry]'[line break]";
	say "[number of filled rows in the table of posts] posts.[line break]";

Carry out listing "users":
	list users;
To list users:
	repeat through table of users:
		say "[id entry]: [nick entry][line break]";
	say "[number of filled rows in the table of users] users.[line break]";


To return (x - indexed text):
	append "[x]" to file of result;
	say "[x][line break]";
	

To return text (x - text):
	append "[x]" to file of result;
	say "[x][line break]";


To print posts:
	repeat through table of posts in reverse order:
		return "[nick corresponding to id of user entry in table of users] said: ";
		return "[subject entry]:[line break]<pre>[content entry]</pre><br><br>[line break]";

To print send form:
	return "<br><br>
	<form action='/post' method='post'>
	<div><input type='text' name='subject' cols='60' value='subjectum'></div>
	<div><textarea name='content' rows='3' cols='60'>lala</textarea></div>
	<div><input type='submit' value='Send'></div>
	<input type='hidden' name='request' value='subject,content'>
	</form>";

To process the request:
	let path be some indexed text;
	let user be some indexed text;
	let time be some indexed text;
	let method be some indexed text;
	let content be some indexed text;
	let subject be some indexed text;
	let user nick be some indexed text;
	[]
	repeat through table of arguments:
		if name entry is "path":
			let path be value entry;
		if name entry is "user":
			let user be value entry;
		if name entry is "time":
			let time be value entry;
		if name entry is "method":
			let method be value entry;
		if name entry is "content":
			let content be value entry;
		if name entry is "subject":
			let subject be value entry;
		if name entry is "user nick":
			let user nick be value entry;
	[]
	write "<html><body>" to file of result;
	check quotas, loudly;
	if path is "/":
		if user nick is not empty:
			return "hello [user nick]! nice to see you here.<br><br>[line break]";
		otherwise:
			return "<login>";
	otherwise if path is "/post":
		if method is "post":
			if there is an id of user in table of users:
				let old nick be nick corresponding to id of user in table of users;
				if old nick is not user nick:
					say "old nick: [old nick], new nick: [user nick], updating nick...[line break]";
					choose row with id of user in table of users;
					now nick corresponding to id of user in table of users is user nick;
					write file of users from table of users;
			else:
				say "adding new user[line break]";
				choose a blank row in table of users;
				now id entry is user;
				now nick entry is user nick;
				write file of users from table of users;
				now blank users is blank users - 1;
			[]
			if blank posts > 0:
				choose a blank row in table of posts;
				now user entry is user;
				now time entry is time;
				now content entry is content;
				now subject entry is subject;
				now blank posts is blank posts - 1;
				write file of posts from table of posts;
				return "<b>Sent!</b><br>[line break]";
			else:
				return text "Im full ... but there is still <a href='http://reddit.com'>reddit</a>!<br>";
			[]
			list posts;
			list users;
		else:
			return "POST me baby 1 2 3<br>";
	otherwise if path is "/_ah/login_required":
		return "<login>";
	otherwise:
		append "404, dude<br>" to file of result;
	[]
	print send form;
	print posts;
	[]
	return "<br><br><br>page source:<br><pre><page source></pre><a href='https://github.com/koo5/melon/blob/master/melon.inform/Source/story.ni'><img style='position: absolute; top: 0; right: 0; border: 0;' src='https://d3nwyuy0nl342s.cloudfront.net/img/abad93f42020b733148435e2cd92ce15c542d320/687474703a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f677265656e5f3030373230302e706e67' alt='Fork me on GitHub'></a></body></html>";
	write "done" to file of readiness;

Understand "check quotas" as checking quotas. Checking quotas is an action applying to nothing.
carry out checking quotas:
	say "checking...";
	check quotas;
	say "...done[line break]";
To check quotas, loudly:
	check quotas on table of users and warn "running out of users" or bitch "out of users - gonna overwrite someone lol" with blank users of max users[, loudly];
	check quotas on table of posts and warn "running out of posts, [blank posts] remaining" or bitch "out of posts - im read only now :(" with blank posts of max posts[, loudly];
	

To check quotas on (t - table name) and warn (w - text) or bitch (f - text) with (n - number) of (max - number), loudly:
	if n is 0:
		say "[f][line break]";
		if loudly:
			return "[f]<br>[line break]";
	else if n < max / 10:
		say "[w][line break]";
		if loudly:
			return "[w]<br>[line break]";
