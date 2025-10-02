#!/usr/bin/env bash
set -euo pipefail

EXPORT_DIR="/mnt/shared"
CLIENTS="*"

EXPORT_OPTS="rw,no_root_squash,insecure,sync,no_subtree_check"

EXPORTS_D="/etc/exports.d"
EXPORTS_FILE="${EXPORTS_D}/k8s-homelab.exports"

install_nfs_server() {
  echo "[*] Installing NFS server packages..."
  apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y nfs-kernel-server
}

prepare_export_dir() {
  echo "[*] Preparing export directory at ${EXPORT_DIR}..."
  mkdir -p "${EXPORT_DIR}"
  chown nobody:nogroup "${EXPORT_DIR}"
  chmod 0777 "${EXPORT_DIR}"
}

write_exports() {
  echo "[*] Writing exports file at ${EXPORTS_FILE}..."
  mkdir -p "${EXPORTS_D}"
  local line="${EXPORT_DIR} ${CLIENTS}(${EXPORT_OPTS})"
  {
    echo "# Managed by nfs_setup.sh"
    echo "# WARNING: no_root_squash + insecure are risky; use only in a trusted lab."
    echo "${line}"
  } > "${EXPORTS_FILE}"

  echo "[*] Exports file contents:"
  cat "${EXPORTS_FILE}"
}

reload_nfs() {
  echo "[*] Reloading NFS exports and restarting service..."
  exportfs -ra
  systemctl enable nfs-kernel-server
  systemctl restart nfs-kernel-server
}

configure_firewall() {
  if command -v ufw >/dev/null 2>&1; then
    if ufw status | grep -qi "Status: active"; then
      echo "[*] UFW detected and active. Allowing TCP/UDP 2049..."
      ufw allow 2049/tcp || true
      ufw allow 2049/udp || true
    else
      echo "[*] UFW installed but not active; skipping firewall rules."
    fi
  else
    echo "[*] UFW not installed; skipping firewall config."
  fi
}

show_status() {
  echo
  echo "=== NFS Status ==="
  systemctl --no-pager status nfs-kernel-server || true
  echo
  echo "=== Exported Filesystems ==="
  exportfs -v || true
  echo
  echo "Done."
  echo "Example mount (Linux client):"
  echo "  sudo mkdir -p /mnt/nfs && sudo mount -t nfs -o nfsvers=4 <SERVER_IP>:${EXPORT_DIR} /mnt/nfs"
  echo "Test:"
  echo "  touch /mnt/nfs/hello.txt && ls -l /mnt/nfs"
}

main() {
  if [[ $EUID -ne 0 ]]; then
    echo "Please run as root: sudo $0"
    exit 1
  fi
  install_nfs_server
  prepare_export_dir
  write_exports
  reload_nfs
  configure_firewall
  show_status
}
main "$@"

