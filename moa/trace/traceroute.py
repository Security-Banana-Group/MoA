from moa.trace.ping import PingManager
from moa.utils.ip import TIME_EXCEEDED
import socket
import sys
class TraceManager():

    def __init__(self):
        self.pm = PingManager(timeout=1)
    def performTraceroute(self,address):
        print("Performing trace route to ", address)
        ttl = 1
        done = False
        retries = 0

        while not done:
            dn = None
            msg = None
            recvfrom = None
            text = "None"
            end_text = '\n'
            try:
                msg,recvfrom = self.pm.performPing(address,ttl=ttl)
                text = "%d %s ,%d ms" % (ttl,recvfrom[0] ,msg.timediff())
            except socket.timeout:
                end_text = ''
                retries += 1
                ttl -= 1
                text =  "Timeout Retrying"
                if retries > 1:
                    text = " *"
                if retries > 3:
                   ttl += 1
                   text = " Moving to next TTL"
                   end_text = '\n'
                   retries = 0

            if msg is not None and msg.icmpType != TIME_EXCEEDED:
                done = True
            print(text, end=end_text, flush=True)
            ttl += 1
