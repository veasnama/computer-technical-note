# Exadata Cluster Network Configuration with Virtual Machines

This document outlines the network configuration for an Oracle Exadata Cluster using virtual machines, with the Admin Network used for Operating System management.

## Admin Network (OS Management)
- **Purpose**: Facilitates OS management for virtual machines and physical database servers, including SSH access, system monitoring, and configuration.
- **Type**: Ethernet (1/10 GbE).
- **Subnet**: 10.0.1.0/24 (example).
- **Configuration**:
  - Assign static IPs for each VM and physical server’s OS management interface (e.g., `eth0` or `veth0` for VMs).
  - Configure DNS for management hostnames.
  - Open ports: SSH (22), SNMP (162), HTTPS (443 for OEM).
  - Use VLAN for isolation.
  - Note: ILOM management is handled separately (e.g., subnet 10.0.2.0/24).
- **Example IPs**:
  - Physical Server 1 (Dom0): 10.0.1.1
  - VM 1 on Server 1: 10.0.1.10
  - VM 2 on Server 1: 10.0.1.11
  - Physical Server 2 (Dom0): 10.0.1.2
  - VM 1 on Server 2: 10.0.1.12

## Client Network
- **Purpose**: Enables client applications to connect to the database and supports DBA access.
- **Type**: Ethernet (10/25/100 GbE).
- **Subnet**: 10.0.0.0/24 (example).
- **Configuration**:
  - Assign public IPs for each VM’s database interface.
  - Configure 3 SCAN IPs in DNS for Oracle RAC.
  - Open port 1521 for SQL*Net.
  - Enable jumbo frames (MTU 9000).
- **Example IPs**:
  - VM 1: 10.0.0.1
  - VM 2: 10.0.0.2
  - SCAN IPs: 10.0.0.10, 10.0.0.11, 10.0.0.12

## Private Network
- **Purpose**: Handles RAC interconnect, storage I/O, and backups via InfiniBand.
- **Type**: InfiniBand (40/100/200 Gb/s) or RoCE.
- **Subnet**: 192.168.10.0/24 (private, non-routable).
- **Configuration**:
  - Assign private IPs for VMs and storage servers.
  - Configure bonded InfiniBand interfaces (`bondib0`).
  - Enable jumbo frames (MTU 9000).
- **Example IPs**:
  - VM 1: 192.168.10.1
  - VM 2: 192.168.10.2
  - Storage Server 1: 192.168.10.3

## Virtual Network
- **Purpose**: Provides VIPs for Oracle RAC failover and load balancing.
- **Type**: Ethernet (same as Client Network).
- **Subnet**: 10.0.0.0/24 (example).
- **Configuration**:
  - Assign VIPs for each VM.
  - Configure in Oracle Grid Infrastructure via OEDA.
  - Ensure DNS resolves VIP and SCAN hostnames.
- **Example IPs**:
  - VM 1 VIP: 10.0.0.101
  - VM 2 VIP: 10.0.0.102
  - SCAN IPs: 10.0.0.10, 10.0.0.11, 10.0.0.12

## Provisioning Notes
- Use **OEDA** to automate network configuration.
- Validate connectivity using `crsctl`, `srvctl`, and `ibdiagnet`.
- Secure Admin and Private networks with VLANs or firewalls.