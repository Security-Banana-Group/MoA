==OS Detection Tool==
The OS Detection tool uses an IPv4 address's TTL from a ping to determine
the operating system of the box. If it cannot determine the operating system,
it specifies so in the output. 

The OS Detection tool has two different settings.
-A single IP address input, by invoking the command "Bash OS_Tool.sh"
-A multiple IP address input, by invoking the command "Bash OS_Tool.sh -l <filename.txt>"

==Single address mode==
The user will be prompted to input an IP address (within valid scope/formatting).
The script will verify whether or not the IP is valid, and then check whether the
address is a Unix, Windows, or OpenBSD box. If it cannot determine an OS based
off of the TTL returned from the ping, it will specify.

==Multiple address mode==
The user can pass a list of IP addresses, with each IP on a separate line in a .txt file,
by using the "-l" flag. If a flag not "-l" is specified, the code will throw an exception.
It will parse the entire list of IPs, whether or not they are valid, and specify the OS 
of the IP if it can determine any. If it cannot determine the IP, it will say so. If it
is not a properly formatted IPv4 address, it will say so. 

Example of an input file:
xx.xx.x.x
x.x.x.x
xxx.xxx.xx.x
xx.xxx.x.xxx

^Each address should be on a new line.
