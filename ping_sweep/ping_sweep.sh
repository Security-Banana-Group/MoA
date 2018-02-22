#!/bin/bash
#Security Banana Group
#       Russell Babarsky
#       Enumerates DNS Information using the "host" command

#Check arguments passed to program
if [[ "$#" -ne 1 ]]; then
        echo "Usage: $0 address_range"
        echo "address_range should contain a valid address"
        exit
fi

if [[ $1 = *"-"* ]]; then
	seqone=$(echo $1 | sed 's/-/./' |awk -F '.' '{print $1" "$5}')
	seqtwo=$(echo $1 | sed 's/-/./' |awk -F '.' '{print $2" "$6}')
	seqthree=$(echo $1 | sed 's/-/./' |awk -F '.' '{print $3" "$7}')
	seqfour=$(echo $1 | sed 's/-/./' |awk -F '.' '{print $4" "$8}')
	
	for i in `seq $seqone`; do
		for j in `seq $seqtwo`; do
			for k in `seq $seqthree`; do
				for l in `seq $seqfour`; do
					ipaddr="$i.$j.$k.$l"
					ping -c 1 $ipaddr | tr '\n' ' ' | awk '/1 received/ {print "Host "$2" is alive" }'
				done
			done	
		done
	done

elif [[ $1 = *"/"*  ]]; then
	echo "CIDR notation"

else
	echo "Did not hit either"
	exit
fi

