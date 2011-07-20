"Melon" by kook.

The forum is a room.

Use MAX_STATIC_DATA of 18000000.
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
with 199 blank rows

table of users
nick (indexed text)	id (indexed text)
with 100 blank rows

When play begins:
	read file of posts into table of posts;
	read file of users into table of users;

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

To list posts:
	repeat through table of posts:
		say "[user entry]: [subject entry] - '[content entry]'[line break]";
	say "[number of filled rows in the table of posts] posts.[line break]";

To list users:
	repeat through table of users:
		say "[id entry]: [nick entry][line break]";
	say "[number of filled rows in the table of users] users.[line break]";

To return (x - indexed text):
	append "[x]" to file of result;
	say "[x][line break]";

To print posts:
	repeat through table of posts in reverse order:
		return "[nick corresponding to id of user entry in table of users] said: ";
		return "<b>[subject entry]</b> - <pre>[content entry]</pre><br><br>[line break]";

To print send form:
	return "<br><br>
	<form action='/post' method='post'>
	<div><input type='text' name='subject' cols='60' value='subjectum'></div>
	<div><textarea name='content' rows='3' cols='60'>lala</textarea></div>
	<div><input type='submit' value='Send'></div>
	<input type='hidden' name='request' value='subject,content'>
	</form>";

To process the request:
	let post be some truth state;
	let post be false;
	let path be some indexed text;
	let user be some indexed text;
	let time be some indexed text;
	let content be some indexed text;
	let subject be some indexed text;
	let user nick be some indexed text;
	let request counter be some indexed text;
	[]
	repeat through table of arguments:
		if name entry is "post":
			if value entry is "True":
				let post be true;
		if name entry is "path":
			let path be value entry;
		if name entry is "user":
			let user be value entry;
		if name entry is "time":
			let time be value entry;
		if name entry is "content":
			let content be value entry;
		if name entry is "subject":
			let subject be value entry;
		if name entry is "request counter":
			let request counter be value entry;
		if name entry is "user nick":
			let user nick be value entry;
	[]
	write "<html><body>" to file of result;
	if path is "/":
		print posts;
		print send form;
	otherwise if path is "/post":
		if post is true:
			say "au";
			if there is an id of user in table of users:
				say "la";
				let old nick be nick corresponding to id of user in table of users;
				say "ma";
				if old nick is not user nick:
					say "da";
					say "old nick: [old nick], new nick: [user nick], updating nick...[line 	break]";
					say "pa";
					choose row with id of user in table of users;
					now nick corresponding to id of user in table of users is user nick;
				say "ya";
			else:
				say "adding new user[line break]";
				choose a blank row in table of users;
				now id entry is user;
				now nick entry is user nick;
			[]
			choose a blank row in table of posts;
			now user entry is user;
			now time entry is time;
			now content entry is content;
			now subject entry is subject;
			write file of posts from table of posts;
			write file of users from table of users;
			return "<b>Sent!</b><br>[line break]";
			list posts;
			list users;
		else:
			return "post me baby 1 2 3<br>";
		print posts;
		print send form;
	otherwise:
		append "404, dude" to file of result;
	[]
	return "<br><br><br>page source:<br><pre><page source></pre></body></html>";
	write "[request counter]" to file of readiness;