"Melon" by kook.

The forum is a room.

Include Real-Time Delays by Erik Temple.

File of request (owned by another project) is called "request".

table of arguments
name (indexed text)	value (indexed text)
with 10 blank rows

When play begins:
	write file of request from table of arguments;
	while the forum is the forum:
		if file of request exists:
			read file of request into table of arguments;
			let count be number of filled rows in table of arguments;
			if count > 0:
				repeat through table of arguments:
					say "[name entry]: [value entry][line break]";
				blank out the whole of the table of arguments;
			else:
				wait 100 milliseconds before continuing;
		else:
			wait 100 milliseconds before continuing;
