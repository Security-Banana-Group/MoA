#!/bin/bash

echo "==========================================="
echo "| Security Banana Unix Easy Priv-Esc Tool |"
echo "==========================================="

#Formatting and such here
divider="###########################################"

#Users on this host
echo $divider
echo "Enumerating users..."
cat /etc/passwd | cut -d : -f 1
echo $divider
echo ""

#Groups on this host
echo $divider
echo "Enumerating groups..."
cat /etc/group | cut -d : -f 1
echo $divider
echo ""

#/etc/passwd world-writeable
echo $divider
echo "Checking /etc/passwd permissions..."
cmd=$(stat -c "%A" /etc/passwd)
passperms=${cmd:8:1}
if [[ $passperms == "w" ]]; then
	echo -e "/etc/passwd is writeable! Add your own user!"
fi
echo $divider
echo ""

#/etc/shadow word-readable
echo $divider
echo "Checking /etc/shadow permissions..."
cmd=$(stat -c "%A" /etc/shadow)
passperms=${cmd:7:1}
if [[ $passperms == "r"  ]]; then
	echo "/etc/shadow is readable! Crack some hashes!!"
fi
echo $divider
echo ""

#/root has some "Everyone" premissions


#suid bit
echo $divider
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
echo $divider
echo ""
#
