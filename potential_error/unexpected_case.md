# Unexpected Case will happned for Server, Storage

## Disks

- When the disk is offline - How should we do ?
  - Check the disk status
  - Collecting the logs for investigation
  - Replace the disk if it is broken
  - Before we remove the disk make sure to detach it from the storage pool
- ## When the disk is added How should we do? ( in solaris case)
- When the controller is down or alarm how should we do ?
- When the disk is faulty how should we do ?
- When we attach the disk into zpool How do we do ?
- When we deattach the disk from the zpool How do we do ?
- For sparc server it reserver 1 disk for spare
- When if we add a new disk to the pool

```
zpool add pool-name device-name
```

- What if we want to set a quota for a specific file system under the pool

```
zfs set quota=500m pool-name/file-system-name

zfs set reserveration=400m pool-name/file-system-name
```

---

## RAM

- When replacing the RAM we should shutdown the SP and unplug the power cords
- When the RAM is broken How do we do ?

---
