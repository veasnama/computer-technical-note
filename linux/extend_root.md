# > How to extend root parition using LVM on Oracle Linux

1. Check Disk partitiono Scheme 

```
# lsblk
NAME          MAJ:MIN RM  SIZE RO TYPE MONTPOINT
 sr0            11:0    1 1024M  0 rom  
 vda           252:0    0   40G  0 disk 
 ├─vda1        252:1    0    1G  0 part /boot
 └─vda2        252:2    0   29G  0 part 
   ├─rhel-root 253:0    0 26.9G  0 lvm  /
   └─rhel-swap 253:1    0  2.1G  0 lvm  [SWAP]

- If disk size hasn't shown after extetnd if below cocmmand
  by repalce "sda" with actual disk device 
# echo 1>/sys/class/block/sda/device/rescan
```
2. Extend OS Disk
```
# yum -y install cloud-utils-growpart
# growpart -h
# growpart /dev/vda 2
```
- confirm the change was successful
```
# lsblk 
 NAME          MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
 sr0            11:0    1 1024M  0 rom  
 vda           252:0    0   40G  0 disk 
 ├─vda1        252:1    0    1G  0 part /boot
 └─vda2        252:2    0   39G  0 part 
   ├─rhel-root 253:0    0 26.9G  0 lvm  /
   └─rhel-swap 253:1    0  2.1G  0 lvm  [SWAP]
```
3. Resize root logical volume to occupy all space
- Resize the physical volume
```
# pvresize /dev/vda2
# pvs
```
- Check the size of the volume group configured
```
# vgs
   VG   #PV #LV #SN Attr   VSize   VFree 
   rhel   1   2   0 wz--n- <39.00g 10.00g
```
- Then resize logical volume used by the root file system using the extended volume group
```
# lvextend -r -l +100%FREE /dev/name-of-volume-group/root
```
- example: 
```
# df -hT | grep mapper
 /dev/mapper/ol-root xfs        27G  1.9G   26G   8% /

# sudo lvextend -r -l +100%FREE /dev/mapper/ol-root
Size of logical volume rhel/root changed from <26.93 GiB (6893 extents) to <36.93 GiB (9453 extents).
Logical volume rhel/root successfully resized.
```
4. Update the changes to the filesystem
- For ext4 filesystem
```
# resize2fs /dev/name-of-volume-group/root
```
- For xfs filesystem
```
# xfs_growfs /
```