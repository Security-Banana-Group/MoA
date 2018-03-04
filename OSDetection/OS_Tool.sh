#! /usr/bin/bash
#OS Detection tool
#Written by Chris Procario

#This tool determines the operating system of a system
#based off the TTL returned from a ping

#if the user wishes to pass in a list of IP addresses,
#they must specify doing so with the "-l" flag, otherwise
#it will throw an error.

#if the user does not specify a flag and filename, i.e.
#"bash OS_Tool.sh", it will prompt the user for an IP
#address input

#IPv4 Only

# if arguments = 2
if [ $# -eq 2 ]
then
	# if -l flag for list is not used
	if [ "$1" != "-l" ]
	then
		echo "Please use the -l flag for IP lists"
		exit;

	# if -l flag for lists is used
	elif [ $1 = "-l" ]
	then
		file=$2

		IFS=$'\n'
		for ipaddress in $(cat ./$file)
		do
			#regex to check IP validity 
			if [[ "$ipaddress" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]
			then
				# ping the IP address(es)
				total_ttl=$(ping -c1 $ipaddress | grep -o 'ttl=[0-9]\{2,3\}' | sed 's/[^0-9]*//g')
				#check if unix box
				if [[ $total_ttl -eq 64 ]] || [[ $total_ttl -eq 57 ]]
				then
				        echo "$ipaddress is a Unix box"
				
				#check if windows box
				elif [[ $total_ttl -eq 128 ]]
				then
  					echo "$ipaddress is a Windows box"
	
				#check if openBSD box
				elif [[ $total_ttl -eq 255 ]]
				then
					echo "$ipaddress is OpenBSD"
	
				#otherwise no determined OS
				else
					echo "$ipaddress operating system cannot be determined."
				fi
			# if improper formatting, alert the user
			else
				echo "$ipaddress is not proper IPv4 addressing format"
			fi
		done
	fi

# if no file given
elif [ $# -ne 2 ]
	then

	#request IP address from user
	echo "Enter IP:"
	read ipaddress
	
	#verify address is valid
	if [[ "$ipaddress" =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]
	then
		#ping ip address if valid
		total_ttl=$(ping -c1 $ipaddress | grep -o 'ttl=[0-9]\{2,3\}' | sed 's/[^0-9]*//g')

		#check for unix
		if [ $total_ttl -eq 64 ] || [ $total_ttl -eq 57 ]
		then
			echo "$ipaddress is a Unix box"

		#check for windows
		elif [ $total_ttl -eq 128 ]
		then
			echo "$ipaddress is a Windows box"

		#check for OpenBSD
		elif [ $total_ttl -eq 255 ]
		then
			echo "$ipaddress is OpenBSD"

		#otherwise cannot determine OS
		else
			echo "$ipaddress operating system cannot be determined."
		fi
	#if improper formatting, guide user in right direction
	else
		echo "$ipaddress is improperly formatted. Please specify an IPv4 address from 0.0.0.0 to 255.255.255.255"
	fi
fi
