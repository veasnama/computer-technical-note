```
# licenseport --show
# switchshow
# sfpshow port_number
# portdisable
# portenable
# showport


- create alias and zoning

alicreate "port_init","21:00:00:24:ff:59:36:48"
alicreate "port_target","21:00:00:24:ff:59:36:49"
zonecreate "ZONE1", "port_init;port_target"
cfgcreate "new_cfg", "ZONE1"
cfgenable new_cfg

- delete
aliasdelete alias_name
zonedelete zone_name
cfgdisable
cfgdelete new_cfg
cfgsave
```

- Note that in SAN Switch can have multiple zonesets but only one of them can activate at a time.
