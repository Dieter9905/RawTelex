#!/bin/bash
# ============================================
# RawTelex - UniKey on Fcitx5
# Cài đặt & cấu hình hoàn chỉnh
# Arch/Manjaro/EndeavourOS
# ============================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${BLUE}[*]${NC} $*"; }
ok() { echo -e "${GREEN}[✓]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err() { echo -e "${RED}[✗]${NC} $*"; }
info() { echo -e "${CYAN}[i]${NC} $*"; }

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════╗"
echo "║     RawTelex — UniKey cho Linux           ║"
echo "║     Gõ tới đâu dấu ra tới đó              ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ============================================
# BƯỚC 1: KIỂM TRA & CÀI GÓI
# ============================================
check_packages() {
    log "Kiểm tra gói đã cài..."
    
    local missing=()
    
    # Kiểm tra fcitx5
    if ! command -v fcitx5 &>/dev/null; then
        missing+=("fcitx5")
    fi
    
    # Kiểm tra fcitx5-unikey
    if ! pacman -Q fcitx5-unikey &>/dev/null; then
        missing+=("fcitx5-unikey")
    fi
    
    # Kiểm tra AUR helper
    local aur_helper=""
    if command -v yay &>/dev/null; then
        aur_helper="yay"
    elif command -v paru &>/dev/null; then
        aur_helper="paru"
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        warn "Thiếu gói: ${missing[*]}"
        echo
        info "Chạy lệnh sau để cài đặt:"
        echo "  sudo pacman -S --needed fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool"
        if [[ -n "$aur_helper" ]]; then
            echo "  $aur_helper -S fcitx5-unikey"
        else
            echo "  yay -S fcitx5-unikey   # hoặc paru -S fcitx5-unikey"
        fi
        echo
        read -p "Bạn đã cài xong? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            err "Hủy cài đặt. Chạy lại sau khi cài gói."
            exit 1
        fi
        
        # Kiểm tra lại
        if ! command -v fcitx5 &>/dev/null || ! pacman -Q fcitx5-unikey &>/dev/null; then
            err "Gói vẫn chưa được cài. Hãy cài trước rồi chạy lại."
            exit 1
        fi
    fi
    
    ok "Tất cả gói đã sẵn sàng"
}

# ============================================
# BƯỚC 2: BIẾN MÔI TRƯỜNG
# ============================================
setup_environment() {
    log "Cấu hình biến môi trường..."
    
    # systemd environment.d
    mkdir -p ~/.config/environment.d
    cat > ~/.config/environment.d/fcitx5.conf <<'EOF'
# RawTelex — Fcitx5 Environment Variables
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
GLFW_IM_MODULE=ibus
EOF
    ok "environment.d/fcitx5.conf"
    
    # Shell profile
    for rc in ~/.bashrc ~/.zshrc; do
        if [[ -f "$rc" ]] && ! grep -q "GTK_IM_MODULE=fcitx" "$rc" 2>/dev/null; then
            cat >> "$rc" <<'EOF'

# RawTelex — Fcitx5 Vietnamese Input
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GLFW_IM_MODULE=ibus
EOF
            ok "$rc"
        fi
    done
    
    # GTK3 settings
    mkdir -p ~/.config/gtk-3.0
    if [[ ! -f ~/.config/gtk-3.0/settings.ini ]] || ! grep -q "gtk-im-module" ~/.config/gtk-3.0/settings.ini 2>/dev/null; then
        cat > ~/.config/gtk-3.0/settings.ini <<'EOF'
[Settings]
gtk-im-module=fcitx
EOF
        ok "gtk-3.0/settings.ini"
    fi
    
    # GTK4 settings
    mkdir -p ~/.config/gtk-4.0
    if [[ ! -f ~/.config/gtk-4.0/settings.ini ]] || ! grep -q "gtk-im-module" ~/.config/gtk-4.0/settings.ini 2>/dev/null; then
        cat > ~/.config/gtk-4.0/settings.ini <<'EOF'
[Settings]
gtk-im-module=fcitx
EOF
        ok "gtk-4.0/settings.ini"
    fi
}

# ============================================
# BƯỚC 3: CẤU HÌNH FCITX5 PROFILE
# ============================================
setup_profile() {
    log "Cấu hình Fcitx5 profile..."
    
    cat > ~/.config/fcitx5/profile <<'EOF'
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=unikey

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=unikey
Layout=

[GroupOrder]
0=Default
EOF
    
    ok "Profile: keyboard-us + unikey"
}

# ============================================
# BƯỚC 4: CẤU HÌNH UNIKEY ENGINE
# ============================================
setup_unikey_config() {
    log "Cấu hình UniKey engine..."
    
    mkdir -p ~/.config/fcitx5/conf
    
    cat > ~/.config/fcitx5/conf/unikey.conf <<'EOF'
# RawTelex — UniKey Configuration (chuẩn UniKey Windows)
# https://github.com/Dieter9905/RawTelex

[General]
# Phương pháp gõ
# 0=Telex, 1=VNI, 2=VIQR, 3=Telex+VNI
InputMethod=0

# ── GÕ REAL-TIME (giống UniKey Windows) ──
AutoCommit=true                    # Gõ xong ra ngay, KHÔNG cần Space
AutoSelect=true                    # Tự chọn ứng viên đầu tiên
RestoreCursorPosition=true         # QUAN TRỌNG: sửa dấu inline được
AllowToneOnSingleLetter=true       # a + s = á ngay lập tức
BackspaceRemovesDiacritic=true     # Backspace xóa DẤU (giữ nguyên chữ)
PreserveCase=true                  # Giữ nguyên chữ hoa/thường

# ── TẮT TOÀN BỘ TỰ ĐỘNG HÓA ──
LearnMode=false                    # KHÔNG học từ mới
ShowCandidateWindow=false          # KHÔNG hiển thị gợi ý
AutoCorrect=false                  # KHÔNG tự sửa Viet Nam → Việt Nam
SmartWildcard=false                # KHÔNG dùng wildcard
ShortcutMode=false                 # KHÔNG gõ tắt
AutoSpace=false                    # KHÔNG tự thêm dấu cách

# ── HOTKEY ──
SwitchMethodHotkey=Control+Shift+M # Chuyển Telex ↔ VNI ↔ VIQR

# ── KHÁC ──
SpecialCharForTone=0               # Không dùng ký tự đặc biệt
EOF
    
    ok "unikey.conf"
}

# ============================================
# BƯỚC 5: SYSTEMD USER SERVICE
# ============================================
setup_autostart() {
    log "Thiết lập tự động khởi động..."
    
    mkdir -p ~/.config/systemd/user
    cat > ~/.config/systemd/user/fcitx5.service <<'EOF'
[Unit]
Description=Fcitx5 Input Method (RawTelex)
Documentation=man:fcitx5(1)
After=graphical-session.target wayland-session.target
Wants=graphical-session.target

[Service]
Type=notify
ExecStart=/usr/bin/fcitx5
Restart=on-failure
RestartSec=5
Environment=GTK_IM_MODULE=fcitx
Environment=QT_IM_MODULE=fcitx
Environment=XMODIFIERS=@im=fcitx

[Install]
WantedBy=graphical-session.target wayland-session.target
EOF
    
    systemctl --user daemon-reload
    systemctl --user enable --now fcitx5.service 2>/dev/null || true
    
    ok "fcitx5.service enabled"
}

# ============================================
# BƯỚC 6: KIỂM TRA CUỐI
# ============================================
verify() {
    log "Kiểm tra cài đặt..."
    
    # Kiểm tra binary
    for cmd in fcitx5 fcitx5-configtool; do
        if command -v "$cmd" &>/dev/null; then
            ok "$cmd: $(command -v "$cmd")"
        else
            err "$cmd: KHÔNG TÌM THẤY"
        fi
    done
    
    # Kiểm tra UniKey addon
    if [[ -f /usr/share/fcitx5/addon/unikey.conf ]] || pacman -Q fcitx5-unikey &>/dev/null; then
        ok "fcitx5-unikey: ĐÃ CÀI"
    else
        err "fcitx5-unikey: CHƯA CÀI"
    fi
    
    # Kiểm tra profile
    if grep -q "DefaultIM=unikey" ~/.config/fcitx5/profile 2>/dev/null; then
        ok "Profile: unikey"
    else
        err "Profile: KHÔNG PHẢI unikey"
    fi
    
    # Kiểm tra config
    if grep -q "AutoCommit=true" ~/.config/fcitx5/conf/unikey.conf 2>/dev/null; then
        ok "unikey.conf: AutoCommit=true"
    else
        err "unikey.conf: AutoCommit KHÔNG PHẢI true"
    fi
    
    # Kiểm tra environment
    if grep -q "GTK_IM_MODULE=fcitx" ~/.config/environment.d/fcitx5.conf 2>/dev/null; then
        ok "Environment: GTK_IM_MODULE=fcitx"
    else
        warn "Environment: CHƯA CẤU HÌNH"
    fi
}

# ============================================
# MAIN
# ============================================
main() {
    check_packages
    setup_environment
    setup_profile
    setup_unikey_config
    setup_autostart
    verify
    
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✅ HOÀN TẤT! SẴN SÀNG DÙNG            ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}Bước tiếp theo:${NC}"
    echo "  1. Đăng xuất → Đăng nhập lại (hoặc reboot)"
    echo "  2. Nhấn ${GREEN}Super+Space${NC} để bật tiếng Việt"
    echo "  3. Test gõ:"
    echo
    echo -e "${CYAN}     a         → ${NC}a  (ra ngay)"
    echo -e "${CYAN}     as        → ${NC}á  (dấu ra ngay, không cần Space)"
    echo -e "${CYAN}     asf       → ${NC}à  (đổi dấu real-time)"
    echo -e "${CYAN}     viet      → ${NC}viet (KHÔNG tự thành Việt)"
    echo -e "${CYAN}     viets     → ${NC}viét (e → é ngay)"
    echo -e "${CYAN}     [Backspace]→ ${NC}viet (xóa dấu, giữ chữ)"
    echo -e "${CYAN}     [Space]   → ${NC}commit từ"
    echo
    echo -e "${YELLOW}Hotkey:${NC}"
    echo "  Super+Space     → Bật/tắt tiếng Việt"
    echo "  Ctrl+Shift+M    → Chuyển Telex ↔ VNI ↔ VIQR"
    echo
    echo -e "${YELLOW}Tinh chỉnh:${NC}"
    echo "  fcitx5-configtool → Addon → UniKey → Configure"
    echo
    echo -e "${BLUE}GitHub:${NC} https://github.com/Dieter9905/RawTelex"
}

main "$@"