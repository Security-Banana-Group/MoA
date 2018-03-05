import os
import socket
import struct
import sys
import time
from moa.utils.ip import IPV4, ICMP

ICMP_CODE = socket.getprotobyname('icmp')

"""
As always I am just going to build things from the ground up
First we will generate the checksum for the ip packet.
Lets just support little endian.
Note this implmenetation is taken from RFC 1071.
"""
class PingManager(object):
    def __init__(self,timeout=1):
        self.ping_socket = socket.socket(socket.AF_INET, socket.SOCK_RAW,ICMP_CODE)
        self.ping_socket.settimeout(timeout)


    def performPing(self,destination,ttl=64):
        ping = ICMP()
        pmsg = None
        address = None
        stime = time.time()
        self.ping_socket.setsockopt(socket.SOL_IP, socket.IP_TTL, ttl)
        self.ping_socket.sendto(ICMP.build_echo_request(),(destination, 1))
        pmsg, address = self.ping_socket.recvfrom(64)
        return (ICMP.icmp_from_raw(pmsg[20:36],time.time(),stime),address)

    def closeSocket(self):
        self.ping_socket.close()
