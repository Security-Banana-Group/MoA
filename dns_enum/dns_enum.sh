#!/bin/bash
#Security Banana Group
#	Russell Babarsky
#	Enumerates DNS Information using the "host" command

#Check arguments passed to program
if [ "$#" -ne 1 ]; then
	echo "Usage: $0 file"
	echo "File Should contain hostnames that are valid addresses"
	exit
fi

#Check that tmp file does not exist
#Why do i check this? Because I don't want to just write over people's files
#Bad Design? Sure. But it works :-)
if [ -e "tmp.usage" ]; then
	echo "tmp.usage exists. Please remove that file and then re-run the script"	
	exit
fi

#parse and print output
while IFS='' read -r host || [[ -n "$host" ]]; do
	echo ""
	echo "------- Enumerating Host: $host -------";
	host $host > tmp.usage
	awk '/has address/ {print "Host "$1" Resolves to Address: " $4}' tmp.usage
done < "$1"

rm ./tmp.usage
