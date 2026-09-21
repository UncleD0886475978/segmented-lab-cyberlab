# Firewall Rule Set

| Rule | Source | Destination | Action | Notes |
|---|---|---|---|---|
| Block DMZ→Internal | DMZ | Internal VLANs | Deny | Assume DMZ compromised |
| Block IoT→Mgmt | IoT VLAN | Mgmt VLAN | Deny | Untrusted device isolation |
| Allow Mgmt→All | Mgmt VLAN | Any | Allow | Admin access |
| Default Deny | Any | Any | Deny | Explicit allow only |
