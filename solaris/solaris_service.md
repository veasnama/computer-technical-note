# Listing Services on the System

## Listing Services on the System

- the svcs command lists all service instances that are enabled on this system, as well as instances that are temporarily disabled.

```
$ svcs
STATE          STIME    FMRI
legacy_run     Sep_09   lrc:/etc/rc2_d/S47pppd
legacy_run     Sep_09   lrc:/etc/rc2_d/S81dodatadm_udaplt
legacy_run     Sep_09   lrc:/etc/rc2_d/S89PRESERVE
disabled       Sep_09   svc:/system/vbiosd:default
online         Sep_09   svc:/system/early-manifest-import:default
online         Sep_09   svc:/system/svc/restarter:default
```

- Listing All Installed Services

```
svcs -a
```

- An asterisk (_) is appended to the state for service instances that are transitioning from the listed state to another state. For example, offline_ probably means the instance is still executing its start method.
- A question mark (?) is displayed if the state is absent or unrecognized.
- Listing All Instances of a Service
- With a service name specified, the svcs command lists all instances of a service.

```
svcs -Ho inst identity
```

## Showing More Information About Services

- The svcs -l command shows a long listing for each specified service instance including more detailed information about the instance state, paths to the log file and configuration files for the instance, dependency types, dependency restart attribute values, and dependency state. The following example shows that all of the required dependencies of this service instance are online. The one dependency that is disabled is an optional dependency. For information about dependency types and restart attribute values, see Showing Service Dependencies. In svcs -l output, states other than those described in Service States are possible for dependencies. See the svcs(1) man page for descriptions. The following example also shows that the specified service instance is temporarily enabled, is online, and the service is a contract type service. See Service Models for definitions of service types. If the state value has a trailing asterisk, for example offline\*, then the instance is in transition, and the next state field shows a state value instead of none. The state_time is the time the instance entered the listed state.

```
$ svcs -l net-snmp
fmri         svc:/application/management/net-snmp:default
name         net-snmp SNMP daemon
enabled      true (temporary)
state        online
next_state   none
state_time   September 17, 2013 05:57:26 PM PDT
logfile      /var/svc/log/application-management-net-snmp:default.log
restarter    svc:/system/svc/restarter:default
contract_id  160
manifest     /etc/svc/profile/generic.xml
manifest     /lib/svc/manifest/application/management/net-snmp.xml
dependency   require_all/none svc:/system/filesystem/local (online)
dependency   optional_all/none svc:/milestone/name-services (online)
dependency   optional_all/none svc:/system/system-log (online)
dependency   optional_all/none svc:/network/rpc/rstat (disabled)
dependency   require_all/restart svc:/system/cryptosvc (online)
dependency   require_all/restart svc:/milestone/network (online)
dependency   require_all/refresh file://localhost/etc/net-snmp/snmp/snmpd.conf (online)
dependency   require_all/none svc:/milestone/multi-user (online)
```

- Showing Processes Started by a Contract Service
- Use the svcs -p command to show the process IDs and command names of processes started by a contract service instance. The net-snmp service manages the /usr/sbin/snmpd SNMP agent that collects information about a system through a set of Management Information Bases (MIBs

```
$ svcs -p net-snmp
STATE          STIME    FMRI
online         17:57:26 svc:/application/management/net-snmp:default
               17:57:26     5022 snmpd
```

- Showing a Contract Service Restarting Automatically After Process Stop

```
$ kill 5022
$ svcs -p net-snmp
STATE          STIME    FMRI
online         17:57:59 svc:/application/management/net-snmp:default
               17:57:59     5037 snmpd
```

- Showing Selected Service Information
- Output from the svcs command can be very useful for piping to other commands or using in scripts. The -o option of the svcs command enables you to specify the columns of information you want and the order of the columns. You can output the service name and instance name in separate columns, the current state and next state of the service, and the contract ID
