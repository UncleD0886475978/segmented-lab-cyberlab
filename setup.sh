#!/usr/bin/env bash
set -e
# segmented-lab-cyberlab — verify & open (docs-only repo, no build/deploy)
REPO="segmented-lab-cyberlab"
OWNER="UncleD0886475978"
echo "==> [1/5] Checking prerequisites"
command -v git >/dev/null 2>&1 || { echo "ERROR: git not found — install: https://git-scm.com/downloads"; exit 1; }
echo "    git: $(git --version)"
echo "==> [2/5] Locating checkout (current dir if already inside it, else ~/repos/$REPO)"
if [ -d .git ] && git remote get-url origin 2>/dev/null | grep -q "$REPO"; then
  REPO_DIR="$(pwd)"; echo "    Using current directory: $REPO_DIR"
else
  REPO_DIR="$HOME/repos/$REPO"
  if [ -d "$REPO_DIR/.git" ]; then echo "    Updating $REPO_DIR"; git -C "$REPO_DIR" pull --ff-only || echo "    WARN: pull failed, using existing copy"
  else mkdir -p "$HOME/repos"; git clone "https://github.com/$OWNER/$REPO.git" "$REPO_DIR"; fi
fi
cd "$REPO_DIR"
echo "==> [3/5] Key docs (verified via GitHub API root listing)"
echo "    README.md         — repo overview / lab index"
echo "    network-design/   — segmented network design and addressing"
echo "    pfsense-opnsense/ — pfSense / OPNsense firewall configuration notes"
echo "    ids/              — IDS (Suricata/Snort-style) setup and rules notes"
echo "    scenarios/        — lab attack/defense scenarios and exercises"
echo "    --- files actually present ---"
find . -path ./.git -prune -o -type f -print | sort || true
echo "==> [4/5] Tools/platforms these docs assume (harmless presence checks only)"
echo "    Assumed: pfSense or OPNsense (firewall VM/appliance, web UI), a hypervisor such as"
echo "             Proxmox VE, and IDS tooling (Suricata/Snort/Zeek) inside the lab — none installed here."
for t in ip ping curl ssh suricata snort zeek; do
  if command -v "$t" >/dev/null 2>&1; then echo "    [ok]      $t"; else echo "    [missing] $t (expected unless this host is that lab component)"; fi
done
echo "==> [5/5] Done — docs verified, nothing built or deployed"
echo "Next commands:"
echo "  cd $REPO_DIR"
echo "  cat README.md"
echo "  ls network-design/ pfsense-opnsense/ ids/ scenarios/"
