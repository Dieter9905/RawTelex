#!/bin/bash
# ============================================
# Uninstall RawTelex
# ============================================

set -euo pipefail

TABLE_NAME="rawtelex"
USER_DEST_DIR="${HOME}/.local/share/fcitx5/table"
SYSTEM_DEST_DIR="/usr/share/fcitx5/table"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[*]${NC} $*"; }
ok() { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err() { echo -e "${RED}[✗]${NC} $*"; }

echo "=========================================="
echo "  Gỡ cài đặt RawTelex"
echo "=========================================="
echo

# Remove user table
if [[ -f "${USER_DEST_DIR}/${TABLE_NAME}.txt" ]]; then
    log "Xóa user table: ${USER_DEST_DIR}/${TABLE_NAME}.txt"
    rm -f "${USER_DEST_DIR}/${TABLE_NAME}.txt"
    ok "Đã xóa user table"
else
    warn "User table không tồn tại"
fi

# Remove system table (optional)
if [[ -f "${SYSTEM_DEST_DIR}/${TABLE_NAME}.txt" ]]; then
    log "Xóa system table: ${SYSTEM_DEST_DIR}/${TABLE_NAME}.txt (cần sudo)"
    if sudo -n true 2>/dev/null; then
        sudo rm -f "${SYSTEM_DEST_DIR}/${TABLE_NAME}.txt"
        ok "Đã xóa system table"
    else
        warn "Cần sudo để xóa system table. Chạy: sudo rm ${SYSTEM_DEST_DIR}/${TABLE_NAME}.txt"
    fi
fi

# Restore profile to keyboard-us only
PROFILE="${HOME}/.config/fcitx5/profile"
if [[ -f "$PROFILE" ]]; then
    log "Khôi phục profile mặc định (chỉ keyboard-us)"
    cat > "$PROFILE" <<'EOF'
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=keyboard-us

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[GroupOrder]
0=Default
EOF
    ok "Đã khôi phục profile"
fi

# Restart fcitx5
log "Khởi động lại Fcitx5..."
systemctl --user restart fcitx5 2>/dev/null || fcitx5 -d &
sleep 1
ok "Hoàn tất gỡ cài đặt!"

echo
echo "RawTelex đã được gỡ bỏ hoàn toàn."