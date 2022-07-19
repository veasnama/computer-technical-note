## Change solaris 11 nodename or hostname 
-  To list the current hostname
```
# svccfg -s system/identity:node listprop config
config                       application
config/enable_mapping       boolean     true
config/ignore_dhcp_hostname boolean     false
config/loopback             astring
config/nodename             astring     DC-DEAM-ORACLE
```
- Change the hostname to geekserver by setting the property config/nodename to david-coder
```
svccfg -s system/identity:node setprop config/nodename="david-coder"
```
- Refresh and restart the system/identity:node service for the changes to take effect.
```
# svcadm refresh system/identity:node
```
```
# svcadm restart system/identity:node
```
-  Verify the changes
```
# svccfg -s system/identity:node listprop config
config                       application
config/enable_mapping       boolean     true
config/ignore_dhcp_hostname boolean     false
config/nodename             astring     david-coder
config/loopback             astring     david-coder
```
- Run hostname command to check if our hostname is changed 
```
# hostname
```
## Changes to /etc/hosts
- In Solaris 11, the loopback interface entry acts as the server’s own entry (In Solaris 10 it was the primary interface IP) and thus there is no need to add the hostname entry to the /etc/hosts file.
- But some application installers may fail due to this. So make sure you edit this file and change the hostname

```
# cat /etc/hosts
#
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Internet host table
#
::1             localhost
127.0.0.1       localhost    loghost
192.168.88.38    david-coder
```