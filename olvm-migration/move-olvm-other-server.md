# How to migrate Standalone OLVM from one server to another

# Table of Contents

1. [Goal](#goal)
2. [Solution](#solution)
   1. [Take the engine in Source Server](#step1)
   2. [Restore in Destination Server](#step2)
3. [References](#ref)

## Goal <a  name="goal"></a>

Migrate/Move Standalone Oracle Linux Virtualization Manager (OLVM) from one Server to another

## Solution <a href="" name="solution"></a>

### Take Engine Backup in Source Server <a name="step1"></a>

- Please follow the below steps:

```
# engine-backup --scope=all --mode=backup --file=<file_name> --log=<log_file_name>
```

- Copy engine backup file to destination server
- Stop source Server

### Restore in Destination Server <a name="step2"></a>

- Please follow the below steps:
- Make sure Oracle Linux OS is installed on Destination Server
- install required packages

```
# yum install oracle-ovirt-release-el7
# yum install ovirt-engine
```

- Restore complete backup with the following

```
# engine-backup --mode=restore --file=<file_name> --log=<log_file_name> --provision-all-databases
```

- Run below command to setup the engine:

```
# engine-setup
```

## Refernces <a href="" name="ref"></a>

- [Backup_Retore_in_OLVM](https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=341613565403975&id=2532928.1)

```
#include<iostream>
#include<string>
int main(int argc, char** args)
{
    string name= "John"
    std::cout << name << std::endl;
}
```
