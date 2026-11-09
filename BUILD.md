# segmented-lab-cyberlab — BUILD

## One-line install (fresh Ubuntu/Debian VM)

```bash
curl -fsSL https://raw.githubusercontent.com/UncleD0886475978/segmented-lab-cyberlab/main/setup.sh | bash
```

The script installs its own prerequisites — base tools only (git and curl, plus ca-certificates/gnupg if missing) via apt — then clones or updates the repo and verifies/opens the docs. It is docs-only: the lab platforms the docs describe (pfSense/OPNsense, Proxmox, Suricata/Snort/Zeek) are NOT installed, only presence-checked. The original script never invoked Docker or kubectl, so neither is bootstrapped. On non-apt platforms it falls back to checking for git and printing install guidance.

Alternative (clone and run):

```bash
git clone https://github.com/UncleD0886475978/segmented-lab-cyberlab.git
cd segmented-lab-cyberlab
./setup.sh
```

- Repo: UncleD0886475978/segmented-lab-cyberlab
- Visibility/fork: public (per sweep brief); not a fork noted
- Docs-only: YES
- Stack/content actually found (GitHub API root listing, 2026-11-09): `README.md` (1,520 B), `ids/`, `network-design/`, `pfsense-opnsense/`, `scenarios/`. No scripts, code, manifests, or compose files at root. Deeper README/subdir reads were cut off by a GitHub API HTTP 429 rate-limit — noted here; listing above is the verified portion.
- What setup.sh does: verify & open only — bootstraps base tools (git, curl) on Ubuntu/Debian, uses current checkout or clones/pulls into `~/repos/segmented-lab-cyberlab`, lists the key doc areas with descriptions, and presence-checks the assumed lab platforms (pfSense/OPNsense, IDS tools) without installing anything.
- Issue it prevents: Rebuilding a segmented lab from memory and ending up with firewall/IDS segments that do not match the documented design.
