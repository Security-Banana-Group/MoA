from moa.trace.ping import PingManager
from moa.utils.ip import TIME_EXCEEDED


class TraceManager():

    def __init__(self):
        self.pm = PingManager(timeout=4)
    def performTraceroute(self,address):
        print("Performing trace route to ", address)
        ttl = 1
        while True:
            msg,recvfrom = self.pm.performPing(address,ttl=ttl)
            if msg.icmpType != TIME_EXCEEDED:
                break
            print("%d %s" % (ttl,recvfrom))
            ttl +=1
