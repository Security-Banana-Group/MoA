# MoA(Mission de Atacar)
Tools for diagnosis, observing, and scouting

# Requirements
https://mycourses.rit.edu/d2l/le/content/686133/viewContent/5035265/View

### PyTrace(Python3)
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
