- Virtualization has been a need of time over several past years as we have machines now even with 16 cores and memory in TBs. A single machine is now capable of accommodating even more than 100 VMs at a time. Oracle VM for SPARC formerly known as LDOMs has played a key role in oracles virtualization strategies and is improving with every version. Before start configuring our first oracle VM for SPARC let us understand types of ldoms, ldom services and virtual devices.

# Types of Guest Domain

1. Guest : No direct access to underlying hardware and does not provide virtual device or services to other ldoms. Uses virtual device.
2. I/O : has direct access to underlying hardware in the server. It can be used in cases like oracle DB which wants direct/raw access to the storage devices
3. Service: provides virtualized devices and services to guest domains.

4. Control: Service domain that also runs the ldoms manager software to control the configuration of hypervisor. This ldom manager is responsible for mapping between physical and virtual devices.

```
Abbreviation	Name	Purpose
VLDC	virtual logical domain channel	communication channel between logical domain and hypervisor
VCC	Virtual console concentrator	Acts as a virtual console for each logical domain
VSW	Virtual switch service	provides network access for guest ldoms to the physical network ports
VDS	virtual disk service	provides virtual storage service for guest ldoms
VCPU	virtual CPU	Each thread of a T series CPU acts as a virtual CPU
MAU	Mathematical arithmetic unit	Each core of T series CPU will have a MAU for accelerated RAS/DSA encryption
Memory		Physical memory is mapped into virtual memory and assigned to ldoms
VCONS	Virtual console	a port in guest ldom that connects to the VCC service in control domain
VNET	Virtual network	network port in guest ldom which is connected to the VSW service in the control domain
VSDEV	Virtual disk service device	physical storage device that is virtualized by VDS service in control domain
VDISK	Virtual disk	VDISK in guest domain is connected to the VDS service in control domain/service domain
```

# Setting up the Guest Domain

1. We would assign 8 VCPUs, 2 GB of memory and 1 MAU to our first guest ldom. Also a virtual network vnet1 will be created and associated with the virtual switch vsw0

```
primary# ldm
add-domain ldom01
```

```
primary# ldm add-vcpu 8 ldom01
```

```
primary# ldm add-memory 2G ldom01
```

```
primary-domain# ldm set-mau 1 ldom01
```

```
primary# ldm add-vnet vnet1 primary-vsw0 ldom01
```

## Adding storage to the guest domain

- Here we first need to specify the physical device that needs to be exported by vdsdev to the guest domain and then we actually add the virtual disk thus created to the guest domain. Now use any one of the 3 methods mentioned below.

1.  Adding physical disks

```
primary# ldm add-vdsdev /dev/dsk/c2t1d0s2 vol1@primary-vds0
```

```
primary# ldm add-vdisk vdisk1 vol1@primary-vds0 ldom01
```

2. Create File System and assign the size for our guest domain

```
primary# mkfile 10g /ldoms/ldom01_boot
primary# ldm add-vdsdev /ldoms/ldom01_boot vol1@primary-vds0
primary# ldm add-vdisk vdisk1 vol1@primary-vds0 ldom01
```

3.  Adding a volume

```
primary# zfs create -V 5gb pool/vol01
primary# ldm add-vdsdev /dev/zvol/dsk/pool/vol01 vol1@primary-vds0
primary# ldm add-vdisk vdisk1 vol1@primary-vds0 ldom01
```

## Setting Variables

- Setup the boot environment variable for the guest ldom.

```
primary# ldm set-var auto-boot?=true ldom01
primary# ldm set-var boot-device=vdisk1 ldom01
```

## Setting up the solaris ISO image for installing guest ldom

```
primary# ldm add-vdsdev options=ro /data/sol_10.iso iso@primary-vds0
primary# ldm add-vdisk sol10_iso iso@primary-vds0 ldom01
```

## Bind and start installing the ldom

```
primary# ldm bind ldom01
primary# ldm start ldom01
LDom ldom01 started
ok> devalias
ok> boot sol10_iso
```

## Connect the guest domain

- Now check the port which is bound with the guest domain and connect the virtual console of the guest domain.

```
primary:~ # ldm list
NAME    STATE  FLAGS CONS VCPU MEMORY UTIL UPTIME
primary active -n-cv  SP   8    4G    0.3% 8h 46m
ldom01  active -n--- 5000  8    2G     48% 1h 52m

```

```
primary# telnet localhost 5000 Trying 127.0.0.1...
    Connected to localhost.
    Escape character is ’^]’.
Connecting to console "ldom01" in group "ldom01" .... Press ~? for control options ..
```
