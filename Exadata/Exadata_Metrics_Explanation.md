# Exadata Health and Resource Utilization Monitoring Metrics

This document explains the key performance indicators (KPIs) from the *Exadata Health and Resource Utilization Monitoring* document (Version 3.2, Oracle, 2022) for Oracle Exadata Storage Servers. It covers IOPS, I/O, flash disk, hard disk, and PMEM, with context on monitoring high-utilization processes in Linux and RMAN backup deletion considerations.

## Key Terms Explained

### IOPS (Input/Output Operations Per Second)
- **Definition**: Measures the number of read and write operations a storage device (flash or hard disk) performs per second. Critical for transactional workloads (e.g., OLTP) with many small, random I/O operations.
- **Exadata Context**: Reported as `Total Flash Disk IOPS` and `Total Hard Disk IOPS`. Flash disks deliver up to 75,000 IOPS per cell, while hard disks provide a few hundred IOPS per disk.
- **Significance**: High IOPS indicates efficient workload handling. Low IOPS with high latency may signal bottlenecks, requiring process investigation.

### I/O (Input/Output)
- **Definition**: Data transfer operations (reads and writes) between the database and storage. Exadata categorizes I/O as small (≤128 KB) or large (>128 KB).
- **Exadata Context**: Metrics like `CD_IO_BY_R_SM` (small reads in MB) or `CD_IO_RQ_R_LG_SEC` (large read requests/sec) track I/O. `CD_IO_LOAD` measures disk queue length.
- **Significance**: High I/O load with long queues indicates system overload, often tied to high-utilization processes like `cellsrv`.

### Flash Disk
- **Definition**: Solid-state drives (SSDs) using flash memory, part of Exadata Smart Flash Cache, for low-latency, high-IOPS access.
- **Exadata Context**: Metrics include `Total Flash Disk IOPS`, `Total Flash Disk Throughput`, `Average Flash Disk Response Time`, and `Average Flash Disk IO Load`. Example: `DB_FC_IO_BY_SEC` tracks flash cache I/O for a database.
- **Performance**: Sub-millisecond latency, up to 75,000 IOPS per cell, ideal for OLTP workloads.

### Hard Disk
- **Definition**: Mechanical spinning drives (HDDs) for bulk storage, suited for data warehousing with large sequential I/O.
- **Exadata Context**: Metrics include `Total Hard Disk IOPS`, `Total Hard Disk Throughput`, `Average Hard Disk Response Time`, and `Average Hard Disk IO Load`. Example: `CD_IO_BY_R_LG` measures large block reads.
- **Performance**: Higher latency (5-10 ms), lower IOPS (a few hundred per disk), cost-effective for large data.

### PMEM (Persistent Memory)
- **Definition**: Non-volatile memory (Intel Optane in Exadata X8M/X9M) between DRAM and flash, offering near-DRAM speeds (3x slower than DRAM, 600x faster than flash SSDs).
- **Exadata Context**:
  - **PMEMCache**: Caches frequent data for low-latency reads (≤19µs via RDMA), tracked in AWR reports (e.g., `cell RDMA reads`).
  - **PMEMLog**: Speeds up redo log writes, replicated for resiliency.
- **Significance**: Reduces flash I/O, but not directly captured in cell-level KPIs.

## Exadata KPIs Explained

The eight KPIs monitor storage health at individual cell and grid levels:

1. **Total Flash Disk IOPS**
   - Aggregates read/write IOPS across flash disks (`CD_IO_RQ_R_SM_SEC` + `CD_IO_RQ_R_LG_SEC` + `CD_IO_RQ_W_SM_SEC` + `CD_IO_RQ_W_LG_SEC`).
   - High IOPS (e.g., 50,000) indicates heavy workload; low IOPS (<20,000) suggests underutilization.
   - **Process Impact**: High IOPS may spike `cellsrv` CPU usage (check with `top`).

2. **Total Hard Disk IOPS**
   - Aggregates read/write IOPS across hard disks. Lower capacity than flash (e.g., a few hundred IOPS per disk).
   - High IOPS with high I/O load suggests contention.
   - **Process Impact**: May increase `cellsrv` CPU or I/O wait (check with `ps -eo pid,cmd,%cpu --sort=-%cpu | head`).

3. **Total Flash Disk Throughput (MB/s)**
   - Total megabytes read/written per second (`CD_IO_BY_R_SM_SEC` + `CD_IO_BY_R_LG_SEC` + `CD_IO_BY_W_SM_SEC` + `CD_IO_BY_W_LG_SEC`).
   - High throughput (e.g., 1 GB/s per cell) is common for data warehousing.
   - **Process Impact**: Strains `cellsrv` or network; monitor with `top`.

4. **Total Hard Disk Throughput (MB/s)**
   - Measures read/write megabytes per second for hard disks.
   - High throughput (e.g., 200 MB/s per disk) for sequential I/O; low throughput with high I/O load indicates contention.
   - **Process Impact**: Similar to flash, monitor `cellsrv` with `iotop`.

5. **Average Flash Disk Response Time (ms/request)**
   - Average latency for flash disk I/O (`CD_IO_ST_RQ`). Typically sub-millisecond.
   - High latency (>5 ms) suggests bottlenecks; check AWR for `cell single block physical read` waits.
   - **Process Impact**: High latency may correlate with `cellsrv` CPU spikes (use `ps -eo pid,cmd,%cpu --sort=-%cpu | head`).

6. **Average Hard Disk Response Time (ms/request)**
   - Average latency for hard disk I/O (5-10 ms typical).
   - High latency (>20 ms) indicates issues; compare with `DB_IO_LOAD`.
   - **Process Impact**: Increases `cellsrv` I/O wait; monitor with `iostat`.

7. **Average Flash Disk IO Load**
   - Average disk queue length (`CD_IO_LOAD`) for flash disks.
   - Low load (<20) indicates underutilization; high load (>100) suggests bottlenecks.
   - **Process Impact**: High load may spike `cellsrv` memory (check `ps -eo pid,cmd,%mem --sort=-%mem | head`).

8. **Average Hard Disk IO Load**
   - Average disk queue length for hard disks, with large I/Os weighted 3x.
   - High load (>100) indicates contention; check `CT_IO_LOAD` or `CG_IO_LOAD`.
   - **Process Impact**: Strains `cellsrv`; monitor with `iotop`.

## Monitoring High-Utilization Processes in Exadata

- **Key Process**: `cellsrv` handles I/O operations and may consume high CPU/memory during heavy IOPS or throughput.
- **Commands**:
  - CPU: `top` or `ps -eo pid,cmd,%cpu --sort=-%cpu | head -n 6`
  - Memory: `ps -eo pid,cmd,%mem --sort=-%mem | head -n 6`
  - I/O: `iotop` (if installed).
- **Mitigation**:
  - Check IORM settings (`LIST IORMPLAN`).
  - Use `nice` or `kill <PID>` for non-critical processes.
  - Restart `cellsrv` for memory alerts (contact Oracle Support).

## Exadata-Specific Considerations

- **CellCLI**: Query metrics with `LIST METRICCURRENT WHERE OBJECTTYPE = 'CELLDISK' ATTRIBUTES name, metricValue`.
- **PMEM**: Reduces flash I/O via RDMA; check AWR for `cell RDMA reads`.
- **Grid vs. Individual**: Grid-level KPIs assess overall capacity; cell-level pinpoints bottlenecks.
- **Alerts**: Set thresholds in Oracle Enterprise Manager (e.g., response time >20 ms).
- **RMAN Impact**: Backups/deletions increase hard disk throughput and I/O load; monitor `cellsrv` during `DELETE NOPROMPT BACKUP`.

## Practical Example

High `Total Flash Disk IOPS` (50,000), `Average Flash Disk Response Time` (5 ms), and `Average Flash Disk IO Load` (80) with `cellsrv` at 85% CPU suggest a bottleneck:
1. Run `LIST METRICCURRENT DB_FC_IO_BY_SEC` to identify the database.
2. Check IORM: `LIST IORMPLAN DETAIL`.
3. Verify `cellsrv` load: `ps -eo pid,cmd,%cpu | grep cellsrv`.
4. Check PMEM usage in AWR for `cell RDMA reads`.

---

*Generated on May 21, 2025, based on user query about Exadata metrics and prior RMAN backup context.*