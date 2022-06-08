# Increase the size of virtual Disk in LDOM using zfs

### Assumption

- Guest Domain is running solaris 11
- underlying device for virtual disk is zvol
- filesystem on vdisk guest domain is ZFS

---

### There are two cases we have to think about :

1. zpool based on EFI labeled disk in guest domain
1. zpool based on SIM labeled disk in guest domain

[Note]

- EFI(GPT) label is used for disk that is bigger than 2TB
- SIM ( VTOC ) is a tranditional one is used for disk that are smaller than 2TB

### Expand zvol on Primary Domain

- Get the current volume size and increase the volume size on Primary Domain
- To get argument ldompool/vol01 that which create when made the guest domain please run:

```
primary@domain# zfs list
```

```
priary@domain# zfs get volsize ldompool/vol01
NAME              PROPERTY  VALUE  SOURCE
ldompool/vol01  volsize   50G    local
```

```
priary@domain# zfs set volsize=70g ldompool/vol01

```

### zpool based on EFI labeled disk in guest LDOM

```
ldompool# zpool get autoexpand rpool
NAME        PROPERTY    VALUE  SOURCE
rpool    autoexpand  off    local
```

- Check the size of rpool and set the auto-expand flag on:

```
ldompool # df -kl /rpool
Filesystem                 1024-blocks        Used   Available Capacity  Mounted on
rpool                      51351552          31    51351465     1%    /rpool

```

```
ldompool # zpool set autoexpand=on rpool
```

- Check the size of rpool again

```
ldompool # df -kl /rpool
Filesystem                 1024-blocks        Used   Available Capacity  Mounted on
rpool                      71995392          31    71995304     1%    /rpool

# zpool list rpool
NAME         SIZE  ALLOC   FREE  CAP  DEDUP  HEALTH  ALTROOT
rpool    69.8G    88K  69.7G   0%  1.00x  ONLINE  -

```

---

### zpool based on SMI labeled disk in guest LDOM

```
# format -e

AVAILABLE DISK SELECTIONS:
       0. c2t1d0 <SEAGATE-ST930003SSUN300G-0868 cyl 46873 alt 2 hd 20 sec 625>
          /pci@780/pci@0/pci@9/scsi@0/sd@1,0
       1. c2t3d0 <SEAGATE-ST930003SSUN300G-0868 cyl 46873 alt 2 hd 20 sec 625>
          /pci@780/pci@0/pci@9/scsi@0/sd@3,0
Specify disk (enter its number): 1

format> partition

PARTITION MENU:
        0      - change `0' partition
        1      - change `1' partition
        2      - change `2' partition
        3      - change `3' partition
        4      - change `4' partition
        5      - change `5' partition
        6      - change `6' partition
        7      - change `7' partition
        expand - expand label to use the maximum allowed space
        select - select a predefined table
        modify - modify a predefined partition table
        name   - name the current table
        print  - display the current table
        label  - write partition map and label to the disk
        ![cmd] - execute [cmd], then return
        quit
partition> expand
Expansion of label cannot be undone; continue (y/n) ? y
The expanded capacity was added to the disk label and "s2".
Disk label was written to disk.

partition> print
Current partition table (original):
Total disk cylinders available: 3980 + 2 (reserved cylinders)

Part      Tag    Flag     Cylinders        Size            Blocks
  0       root    wm       0 - 1420       49.91GB    (2842/0/0) 209534976
  1 unassigned    wu       0               0         (0/0/0)            0
  2     backup    wu       0 - 2968      69.93GB    (3980/0/0) 293437440
  3 unassigned    wm       0               0         (0/0/0)            0
  4 unassigned    wm       0               0         (0/0/0)            0
  5 unassigned    wm       0               0         (0/0/0)            0
  6 unassigned    wm       0               0         (0/0/0)            0
  7 unassigned    wm       0               0         (0/0/0)            0

partition> 0
Part      Tag    Flag     Cylinders        Size            Blocks
  0       root    wm       0 - 1420       49.91GB    (2842/0/0) 209534976

Enter partition id tag[root]:
Enter partition permission flags[wm]:
Enter new starting cyl[0]:
Enter partition size[209534976b, 2842c, 2841e, 102312.00mb, 99.91gb]: 2968c

partition> print
Current partition table (unnamed):
Total disk cylinders available: 2968 + 2 (reserved cylinders)

Part      Tag    Flag     Cylinders        Size            Blocks
  0       root    wm       0 - 2968      69.93GB    (3980/0/0) 293437440
  1 unassigned    wu       0               0         (0/0/0)            0
  2     backup    wu       0 - 2968      69.93GB    (3980/0/0) 293437440
  3 unassigned    wm       0               0         (0/0/0)            0
  4 unassigned    wm       0               0         (0/0/0)            0
  5 unassigned    wm       0               0         (0/0/0)            0
  6 unassigned    wm       0               0         (0/0/0)            0
  7 unassigned    wm       0               0         (0/0/0)            0

partition> label
[0] SMI Label
[1] EFI Label
Specify Label type[0]: 0
Ready to label disk, continue? y

partition> q

```

---

- Now we are going to use the auto-expand to resize the ZFS dataset

```
ldompool # df -kl /rpool
Filesystem                 1024-blocks        Used   Available Capacity  Mounted on
rpool                      51351552          31    51351465     1%    /rpool
```

```
ldompool # df -kl /rpool
Filesystem                 1024-blocks        Used   Available Capacity  Mounted on
rpool                      51351552          31    51351465     1%    /rpool

```

- Check the size again

```
ldompool # df -kl /rpool
Filesystem                 1024-blocks        Used   Available Capacity  Mounted on
rpool                      71995392          31    71995304     1%    /rpool

# zpool list rpool
NAME         SIZE  ALLOC   FREE  CAP  DEDUP  HEALTH  ALTROOT
rpool    69.8G    88K  69.7G   0%  1.00x  ONLINE  -
```

### Finally we're successfully resize the vdisk of Guest Domain or Virtual Machine in Solaris 11
