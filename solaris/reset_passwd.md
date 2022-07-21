># How to reset root password in solaris 11.4

>1. [Boot from the Oracle Solaris Media](#iso)
>2. [Import the root pool](#rootpool)
>3. [Mount the boot environment](#beadm)
>4. [Remove the root password from /etc/shadow file](#passwdfile)
>5. [Update the boot achive](#updateboot)
>6. [Unmount the boot environment](#umoutbeadm)
>7. [Reboot the system to a single user mode](#singlemode)
>8. [Reset the root password](#resetroot)

---
1.  <b>Boot from the Oracle Solaris Media</b> <a name="iso"></a>
- Stop and bring the system to OK prompt (SPARC) or BIOS (x86) and Boot from the Oracle Solaris media(installation media or from the network), then select the Shell option (option 3).
---

![media screen](https://thegeekshub.com/wp-content/uploads/2022/03/oracle-solaris-installation-menu.jpg)


---

2.  <b>Import the root pool</b> <a name="#rootpool"></a>
- Import the root pool, Mostly the pool name for root file system is rpool. 
```
# zpool import -f rpool
```
3.  <b>Mount the boot environment</b> <a name="beadm"></a>
- Create a mount point for the boot environment
```
# mkdir /a_mount_point
```
- Check for the boot environments available
```
# beadm list
```
![beadm list](https://thegeekshub.com/wp-content/uploads/2022/03/solaris-beadm-list.jpg)

- As we can see we have two boot environments but here be named solaris-1 is currently active on reboot. So we will consider it (solaris-1) in next step.

- Mount the boot environment(in our case solaris-1) on the mount point /a_mount_point
```
# beadm mount solaris /a_mount_point
```

 
3.  <b>Remove the root password from /etc/shadow file</b> <a name="passwdfile"></a>
- Set the TERM type
```
# TERM=vt100
# export TERM
```
-  Edit the shadow file and clear all text between the first colon (:) and second colon(:). This text is the encrypted password for root.
- Make sure root password entry is deleted from shadow file
```
# cat shadow | grep root
```
![root password](https://thegeekshub.com/wp-content/uploads/2022/03/root-shadow-entry-deleted.jpg)

- By default, Solaris doesn’t allow empty password, for this the workaround is to Change the ‘PASSREQ’ option to ‘no’ in file (etc/default/login)

```
# cd default 
# vi login
```
![default setting](https://thegeekshub.com/wp-content/uploads/2022/03/PASSREQ-in-login.jpg)

4. <b>Update the boot achive</b> <a name="updateboot"></a>
```
# bootadm update-archive -R /a
```
5. <b>Unmount the boot environment</b> <a name="umoutbeadm"></a>

- Unmount the boot environment in this case soalris-1
```
# beadm umount solaris-1
```
6. <b>Reboot the system into a single user mode</b> <a name="singlemode"></a>
```
# halt
```
7. <b>Reset the root password</b> <a name="singlemode"></a>
```
# passwd -r files root
New Password: xxxxxx
Re-enter new Password: xxxxxx
passwd: password successfully changed for root
```
- After changing the root password, change back the ‘PASSREQ’ option to ‘YES’ in file (etc/default/login)
- Press Control-D to reboot the system
- Now we will be able to login with root user with the password you set.
