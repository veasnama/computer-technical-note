# How to ssh login via root user on solaris 11.4

- Open Terminal window and switch to root user
1. Change the file /etc/ssh/sshd_config PermitRootLogin yes with PermitRootLogin no and save file
```
# vi /etc/ssh/sshd_config  

  PermitRootLogin yes

```
2. Comment out the “CONSOLE=/dev/console” line in /etc/default/login
```
# vi /etc/default/login

  #CONSOLE=/dev/console
```
3. Remove “;type=role” from the root entry in /etc/user_attr or use the below command.
```
# rolemod -K type=normal root
```
4. Restart the Services.

```
#svcadm restart svc:/network/ssh:default
```
