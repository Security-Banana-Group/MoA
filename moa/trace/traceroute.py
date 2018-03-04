from moa.trace.ping import PingManager
from moa.utils.ip import TIME_EXCEEDED
import socket
import sys
class TraceManager():

    def __init__(self):
        self.pm = PingManager(timeout=4)
    def performTraceroute(self,address):
        print("Performing trace route to ", address)
        ttl = 1
        done = False
        try:
            while not done:
                dn = None
                msg,recvfrom = self.pm.performPing(address,ttl=ttl)
                if msg.icmpType != TIME_EXCEEDED:
                    done = True
                print("%d %s ,%d ms" % (ttl,recvfrom[0] ,msg.timediff()))
                ttl +=1
        except socket.timeout:
            print("Timeout")
            sys.exit(1)
