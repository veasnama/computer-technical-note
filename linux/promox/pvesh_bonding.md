# Proxmox `pvesh` Network Configuration Guide

## Why `/nodes/$NODE/network`?

The path `/nodes/$NODE/network` is a **REST API URL namespace**, not a filesystem path.
Proxmox's API daemon (`pvedaemon`) exposes every cluster resource as a REST tree:

```
/nodes/{node}/network          — list / create interfaces
/nodes/{node}/network/{iface}  — read / update / delete one interface
/nodes/{node}/network          — PUT with no iface = apply pending config
```

When you call `pvesh create /nodes/pve/network ...`, what happens under the hood:

1. `pvedaemon` validates your parameters against its schema
2. It writes the result into `/etc/network/interfaces.new` (a staging file)
3. When you call `pvesh set /nodes/$NODE/network` (the apply step), it runs `ifreload -a`
   which reads the file and instructs the kernel

The REST path is just an abstraction layer — the real work happens through the same
`/etc/network/interfaces` file that standard Debian networking uses.

---

## Is there a conflict with the OS?

**No** — and this is intentional. Proxmox eliminates conflict at installation time by
**disabling and masking** the two services that would otherwise fight over network config:

```bash
# Both are masked (not just disabled) on a fresh Proxmox install:
systemctl status systemd-networkd   # → masked
systemctl status NetworkManager     # → masked (or not installed)

# Verify:
systemctl is-enabled systemd-networkd   # → masked
systemctl is-enabled NetworkManager     # → masked or not-found
```

Proxmox uses **`ifupdown2`** as the sole networking manager — the same Debian-style
`/etc/network/interfaces` toolchain that `pvedaemon` writes to. There is only ever
one writer and one reader of that file.

---

## The Staging Model — `interfaces.new`

When you make changes in the WebUI or via `pvesh`, they don't go live immediately:

```
/etc/network/interfaces      — currently active config (what the kernel has)
/etc/network/interfaces.new  — pending/staged changes (not yet applied)
```

- **Revert** button → deletes `interfaces.new`
- **Apply Configuration** → runs `ifreload -a`, atomically replaces active config

This means:
- Multiple changes can be made without breaking connectivity mid-edit
- A reboot always falls back to the last applied `interfaces` file
- The API and WebUI are always in sync via the shared staging file

---

## Full `pvesh` Command Reference

### Create the Bond

```bash
NODE="pve"   # replace with your node name

pvesh create /nodes/$NODE/network \
  --iface bond0 \
  --type bond \
  --bond_mode active-backup \
  --bond-primary nic6 \
  --bond_miimon 100 \
  --slaves "nic6 nic7" \
  --autostart 1 \
  --comments "uplink bond — active-backup"
```

### Create vmbr0 (management bridge, VLAN-aware, with IP)

```bash
pvesh create /nodes/$NODE/network \
  --iface vmbr0 \
  --type bridge \
  --bridge_ports bond0 \
  --bridge_vlan_aware 1 \
  --bridge_vids "2-4094" \
  --cidr "192.168.1.1/24" \
  --gateway "192.168.1.254" \
  --autostart 1 \
  --comments "management VLAN-aware bridge"
```

### Create vmbr1 (VM bridge, restricted VLAN range, no IP)

```bash
pvesh create /nodes/$NODE/network \
  --iface vmbr1 \
  --type bridge \
  --bridge_ports bond0 \
  --bridge_vlan_aware 1 \
  --bridge_vids "100-200" \
  --autostart 1 \
  --comments "VM trunk bridge VLANs 100-200"
```

### Apply the Pending Config

```bash
pvesh set /nodes/$NODE/network
```

### Modify an Existing Interface

```bash
# Change VLAN range on vmbr1
pvesh set /nodes/$NODE/network/vmbr1 \
  --bridge_vids "100-300"

pvesh set /nodes/$NODE/network   # apply
```

### Delete an Interface

```bash
pvesh delete /nodes/$NODE/network/vmbr1
pvesh set /nodes/$NODE/network   # apply
```

---

## Proxmox API Parameter Reference

| WebUI / `pvesh` param    | Raw `interfaces` stanza   | Notes                     |
|--------------------------|---------------------------|---------------------------|
| `--type bond`            | `bond-mode ...`           | WebUI shows bond picker   |
| `--bond_mode active-backup` | `bond-mode active-backup` |                        |
| `--bond_miimon 100`      | `bond-miimon 100`         |                           |
| `--slaves "nic6 nic7"`   | `bond-slaves nic6 nic7`   | Space-separated string    |
| `--type bridge`          | `bridge-ports ...`        | WebUI shows bridge type   |
| `--bridge_ports bond0`   | `bridge-ports bond0`      |                           |
| `--bridge_vlan_aware 1`  | `bridge-vlan-aware yes`   | Boolean as int in API     |
| `--bridge_vids "10-30"`  | `bridge-vids 10-30`       | Ranges and lists both work|
| `--cidr`                 | `address` + mask          | WebUI uses CIDR notation  |

---

## What You Should Never Do on Proxmox

| Action | Result |
|--------|--------|
| Manually edit `/etc/network/interfaces` | Works, but WebUI may overwrite on next apply |
| Run `nmcli` or `nmtui` | NetworkManager is masked — commands will fail |
| Enable `systemd-networkd` | Will fight `ifupdown2` — breaks networking |
| Use `ip link` / `ip addr` for permanent changes | Temporary only — lost on reboot or `ifreload` |
| Edit `/etc/network/interfaces.new` manually | Unsafe — API may overwrite between edit and apply |

---

## Safe Manual Edit Workflow

If you need to hand-edit the interfaces file directly:

```bash
# 1. Make your edit
nano /etc/network/interfaces

# 2. Validate (dry run)
ifreload -a --dry-run

# 3. Apply
ifreload -a

# 4. Reload the Network tab in WebUI — it re-reads the file on page load
```

---

## Architecture Summary

```
Consumers (WebUI / pvesh / Terraform / REST)
          │
          ▼
  pvedaemon / pveproxy
  (validates, stages to interfaces.new)
          │
          ▼
  /etc/network/interfaces   ← single source of truth
          │
          ▼
      ifupdown2  ──►  Linux kernel (bridge / bonding / vlan modules)
          │
          ▼
  Physical NICs: nic6, nic7 → bond0 → vmbr0 / vmbr1

  systemd-networkd / NetworkManager → MASKED (no conflict)
```
