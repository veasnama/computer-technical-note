> ##  How to backup and store oracle linux visualization Manager in oracle linux 7.9, 8.6, 9.0 Unbreakable Enterprise Kernel

- Usage and Argument Summary 
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
1. Take a full backup of both database file and its logs


```
# engine-backup --mode=backup --scope=all --file=/enginebackups/enginebackup200419 --log=/enginebackup200419.log
```

2. Before restoring from a backup make sure to cleanup the engine and reinstall

- Clean up the existing engine setup
```
# engine-cleanup --long=FILE
```
- where FILE -> the path and filename for the cleanup logs

- Uninstall ovirt-engine package
```
# yum remove ovirt-engine
```
3. Using ovirt-provide-ovn requires the below additional steps to reset the certificate authority (CA) file. If ovirt-provider-ovn is not used then skip this step
```
# systemctl restart ovn-northd.service
# ovn-sbctl del-ssl
```
4. Reinstall ovirt-engine package
```
# yum install ovirt-engine
```
5. Restore the engine from backup
```
# engine-backup --mode=restore --file=FILE --log=FILE --restore-permissions
```
```
Usage:

--mode=MODE
where MODE -> for collecting backup it should be set to "restore"

--file=FILE
where FILE -> the path and filename for the backup file from which to restore

--log=FILE
where FILE -> the path and filename for the restore logs

--restore-permissions
Either --no-restore-permissions or --restore-permissions option is required when the backup is a custom dump
```

6. Then run below command to setup the engine
```
# engine-setup
```