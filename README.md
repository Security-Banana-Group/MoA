# MoA(Mission de Atacar)
Tools for diagnosis, observing, and scouting

# Requirements
https://mycourses.rit.edu/d2l/le/content/686133/viewContent/5035265/View

## PyTrace(Python3)
PyTrace is a pure python implementation of traceroute. Current features are
* ICMP based packet delivery
* Estimated Round Trips
* Domain name represnetation of visisted points

Sadly with the use of ICMP base messaging, one must have root access in order to run the command
### Installation
```
python3 setup.py install
```

### Development
```
python3 setup.py develop
```

### Usage
To use pytrace run:
```bash
sudo pytrace 8.8.8.8
```

or you can use the domain name

```bash
sudo pytrace www.w3schools.com
```

### Without Installation
go to moa/trace/ and execute:

```bash
python3 command.py [arguments]
```

## OSDetection(Bash)
A Tool for OS enumeration and detection

* Detects OS based off of TTL from a ping
* Regex to verify proper IPv4 formatting
* Ability to read a file with -l flag

### Usage

```bash
bash OS_Tool.sh
bash OS_Tool.sh -l <IP_List.txt>
```

## Ping Sweep(Bash)
A Tool for detecting hosts on a given network.

### Depedencies
ipcalc

### Usage

Ping sweep takes two IP range formats.

```bash
#Traditional Range
bash ping_sweep 192.168.1.0-192.168.1.255
```
```bash
#CIDR notation
bash ping_sweep 192.168.1.0/24
```


## Port Scanner(Power Shell)
A tools for scannning ports on a host in a particular network

### Usage

```bash
#Traditional Range
.\PortScan.ps1 192.168.1.1-192.168.1.5 20,80
```

```bash
#Cidr Notation
.\PortScan.ps1 192.168.1.0/24
```

## Priv Sec(Bash)
Does Priv Sec Things

### Usage
```bash
bash easy_privsec
```
