# Setting Thresholds for Exadata KPIs in Oracle Enterprise Manager

This guide explains how to set thresholds for the eight Key Performance Indicators (KPIs) in Oracle Enterprise Manager (OEM) for Exadata Database Machine, as outlined in the *Exadata Health and Resource Utilization Monitoring* white paper (Version 3.2, Oracle, 2022) from [https://www.oracle.com/docs/tech/database/exadata-database-machine-kpis.pdf](https://www.oracle.com/docs/tech/database/exadata-database-machine-kpis.pdf). It covers configuring thresholds for Exadata Storage Server KPIs, ensuring the derived I/O Health metrics function, and monitoring high-utilization processes in a Linux/Exadata environment.

## Overview of Exadata KPIs

The white paper lists eight KPIs for Exadata Storage Servers, monitored at both individual Storage Server and Storage Server Grid levels:

1. **Total Flash Disk IOPS**: Aggregated read and write IOPS for flash disks.
2. **Total Hard Disk IOPS**: Aggregated read and write IOPS for hard disks.
3. **Total Flash Disk Throughput (MB/s)**: Aggregated read and write throughput for flash disks.
4. **Total Hard Disk Throughput (MB/s)**: Aggregated read and write throughput for hard disks.
5. **Average Flash Disk Response Time (ms/request)**: Average read and write latency for flash disks.
6. **Average Hard Disk Response Time (ms/request)**: Average read and write latency for hard disks.
7. **Average Flash Disk IO Load**: Average disk queue length for flash disks.
8. **Average Hard Disk IO Load**: Average disk queue length for hard disks.

The derived metrics, **Exadata Storage Server FlashDisk I/O Health** and **Exadata Storage Server HardDisk I/O Health**, trigger alerts when multiple KPIs exceed their thresholds.

## Prerequisites

- **OEM Version**: Oracle Enterprise Manager Cloud Control 13c Release 4 Update 4 (13.4.0.4) or higher, supporting Exadata KPIs as first-class metrics.
- **Exadata Plug-in**: Installed on all Exadata database servers for Storage Server and Grid monitoring.
- **Privileges**: *Manage Target Metrics* or higher in OEM.
- **Exadata Targets**: Discovered Storage Servers and Grid in OEM (see *Oracle Exadata Database Machine Getting Started Guide*).

## Steps to Set Thresholds in OEM

### 1. Access Metric and Collection Settings
1. **Navigate to Exadata Target**:
   - Log in to OEM Cloud Control.
   - Go to **Targets** > **Exadata**.
   - Select an Exadata Database Machine from the *Oracle Exadata Database Machines* page.
   - In the **Target Navigation tree**, choose an **Exadata Storage Server** (individual metrics) or **Exadata Storage Server Grid** (aggregated metrics).

2. **Go to Metric Settings**:
   - From the target’s home page, select **Monitoring** > **Metric and Collection Settings**.

### 2. Locate the KPIs
1. **Find KPIs**:
   - In *Metric and Collection Settings*, expand the **Aggregated Exadata FlashDisk and HardDisk Metric** category to view the eight KPIs (e.g., `Total Flash Disk IOPS`).
   - In OEM 13.4+, KPIs are first-class metrics under *Key Performance Indicators Metrics*.

2. **Check for Metric Extensions** (Older OEM Versions):
   - For OEM 12c, KPIs may require metric extensions.
   - Go to **Enterprise** > **Monitoring** > **Metric Extensions**.
   - Verify or create extensions for KPIs or I/O Health metrics (e.g., `Exadata Storage Server HardDisk I/O Health`).

### 3. Set Thresholds for Each KPI
1. **Select a KPI**:
   - Locate a KPI (e.g., `Average Flash Disk Response Time`) and click the pencil/edit icon.

2. **Define Thresholds**:
   - Set **Warning** and **Critical** thresholds based on workload. Suggested values:
     - **Total Flash Disk IOPS**:
       - Warning: 50,000 IOPS
       - Critical: 70,000 IOPS
     - **Total Hard Disk IOPS**:
       - Warning: 1,000 IOPS
       - Critical: 2,000 IOPS
     - **Total Flash Disk Throughput (MB/s)**:
       - Warning: 800 MB/s
       - Critical: 1,200 MB/s
     - **Total Hard Disk Throughput (MB/s)**:
       - Warning: 150 MB/s per disk
       - Critical: 200 MB/s per disk
     - **Average Flash Disk Response Time (ms/request)**:
       - Warning: 2 ms
       - Critical: 5 ms
     - **Average Hard Disk Response Time (ms/request)**:
       - Warning: 15 ms
       - Critical: 20 ms
     - **Average Flash Disk IO Load**:
       - Warning: 50
       - Critical: 100
     - **Average Hard Disk IO Load**:
       - Warning: 50
       - Critical: 100

3. **Set Number of Occurrences**:
   - Set to 6 occurrences (e.g., 30 minutes with 5-minute collection intervals) to avoid false alerts from transient spikes.

4. **Save Changes**:
   - Click **OK** to save to the OEM repository. Repeat for all eight KPIs.

### 4. Configure I/O Health Metrics
- **Purpose**: `Exadata Storage Server FlashDisk I/O Health` and `Exadata Storage Server HardDisk I/O Health` trigger based on the number of KPIs exceeding thresholds.
- **Steps**:
  1. Locate these metrics in *Metric and Collection Settings*.
  2. Set thresholds, e.g.:
     - Warning: 2 KPIs exceeded
     - Critical: 4 KPIs exceeded
  3. Save changes.

### 5. Enable Adaptive Thresholds (Optional)
- **Purpose**: Adjust thresholds dynamically for varying workloads (e.g., OLTP vs. batch).
- **Steps**:
  1. In *Metric and Collection Settings*, click **Advanced Threshold Management**.
  2. Select **Moving Window** and define a baseline (e.g., trailing 7 days).
  3. Register KPIs (e.g., `Average Flash Disk Response Time`) as adaptive metrics.
  4. Set **Threshold Change Frequency** (e.g., daily) and save.

### 6. Configure Notifications
1. Go to **Setup** > **Incidents** > **Notification Methods**.
2. Configure a method (e.g., email to `admin@example.com`, SNMP traps).
3. Create an **Incident Rule**:
   - Go to **Setup** > **Incidents** > **Incident Rules**.
   - Create a rule for KPI metric alerts (e.g., `Average Hard Disk Response Time > 20 ms`).
   - Assign the notification method and save.
4. Alerts appear in *Incident Manager* or *Services Performance/Incidents*.

### 7. Verify Thresholds
- Check thresholds in **Monitoring** > **All Metrics** for the target.
- Monitor *Incident Manager* for alerts.
- Cross-check with `CellCLI`:
  ```bash
  CellCLI> LIST METRICCURRENT WHERE OBJECTTYPE = 'CELLDISK' ATTRIBUTES name, metricValue
  ```

## Monitoring High-Utilization Processes

OEM configuration may increase I/O or CPU load in an Exadata environment. Monitor to avoid impacting `cellsrv`:

- **CPU Usage**:
  ```bash
  top
  ```
  or
  ```bash
  ps -eo pid,cmd,%cpu --sort=-%cpu | head -n 6
  ```
  - Watch for `emagent` or `cellsrv` spikes.

- **I/O Load**:
  ```bash
  sudo iotop
  ```
  - Check for high I/O correlating with `Average Hard Disk IO Load`.

- **Mitigation**:
  - Schedule updates during low-load periods, especially during RMAN operations (`DELETE NOPROMPT BACKUP`).
  - Lower OEM agent priority:
    ```bash
    nice -n 10 emctl start agent
    ```
  - Check IORM:
    ```bash
    CellCLI> LIST IORMPLAN DETAIL
    ```

## Considerations

- **Workload-Specific Thresholds**: Adjust for OLTP (high IOPS) vs. data warehousing (high throughput).
- **I/O Health Metrics**: Require thresholds on all eight KPIs to function.
- **Adaptive Thresholds**: Use for dynamic workloads to reduce false alerts.
- **Permissions**: Ensure *Manage Target Metrics* privileges.
- **RMAN Context**: Monitor `Total Hard Disk Throughput` during OEM setup to avoid contention with RMAN.

## Example Threshold Configuration

For an Exadata Storage Server Grid:
1. Set `Average Flash Disk Response Time`: Warning 2 ms, Critical 5 ms, Occurrences 6.
2. Set `Average Hard Disk IO Load`: Warning 50, Critical 100, Occurrences 6.
3. Set `Exadata Storage Server FlashDisk I/O Health`: Warning 2 KPIs, Critical 4 KPIs.

## Verification

- Check alerts in *Incident Manager* after a workload (e.g., 2-hour test).
- Validate with `CellCLI`:
  ```bash
  CellCLI> LIST METRICCURRENT CD_IO_RQ_R_SM_SEC
  ```
- Adjust thresholds if no alerts trigger.

## References

- Oracle White Paper: *Exadata Health and Resource Utilization Monitoring* (Version 3.2, 2022).
- Oracle Enterprise Manager Cloud Control documentation for metric thresholds.

*Generated on May 21, 2025, based on user query about Exadata KPI thresholds and prior Linux/Exadata context.*