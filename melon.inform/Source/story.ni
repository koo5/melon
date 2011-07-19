"Melon" by kook.

The forum is a room.

Include Glulx Entry Points by Emily Short.

File of request (owned by another project) is called "request".

table of arguments
name (indexed text)	value (indexed text)
with 10 blank rows

[When play begins:]
	[write file of request from table of arguments;]

Understand "request" as serving a request. Serving a request is an action applying to nothing.

Carry out serving a request:
	if the file of request exists:
		read file of request into table of arguments;
		let count be number of filled rows in table of arguments;
		if count > 0:
			repeat through table of arguments:
				say "[name entry]: [value entry][line break]";
			[process the request of ]
			say the value corresponding to a name of "path" in the table of arguments;
			blank out the whole of the table of arguments;
			write file of request from table of arguments;

To process the request of (path - indexed text):
	if path is "/sign":
		say "[path][line break]";
	else:
		say "nope[line break]";