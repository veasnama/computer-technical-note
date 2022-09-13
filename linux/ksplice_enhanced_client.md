# Install and Setup Ksplice Enhanced Client on Oracle Linux 8 or later

```
# sudo dnf install -y ksplice uptrack

# cat /etc/uptrack/uptrack.conf

# sudo dnf --disablerepo=*
--enablerepo=ol8_x86_64_userspace_ksplice update

# yum update glibc* openssl* // in case above didn't work

# vi /etc/uptrack/uptrack.conf

# edit the file and change into below

# autoinstall = yes

# sudo systemctl reboot
```

## After reboot we change upgrade all user space packages.

```
# ksplice user upgrade
```

## Tips to list all of the running user space processes that the client can patch

```
# sudo ksplice all list-targets
```
