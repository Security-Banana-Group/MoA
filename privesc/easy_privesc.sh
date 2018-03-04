#!/bin/bash
#Formatting and such here
divider="###########################################"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m\n' #Note the newline 

printf "${YELLOW}===========================================${NC}"
printf "${YELLOW}| Security Banana Unix Easy Priv-Esc Tool |${NC}"
printf "${YELLOW}===========================================${NC}"

#Users on this host
echo $divider
printf "${GREEN}Enumerating users...${NC}"
cat /etc/passwd | cut -d : -f 1
echo $divider
echo ""

#Groups on this host
echo $divider
printf "${GREEN}Enumerating groups...${NC}"
cat /etc/group | cut -d : -f 1
echo $divider
echo ""

#/etc/passwd world-writeable
echo $divider
printf "${GREEN}Checking /etc/passwd permissions...${NC}"
cmd=$(stat -c "%A" /etc/passwd)
passperms=${cmd:8:1}
if [[ $passperms == "w" ]]; then
	printf "${RED}/etc/passwd is writeable ${NC}"
fi
echo $divider
echo ""

#/etc/shadow word-readable
echo $divider
printf "${GREEN}Checking /etc/shadow permissions...${NC}"
cmd=$(stat -c "%A" /etc/shadow)
shadowperms=${cmd:7:1}
if [[ $passperms == "r"  ]]; then
	printf "${RED}/etc/shadow is readable! Crack some hashes!!${NC}"
fi
echo $divider
echo ""

#/root has some "Everyone" premissions
echo $divider
printf "${GREEN}Checking /root for misconfigs...${NC}"
cmd=$(stat -c "%A" /root)
rootperms=${cmd:7:1}
if [[ $rootperms == "r"  ]]; then
	printf "${RED}/root is readable${NC}"
fi
echo $divider
echo ""

#suid bit
echo $divider
printf "${GREEN}Checking for setuid bit binaries...${NC}"
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
echo $divider
echo ""
#
