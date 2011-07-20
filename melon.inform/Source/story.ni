"Melon" by kook.

The forum is a room.

Use MAX_STATIC_DATA of 1800000.

Include Glulx Entry Points by Emily Short.

File of request (owned by another project) is called "request".
File of posts (owned by another project) is called "posts".

table of arguments
name (indexed text)	value (indexed text)
with 10 blank rows

table of posts
user (indexed text)	subject (indexed text)	content (indexed text)
with 199 blank rows

When play begins:
	read file of posts into table of posts;

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

To process the request:
	let path be some indexed text;
	let user be some indexed text;
	let content be some indexed text;
	let subject be some indexed text;
	[]
	repeat through table of arguments:
		if name entry is "path":
			let path be value entry;
		if name entry is "user":
			let user be value entry;
		if name entry is "content":
			let content be value entry;
		if name entry is "subject":
			let subject be value entry;
	[]
	say "[path][line break]";					
	[]
	if path is "/sign":
		choose a blank row in table of posts;
		now user entry is user;
		now content entry is content;
		now subject entry is subject;
		write file of posts from table of posts;
		list posts;
	else:
		say "nope[line break]";