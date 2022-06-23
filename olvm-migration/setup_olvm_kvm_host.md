# OLVM and KVM Install and Configuration

## Table of Contents

1. [Installing the engine](#engine)
2. [Installing a KVM host](#kvm)

## Installing the engine <a href="" name="engine"></a>

- install the requirement packages
  ```
  yum install oracle-ovirt-release-el7 -y
  ```
- Clear yum cacche
  ```
  yum clean all
  ```
- List the configured repositories
  ```
  yum repolist
  ```
- if a required repository is not enabled, use the dnf config-manager to enable it
  ```
  yum-config-manager --enable ol7_latest
  ```
- Next install the ovirt-engine packages
  ```
  yum install ovirt-engine -y
  ```
- Next we can set up the ovirt-engine set running:

  ```
   ovirt-engine --accept-defaults
  ```

## Installing a KVM host <a href="" name="kvm"></a>

- install the requirement packages
  ```
  yum install oracle-ovirt-release-el7 -y
  ```
- Clear yum cacche
  ```
  yum clean all
  ```
- List the configured repositories
  ```
  yum repolist
  ```
- if a required repository is not enabled, use the dnf config-manager to enable it
  ```
  yum-config-manager --enable ol7_latest
  ```
