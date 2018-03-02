import re
import logging

regex_subnet = r'^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\/([0-9]|[1-2][0-9]|3[0-2])$'
regex_address_check  = r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$'
regex_address = r'^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$'

class IPV4(object):
    octects = []
    def __init__(self,ip_address):
        super().__init__()
        self.matches = re.search(regex_address,ip_address)
        self.octects = self.matches.groups()[:4]



class Network(object):
    octects = []
    def __init__(self,cidr_string):
        self.matches = re.search(regex_subnet,cidr_string)
        self.octects = self.matches.groups()[:4]
        self.mask =  int(self.matches.group(5))
        self.numberOfIpAdresses = 2**(32 - self.mask)



class ICMP(object):
    """
    representation representing an Echo REQUEST
    """
    ECHO_REPLY = 0
    ENCO_REQUEST = 8
    code = None
    checksum = None
    def __init(self):
        pass



def isValidIpAddress(address):
    return re.match(regex_address_check,address)
