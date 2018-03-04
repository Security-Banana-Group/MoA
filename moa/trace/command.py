import argparse
import sys
import socket
from moa.utils.ip import isValidIpAddress
from moa.trace.traceroute import TraceManager



parser = argparse.ArgumentParser()

parser.add_argument('ipaddress', help="A valid ip address to trace")



if __name__ == "__main__":
    arguments = parser.parse_args()
    if isValidIpAddress(arguments.ipaddress):
        TraceManager().performTraceroute(arguments.ipaddress)
    try:
        address = socket.gethostbyname(arguments.ipaddress)
        TraceManager().performTraceroute(address)
    except socket.gaierror:
        print("Cannot find address \n")
        sys.exit(1)
