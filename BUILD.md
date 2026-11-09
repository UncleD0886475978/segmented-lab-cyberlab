# segmented-lab-cyberlab — BUILD

- Repo: UncleD0886475978/segmented-lab-cyberlab
- Visibility/fork: public (per sweep brief); not a fork noted
- Docs-only: YES
- Stack/content actually found (GitHub API root listing, 2026-11-09): `README.md` (1,520 B), `ids/`, `network-design/`, `pfsense-opnsense/`, `scenarios/`. No scripts, code, manifests, or compose files at root. Deeper README/subdir reads were cut off by a GitHub API HTTP 429 rate-limit — noted here; listing above is the verified portion.
- What setup.sh does: verify & open only — checks git, uses current checkout or clones/pulls into `~/repos/segmented-lab-cyberlab`, lists the key doc areas with descriptions, and presence-checks the assumed lab platforms (pfSense/OPNsense, IDS tools) without installing anything.
- Issue it prevents: Rebuilding a segmented lab from memory and ending up with firewall/IDS segments that do not match the documented design.
