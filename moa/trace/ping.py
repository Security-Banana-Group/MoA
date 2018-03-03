import os
import socket
import struct
import sys
import time
from moa.utils.ip import IPV4




ICMP_CODE = socket.getprotobyname('icmp')

"""
As always I am just going to build things from the ground up
First we will generate the checksum for the ip packet.
Lets just support little endian.
Note this implmenetation is taken from RFC 1071.
"""



def performPing(destination):
    destIpv4 = IPV4(destination)
    ping_socket = socket.socket(socket.AF_INET, socket.socket.raw,ICMP_CODE)


#   sock.setsockopt(socket.IPPROTO_IP, socket.IP_MULTICAST_TTL, 2)
#   setsockopt(socket.SOL_IP, socket.IP_TTL, 1)
