import re
import logging
import time
import struct



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
    http://www.networksorcery.com/enp/protocol/icmp/msg8.htm
    """
    ECHO_REPLY = 0
    ECHO_REQUEST = 8
    code = None
    checksum = None

    def __init__(self,ttl = 28):
        self.build_echo_header()

    def build_echo_header(self):
        self.checksumHeader = struct.pack('!bbHHH',self.ECHO_REQUEST,0,0,0,0)
        self.data = struct.pack('d',time.time())
        final_checksum = self.checksum()
        self.finalheader =  struct.pack('!bbHHH',self.ECHO_REQUEST,0, final_checksum,0,0)
        self.msg = self.finalheader + self.data
    def carry_around_add(self,a, b):
        """
        If a two numbers end up being bigger then the 16 bit checksum, perform
        a carry
        """
        c = a + b
        return (c & 0xffff) + (c >> 16)

    def checksum(self):
        """
        The checkSum of an icmp is the pair of consecutive bytes that are a 1 complements
        sum
        """
        tot = self.checksumHeader + self.data
        sum = 0
        totlen = len(tot)
        for i in range(0,totlen,2):
            pair = (tot[i] << 8) + tot[i+1]
            sum = self.carry_around_add(sum,pair)
        return ~sum & 0xffff




def isValidIpAddress(address):
    return re.match(regex_address_check,address)
