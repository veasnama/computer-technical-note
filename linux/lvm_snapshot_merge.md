#  Use LVM snapshot/merge to be able to restore an earlier state of the root filesystem

## Overview 
- To use this functionallity the systems root filesystem is installed on a LVM volume
- The /boot directory is stored on a partition without LVM
## Pay attention
- Ensure a backup of the system exists prior performing these steps
- Allocate enough space for the snapshot. Executing lvs after creation of the snapshot
- Below assumes the system is installed on just one volume More complex multi-volume solutions are possible but require proper testing
- Please note, this procedure has been tested with only a single snapshot taken from the volume.

## Using LVM Snapshot
<b> Deployment </b>
- The system can be deployed with kickstart. A volumegroup should be created
- the rootvolume should fill up at maximum half of that volumegroup
```
  [root@vmmanager ~]# lvs
  LV   VG Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root ol -wi-ao---- 30.00g
  swap ol -wi-ao----  6.00g
  [root@vmmanager ~]# vgs
  VG #PV #LV #SN Attr   VSize   VFree
  ol   1   2   0 wz--n- <59.00g <23.00g
```
<b> Create the snapshot </b>
```
  [root@vmmanager ~]# mkdir -p /var/backup
```
  
