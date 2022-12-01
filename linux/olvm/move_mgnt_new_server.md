# Goal
  - How to migrate OLVM from one server to another 

# Applied to 
  - oracle linux 7.9 or later
  - OLVM ( Oracle Linux Virtualization Manager)

# Recommendation 
  - New KVM Manager should use : 
    - the same IP and hostname as the exsiting one

# Solution
## Backup
  - Use the engine-backup command to create a backup
  - The usage and mandatory arguments with the command are listed below
```
--mode=MODE
where MODE -> for collecting backup it should be set to "backup"

--scope=SCOPE
where SCOPE -> can be set to "all" or "files" or "db" or "dwhdb"
if set to "all" everything below will be collected
if set to "files" product files only will be collected
if set to "db" Engine database only will be collected
if set to "dwhdb" Data Warehouse database only will be collected
The option --scope can be passed more than once, with different scopes.

--file=FILE
where FILE -> the path and filename for the backup

--log=FILE
where FILE -> the path and filename for the backup logs

```
- For more options run
```
# engie-setup --help
```
- Example
```
# engine-backup --mode=backup --scope=all --file=/enginebackups/enginebackup200419 --log=/enginebackup200419.log
Backing up:
Notifying engine
- Files
- Engine database 'engine'
- DWH database 'ovirt_engine_history'
Packing into file '/enginebackups/enginebackup200419'
Notifying engine
Done.

```
## Restore

- 
Copyright (c) 2022, Oracle. All rights reserved. Oracle Confidential.


Click to add to Favorites		OLVM: Backup And Restore The Oracle Linux Virtualization Manager Engine (Doc ID 2532928.1)	To BottomTo Bottom	

In this Document
Goal
Solution
 	Backup
 	Restore
References
APPLIES TO:
Linux OS - Version Oracle Linux 7.6 with Unbreakable Enterprise Kernel [4.14.35] and later
Linux x86-64
GOAL
Backup and restore the Oracle Linux Virtualization Manager Engine (OLVM).

SOLUTION
Backup
Use the engine-backup command to create a backup.

The usage and mandatory arguments with the command are listed below:

--mode=MODE
where MODE -> for collecting backup it should be set to "backup"

--scope=SCOPE
where SCOPE -> can be set to "all" or "files" or "db" or "dwhdb"
if set to "all" everything below will be collected
if set to "files" product files only will be collected
if set to "db" Engine database only will be collected
if set to "dwhdb" Data Warehouse database only will be collected
The option --scope can be passed more than once, with different scopes.

--file=FILE
where FILE -> the path and filename for the backup

--log=FILE
where FILE -> the path and filename for the backup logs

For more options run:

# engine-backup --help
Example:

# engine-backup --mode=backup --scope=all --file=/enginebackups/enginebackup200419 --log=/enginebackup200419.log
Backing up:
Notifying engine
- Files
- Engine database 'engine'
- DWH database 'ovirt_engine_history'
Packing into file '/enginebackups/enginebackup200419'
Notifying engine
Done.
 

## Restore
- Before restoring from a backup make sure to cleanup the engine and reinstall
- Make sure Oracle Linux OS is installed on Destination Server as a pre-requisite.
- Install required packages
```
# yum install oracle-ovirt-release-el7
# yum install ovirt-engine
```
- Restore complete backup with following command
```
# engine-backup --mode=restore --file=<file_name> --log=<log_file_name> --provision-all-databases
```
- Run below command to setup the engine
```
# engine-setup
```
