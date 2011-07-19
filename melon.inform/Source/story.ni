"Melon" by kook.

The forum is a room.

Use MAX_STATIC_DATA of 1800000.

Include Glulx Entry Points by Emily Short.

File of request (owned by another project) is called "request".
File of posts (owned by another project) is called "posts".

table of arguments
name (indexed text)	value (indexed text)
with 10 blank rows

table of bugguments
name	value
with 10 blank rows

table of wtf
naame (number)	vaalue (number)
with 4 blank rows

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
			let path be some indexed text;
			repeat through table of arguments:
				say "[name entry]: [value entry][line break]";
				if name entry is "path":
					let path be value entry;
				let name be name entry;
				let value be value entry;
				choose a blank row in table of bugguments;
				now name entry is name;
				now value entry is value;
				choose a blank row in the table of wtf;
				now naame entry is 5;
				now vaalue entry is 4;
			process the request of path;
			blank out the whole of the table of arguments;
			blank out the whole of the table of bugguments;
			write file of request from table of arguments;

To list posts:
	repeat through table of posts:
		say "[user entry]: [subject entry] - '[content entry]'[line break]";
	say "[number of filled rows in the table of posts] posts.[line break]";

To process the request of (path - indexed text):
	if path is "/sign":
		say "[path][line break]";
		say vaalue corresponding to naame of 5 in table of wtf;
		repeat through table of bugguments:
			say "[name entry] => [value entry][line break]";
		let user be value corresponding to the name of "user" in the table of bugguments;
		choose a blank row in table of posts;
		now user entry is user;
		write file of posts from table of posts;
		list posts;
	else:
		say "nope[line break]";