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

#check to see if ipcalc is installed because thats important!

if [[ ! -x $(command -v ipcalc) ]]; then
	
	echo "The tool ipcalc is required for this script"
	echo "Please Install ipcalc with your local package manager"
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
	low=$(ipcalc -n $1 | grep HostMin | cut -d ' ' -f 4)
	high=$(ipcalc -n $1 | grep HostMax | cut -d ' ' -f 4)

	range=$(echo $low"-"$high)

	seqone=$(echo $range | sed 's/-/./' |awk -F '.' '{print $1" "$5}')
        seqtwo=$(echo $range | sed 's/-/./' |awk -F '.' '{print $2" "$6}')
        seqthree=$(echo $range | sed 's/-/./' |awk -F '.' '{print $3" "$7}')
        seqfour=$(echo $range | sed 's/-/./' |awk -F '.' '{print $4" "$8}')

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

else


	echo "Invalid Format for IP Range"
	exit
fi

