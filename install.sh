#!/bin/bash
# ============================================
# Install RawTelex - Vietnamese Pure Diacritic Input
# No dictionary, no autocorrect, no suggestions
# ============================================

set -euo pipefail

TABLE_NAME="rawtelex"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_TXT="${SCRIPT_DIR}/${TABLE_NAME}.txt"
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

# Check source
if [[ ! -f "$SRC_TXT" ]]; then
    err "Không tìm thấy $SRC_TXT"
    exit 1
fi

# Install user (priority, no sudo)
log "Cài đặt user: $USER_DEST_DIR"
mkdir -p "$USER_DEST_DIR"
cp "$SRC_TXT" "$USER_DEST_DIR/${TABLE_NAME}.txt"
ok "Đã copy .txt (user)"

# Install system (sudo, for backup) - optional
if sudo -n true 2>/dev/null; then
    log "Cài đặt system: $SYSTEM_DEST_DIR"
    sudo mkdir -p "$SYSTEM_DEST_DIR"
    sudo cp "$SRC_TXT" "$SYSTEM_DEST_DIR/${TABLE_NAME}.txt"
    ok "Đã copy .txt (system)"
else
    warn "Bỏ qua cài system (cần sudo password). User install đã đủ dùng."
fi

# Update Fcitx5 profile
PROFILE="${HOME}/.config/fcitx5/profile"
log "Cập nhật profile: $PROFILE"
cat > "$PROFILE" <<'EOF'
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=rawtelex

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=rawtelex
Layout=

[GroupOrder]
0=Default
EOF
ok "Đã cập nhật profile → rawtelex"

# Configure table addon (disable all automation)
CONFIG_DIR="${HOME}/.config/fcitx5/conf"
mkdir -p "$CONFIG_DIR"
cat > "${CONFIG_DIR}/table.conf" <<'EOF'
[Table]
TriggerKey=space
AutoCommit=false
AutoSelect=false
PageSize=9
WildCard=*
UseSystemLayout=false
LearnMode=false
ShowCandidateWindow=false
EOF
ok "Đã cấu hình table.conf (tắt toàn bộ tự động hóa)"

# Restart fcitx5
log "Khởi động lại Fcitx5..."
systemctl --user restart fcitx5 2>/dev/null || fcitx5 -d &
sleep 1
ok "Hoàn tất!"

echo
echo "=========================================="
echo "  RawTelex - ĐÃ CÀI ĐẶT THÀNH CÔNG"
echo "=========================================="
echo
echo "Test ngay (bật tiếng Việt: Super+Space):"
echo
echo "  zer[SPACE]    → zẻ"
echo "  zaj[SPACE]    → zạ"
echo "  zor[SPACE]    → zỏ"
echo "  zox[SPACE]    → zõ"
echo
echo "  Viet Nam[SPACE]      → Viet Nam (KHÔNG tự thêm dấu)"
echo "  Viet s Nam s[SPACE]  → Việt Nám (bạn chủ động gõ tone)"
echo
echo "Đặc điểm RawTelex:"
echo "  ✓ Không từ điển, không gợi ý"
echo "  ✓ Không tự động sửa, không học từ"
echo "  ✓ Hỗ trợ z, q, c, v với 5 dấu"
echo "  ✓ Gõ gì ra đó - pure diacritic"
echo
echo "Lưu ý: Nhấn SPACE sau mỗi từ để commit."