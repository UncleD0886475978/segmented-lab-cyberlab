#!/usr/bin/env bash
set -e
# segmented-lab-cyberlab — verify & open (docs-only repo, no build/deploy)
# VM bootstrap: on a fresh Ubuntu/Debian VM this script INSTALLS its own
# base prerequisites (git, curl) via apt. The lab platforms/tools the docs
# assume (pfSense/OPNsense, Proxmox, Suricata/Snort/Zeek) stay
# presence-checks only — the original script never invoked Docker or
# kubectl, so neither is bootstrapped here. On non-apt platforms it falls
# back to check-and-guide.
REPO="segmented-lab-cyberlab"
OWNER="UncleD0886475978"
RUN_ONELINE="curl -fsSL https://raw.githubusercontent.com/${OWNER}/${REPO}/main/setup.sh | bash"

if [ -f "$0" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
else
  SCRIPT_DIR="$PWD"
fi
# SCRIPT_DIR is only informational here (locate-or-clone below uses $PWD /
# ~/repos); it keeps the curl|bash case ($0 = "bash") from misbehaving.
echo "    Script dir: ${SCRIPT_DIR}"

echo "==> [1/5] Platform check + base bootstrap (git, curl)"
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  else
    echo "ERROR: this script needs root or sudo to install packages."
    exit 1
  fi
fi
APT=0
if [ "$(uname -s)" = "Linux" ] && command -v apt-get >/dev/null 2>&1; then APT=1; fi
INSTALLED=""
APT_UPDATED=""
note_installed() { INSTALLED="${INSTALLED} $1"; }
apt_update_once() {
  if [ -z "${APT_UPDATED}" ]; then $SUDO apt-get update -y; APT_UPDATED=1; fi
}
apt_install() {
  apt_update_once
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y "$@"
}
if [ "${APT}" -eq 1 ]; then
  BASE_PKGS=""
  command -v git >/dev/null 2>&1 || BASE_PKGS="${BASE_PKGS} git"
  command -v curl >/dev/null 2>&1 || BASE_PKGS="${BASE_PKGS} curl"
  [ -f /etc/ssl/certs/ca-certificates.crt ] || BASE_PKGS="${BASE_PKGS} ca-certificates"
  command -v gpg >/dev/null 2>&1 || BASE_PKGS="${BASE_PKGS} gnupg"
  if [ -n "${BASE_PKGS}" ]; then
    echo "    Installing base tools:${BASE_PKGS}"
    # shellcheck disable=SC2086
    apt_install ${BASE_PKGS}
    note_installed "${BASE_PKGS}"
  else
    echo "    Base tools already present (git, curl, ca-certificates, gnupg)."
  fi
else
  echo "    Non-apt platform detected — bootstrap will only CHECK tools and print install guidance."
fi
# Non-apt fallback: git must exist before the locate-or-clone step can run.
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

cat <<EOF

=================== BOOTSTRAP SUMMARY ===================
Installed during this run:${INSTALLED:- (nothing — all tools were already present)}
Working copy: ${REPO_DIR}
Next time, set up from scratch on any fresh Ubuntu VM with one line:
  ${RUN_ONELINE}
=========================================================
EOF

echo "Next commands:"
echo "  cd $REPO_DIR"
echo "  cat README.md"
echo "  ls network-design/ pfsense-opnsense/ ids/ scenarios/"
