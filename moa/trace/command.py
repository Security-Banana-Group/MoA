import argparse
import sys
from moa.utils.ip import isValidIpAddress
from moa.trace.ping import PingManager
from moa.trace.traceroute import performTraceroute



parser = argparse.ArgumentParser()

parser.add_argument('ipaddress', help="A valid ip address to trace")

if __name__ == "__main__":
    arguments = parser.parse_args()
    if isValidIpAddress(arguments.ipaddress):
        PingManager().performPing(arguments.ipaddress)
    else:
        parser.print_help()
        sys.exit(1)