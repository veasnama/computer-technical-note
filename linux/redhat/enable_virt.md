# Enabling Virtualization 
 - The following minimum system resources are available:
```

6 GB free disk space for the host, plus another 6 GB for each intended VM.
2 GB of RAM for the host, plus another 2 GB for each intended VM.
4 CPUs on the host. VMs can generally run with a single assigned vCPU, but Red Hat recommends assigning 2 or more vCPUs per VM to avoid VMs becoming unresponsive during high load.
```
- The architecture of your host machine supports KVM virtualization.

- Notably, RHEL 8 does not support virtualization on the 64-bit ARM architecture (ARM 64).
The procedure below applies to the AMD64 and Intel 64 architecture (x86_64)

> ## Procedure 
1. Install the packages in the RHEL 8 virtualization module
```
# yum module install virt
```
2. Install the virt-install and virt-viewer packages

```
# yum install virt-install virt-viewer
```
3. Start the libvirtd service.
```
# systemctl start libvirtd
```
> ## Verification
```
# virt-host-validate
```