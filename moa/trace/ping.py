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
def generate_checksum(src):
    pass



def performPing(destination):
    destIpv4 = IPV4(destination)
    generate_checksum(destIpv4)
    ping_socket = socket.socket(socket.AF_INET, socket.socket.raw,ICMP_CODE)
