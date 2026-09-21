# 🗺️ Segmented Network Design

```mermaid
graph TD
    A[Internet] --> B[pfSense/OPNsense]
    B --> C[DMZ VLAN]
    B --> D[Management VLAN]
    B --> E[IoT/Guest VLAN]
    B --> F[Internal Servers VLAN]
    C --> G[Public-facing test services]
    E --> H[Untrusted IoT devices]
```

## Threat Model
- DMZ isolated from internal VLANs — assumed compromised
- IoT/Guest fully isolated from Management and Servers
- All inter-VLAN traffic logged and inspected via IDS
