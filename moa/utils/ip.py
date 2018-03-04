import re
import logging
import time
import struct
import datetime


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

ECHO_REPLY = 0
ECHO_REQUEST = 8
TIME_EXCEEDED = 11

class ICMP(object):
    """
    representation representing an Echo REQUEST
    http://www.networksorcery.com/enp/protocol/icmp/msg8.htm
    """

    code = None
    checksum = None

    def __init__(self,icmpType = ECHO_REQUEST,code=0,checksum=0,identifer=0,sequenceNumber=0,recvTime=0,sentTime=0):
        self.icmpType = icmpType
        self.code = code
        self.checksum = checksum
        self.identifer = identifer
        self.sequenceNumber = sequenceNumber
        self.receivedTime = recvTime
        self.sentTime = sentTime
    @classmethod
    def build_echo_request(cls):
        checksumHeader = struct.pack('!bbHHH',ECHO_REQUEST,0,0,0,0)
        data = struct.pack('d',time.time())
        final_checksum = cls._generate_checksum(checksumHeader,data)
        finalheader =  struct.pack('!bbHHH',ECHO_REQUEST,0, final_checksum,0,0)
        return (finalheader + data)

    def timediff(self):
        return (self.receivedTime - self.sentTime) * 1000
    @classmethod
    def _generate_checksum(cls,checksumHeader,data):
        """
        Note this implmenetation is taken from RFC 1071.

        """
        def carry_around_add(a, b):
            c = a + b
            return (c & 0xffff) + (c >> 16)
        """
        The checkSum of an icmp is the pair of consecutive bytes that are a 1 complements
        sum
        """
        tot = checksumHeader + data
        sum = 0
        totlen = len(tot)
        for i in range(0,totlen,2):
            pair = (tot[i] << 8) + tot[i+1]
            sum = carry_around_add(sum,pair)
        return ~sum & 0xffff

    @classmethod
    def icmp_from_raw(self,bytes,rtime,stime):
            icmpType,code,checksum, identifer, sequenceNumber, sTime = struct.unpack('!bbHHHd',bytes)
            return ICMP(icmpType=icmpType,code=code,checksum=checksum,identifer=identifer,sequenceNumber=sequenceNumber, recvTime=rtime,sentTime=stime )


def isValidIpAddress(address):
    return re.match(regex_address_check,address)
