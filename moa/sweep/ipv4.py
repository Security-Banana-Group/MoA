
import re

regex_subnet = r'^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/([0-9]|[1-2][0-9]|3[0-2])$'
#yes you like my regex

class IPV4(object):

    octects = []

    def __init__(self,cidr_string):
        self.matches = re.search(regex_subnet,cidr_string)
        self.octects = self.matches.groups()[:4]
        self.mask =  int(self.matches.group(5))
        self.numberOfIpAdresses = 2**(32 - self.mask)
def sweep(self):

    for i in range(self.numberOfIpAdresses):
        if(octects[3] > 255):
            octects[3] = 0
            octects[2] += 1

        if(octects[2] > 255):
            octects[2] = 0
            octects[1] += 1

        if(octects[1] > 255):
            octects[1] = 0
            octects[0] +=1

        #Now just use a libray like scapy or build os.subprocess(ping)

if  __name__ == '__main__':
    print(IPV4("192.168.1.0/24").octects)
