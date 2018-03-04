import argparse
import sys
import socket
from moa.utils.ip import isValidIpAddress
from moa.trace.traceroute import TraceManager



parser = argparse.ArgumentParser()

parser.add_argument('ipaddress', help="A valid ip address to trace")

def run_trace():
    arguments = parser.parse_args()
    if isValidIpAddress(arguments.ipaddress):
        TraceManager().performTraceroute(arguments.ipaddress)
    else:
        try:
            address = socket.gethostbyname(arguments.ipaddress)
            TraceManager().performTraceroute(address)
        except socket.gaierror:
            print("Cannot find address \n")
            sys.exit(1)


if __name__ == "__main__":
    run_trace()
