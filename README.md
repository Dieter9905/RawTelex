# RawTelex — UniKey cho Linux

> **Bộ gõ tiếng Việt trên Fcitx5 với hành vi giống hệt UniKey Windows.**  
> Gõ tới đâu dấu ra tới đó · Sửa dấu inline · Không cần Space · Không tự sửa từ vựng

---

## 📌 Tổng quan

**RawTelex** là bộ cấu hình Fcitx5 + **UniKey engine** dành cho Linux (Arch/Manjaro/EndeavourOS), mang lại trải nghiệm gõ tiếng Việt **y hệt UniKey trên Windows**:

| Tính năng | Trạng thái |
|-----------|-----------|
| Gõ chữ → hiện chữ ngay (không cần Space) | ✅ |
| Gõ dấu → chữ **trước đó** thêm dấu ngay | ✅ |
| Sửa dấu inline (xóa dấu → gõ dấu mới trên cùng chữ) | ✅ |
| Backspace chỉ xóa dấu (không xóa cả chữ) | ✅ |
| Tự động commit từ khi bấm Space | ✅ |
| **KHÔNG** tự sửa `Viet Nam` → `Việt Nam` | ✅ |
| **KHÔNG** từ điển / gợi ý / học từ mới | ✅ |
| Hỗ trợ Telex, VNI, VIQR (chuyển bằng hotkey) | ✅ |

---

## 📚 Nguồn tham khảo (Nguồn & Credit)

Dự án này là **cấu hình + gộp tài liệu** từ các nguồn sau, không phải viết lại từ đầu:

| Nguồn | Đường dẫn | Đóng góp |
|-------|-----------|----------|
| **Fcitx5** | https://fcitx-im.org/ · https://github.com/fcitx/fcitx5 | Framework nhập liệu chính |
| **Fcitx5 UniKey** | https://github.com/fcitx/fcitx5-unikey (AUR: `fcitx5-unikey`) | Engine UniKey port sang Fcitx5 |
| **UniKey Windows** | https://unikey.org/ · http://unikey.org/ | Bản gốc hành vi gõ Telex/VNI/VIQR trên Windows |
| **ArchWiki — Fcitx5** | https://wiki.archlinux.org/title/Fcitx5 | Hướng dẫn cài đặt & environment variables |
| **ArchWiki — Vietnamese** | https://wiki.archlinux.org/title/Handling_of_CJK_languages#Vietnamese | Cấu hình tiếng Việt trên Arch |
| **Fcitx5 Table Other** | https://github.com/fcitx/fcitx5-table-other | Bản table-based (RawTelex v1 — đã bỏ, không đủ behavior) |

> **Ghi chú:** Phiên bản 1.0 của RawTelex dùng `fcitx5-table-other` (table-based).  
> Table-based **không thể** làm inline editing (sửa dấu sau khi commit).  
> **Từ v1.1 → nay** chuyển sang dùng **`fcitx5-unikey`** (UniKey engine) để đạt full behavior UniKey Windows.

---

## 📦 Yêu cầu hệ thống

| Thành phần | Phiên bản |
|-----------|-----------|
| OS | Arch Linux / Manjaro / EndeavourOS (hoặc distro pacman-based) |
| Desktop | X11 hoặc Wayland (GNOME, KDE, Hyprland, Sway, i3...) |
| Bộ gõ | **Fcitx5** (≥ 5.0) |
| AUR helper | `yay` hoặc `paru` |
| Font hỗ trợ Unicode | `ttf-dejavu` hoặc `noto-fonts` |

---

## 🚀 Cài đặt (3 bước)

### Bước 1 — Cài gói hệ thống

```bash
# Fcitx5 core + integration
sudo pacman -S --needed fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool

# UniKey engine (từ AUR)
yay -S fcitx5-unikey
# hoặc
paru -S fcitx5-unikey
```

### Bước 2 — Cấu hình

```bash
git clone https://github.com/Dieter9905/RawTelex.git
cd RawTelex
chmod +x install.sh
./install.sh
```

Script sẽ tự động:
- Tạo biến môi trường GTK/QT/XIM/Wayland
- Cấu hình profile: `keyboard-us` + `unikey`
- Tạo `~/.config/fcitx5/conf/unikey.conf` (chuẩn UniKey Windows)
- Bật systemd user service (tự khởi động cùng phiên đăng nhập)

### Bước 3 — Đăng xuất → Đăng nhập lại

> **Bắt buộc** để environment variables có hiệu lực.

---

## ⌨️ Cách gõ (Telex)

| Phím | Kết quả | Ví dụ |
|------|---------|-------|
| `a` | `a` (ra ngay, không chờ) | `a` → `a` |
| `a` + `s` | `á` (ngay lập tức) | `as` → `á` |
| `a` + `s` + `f` | `à` (đổi dấu ngay) | `asf` → `à` |
| `a` + `s` + `f` + `r` | `ả` | `asfr` → `ả` |
| `dd` | `đ` | `dd` → `đ` |
| `aa` | `â` | `aa` | → `â` |
| `aw` | `ă` | `aw` → `ă` |
| `ee` | `ê` | `ee` → `ê` |
| `oo` | `ô` | `oo` → `ô` |
| `ow` | `ơ` | `ow` → `ơ` |
| `w` (sau u) | `ư` | `uw` → `ư` |
| `Space` | Commit từ → sang từ mới | `hanoi ` → `hanoi ` |

### Tone keys (Telex)

| Phím | Dấu | Ví dụ |
|------|-----|-------|
| `s` | Sắc ´ | `as` → `á` |
| `f` | Huyền ` | `af` → `à` |
| `r` | Hỏi ? | `ar` → `ả` |
| `x` | Ngã ~ | `ax` → `ã` |
| `j` | Nặng . | `aj` → `ạ` |

### Sửa dấu inline (không cần xóa từ)

```
Gõ:  v i e t   → "viet" (ra ngay)
Gõ:  s         → "viét" (e → é ngay)
Gõ:  Backspace → "viet" (xóa dấu, giữ nguyên e)
Gõ:  f         → "vièt" (đổi sang huyền)
Gõ:  Space     → commit "vièt" → sang từ mới
```

> **Quan trọng:** Backspace **chỉ xóa dấu** (`BackspaceRemovesDiacritic=true`).  
> Không mất chữ cái, không cần gõ lại cả từ.

---

## ⚙️ Cấu hình chi tiết

### File chính: `~/.config/fcitx5/conf/unikey.conf`

```ini
[General]
InputMethod=0                  # 0=Telex, 1=VNI, 2=VIQR, 3=Telex+VNI
AutoCommit=true                # Gõ xong ra ngay, không cần Space
AutoSelect=true                # Tự chọn ứng viên đầu tiên
RestoreCursorPosition=true     # QUAN TRỎI: cho phép sửa inline
LearnMode=false                # TẮT: không học từ mới
ShowCandidateWindow=false      # TẮT: không hiển thị gợi ý
AutoCorrect=false              # TẮT: không tự sửa Viet Nam → Việt Nam
SmartWildcard=false            # TẮT: không dùng wildcard
ShortcutMode=false             # TẮT: không gõ tắt
AutoSpace=false                # TẮT: không tự thêm dấu cách
BackspaceRemovesDiacritic=true # Backspace xóa dấu, giữ chữ
PreserveCase=true              # Giữ nguyên chữ hoa/thường
AllowToneOnSingleLetter=true   # Cho phép gõ dấu trên 1 chữ
SwitchMethodHotkey=Control+Shift+M  # Chuyển Telex ↔ VNI ↔ VIQR
SpecialCharForTone=0           # Không dùng ký tự đặc biệt
```

### File profile: `~/.config/fcitx5/profile`

```ini
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
```

### Environment variables: `~/.config/environment.d/fcitx5.conf`

```ini
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
SDL_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
GLFW_IM_MODULE=ibus
```

---

## 🔄 Chuyển phương pháp gõ

| Hotkey | Chức năng |
|--------|-----------|
| `Super+Space` | Bật/tắt tiếng Việt |
| `Ctrl+Shift+M` | Chuyển Telex ↔ VNI ↔ VIQR |
| `Ctrl+Shift+Space` | Chuyển input method tiếp theo |

Hoặc qua GUI:

```bash
fcitx5-configtool
# → Tab "Input Method" → UniKey → Configure → Input Method
```

---

## 🛠️ Troubleshooting (Sửa lỗi)

### 1. Không gõ được tiếng Việt

```bash
# Kiểm tra fcitx5 đang chạy
systemctl --user status fcitx5

# Restart
systemctl --user restart fcitx5

# Chẩn đoán
fcitx5-diagnose
```

### 2. Gõ nhưng không hiện dấu

```bash
# Kiểm tra UniKey addon đã load chưa
grep -r "unikey" ~/.config/fcitx5/

# Kiểm tra profile
cat ~/.config/fcitx5/profile | grep -i unikey

# Kiểm tra config
cat ~/.config/fcitx5/conf/unikey.conf
```

### 3. Biến môi trường không hoạt động

```bash
# Kiểm tra
echo $GTK_IM_MODULE   # phải ra: fcitx
echo $QT_IM_MODULE    # phải ra: fcitx
echo $XMODIFIERS      # phải ra: @im=fcitx

# Nếu trống → đăng xuất/login lại hoặc source lại shell
source ~/.bashrc
```

### 4. GTK apps (Firefox, Nautilus) không nhận input

```bash
# Đảm bảo file này tồn tại:
cat ~/.config/gtk-3.0/settings.ini
# Phải có:
# [Settings]
# gtk-im-module=fcitx
```

### 5. Wayland (GNOME/KDE/Sway/Hyprland)

```bash
# Thêm vào ~/.config/environment.d/fcitx5.conf
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

# Với Hyprland: thêm vào ~/.config/hypr/hyprland.conf
env = GTK_IM_MODULE,fcitx
env = QT_IM_MODULE,fcitx
env = XMODIFIERS,@im=fcitx
exec-once = fcitx5 -d
```

### 6. UniKey không hiện trong Input Method list

```bash
# Cài lại từ AUR
yay -R fcitx5-unikey
yay -S fcitx5-unikey

# Restart fcitx5
systemctl --user restart fcitx5

# Mở configtool → Input Method → + → tìm "Vietnamese"
```

### 7. Backspace xóa cả chữ thay vì chỉ xóa dấu

```bash
# Kiểm tra config
grep "BackspaceRemovesDiacritic" ~/.config/fcitx5/conf/unikey.conf
# Phải là: BackspaceRemovesDiacritic=true

# Nếu sai → sửa lại và restart
systemctl --user restart fcitx5
```

---

## 🗑️ Gỡ cài đặt

```bash
cd RawTelex
chmod +x uninstall.sh
./uninstall.sh

# Gỡ gói
yay -R fcitx5-unikey

# Xóa config (tuỳ chọn)
rm -rf ~/.config/fcitx5/conf/unikey.conf
rm -rf ~/.config/fcitx5/profile
rm -rf ~/.config/environment.d/fcitx5.conf

# Tắt service
systemctl --user disable --now fcitx5
```

---

## 📂 Cấu trúc repo

```
RawTelex/
├── README.md                 # File này — tài liệu đầy đủ
├── install.sh                # Script cài đặt & cấu hình
├── uninstall.sh              # Script gỡ cài đặt
├── setup-unikey-fcitx5.sh    # Script setup chi tiết (alternatives)
├── fix-common-issues.sh      # Script sửa lỗi thường gặp
├── rawtelex.txt              # Bảng mã table-based (v1 — legacy, không dùng nữa)
├── vietnamesetelex-noautocorrect.conf  # Bảng mã v1 (legacy)
├── vietnamesetelex-noautocorrect.txt   # Bảng mã v1 (legacy)
├── LICENSE                   # MIT License
└── README.md                 # Tài liệu chính
```

> ⚠️ **Lưu ý:** Các file `rawtelex.txt`, `vietnamesetelex-*` là bản **v1 (table-based)**.  
> Không dùng nữa — đã chuyển sang `fcitx5-unikey`. Giữ lại để tham khảo.

---

## ❓ FAQ

**Q: Tại sao không dùng table-based (fcitx5-table) như RawTelex v1?**  
A: Table-based chỉ map **chuỗi phím hoàn chỉnh → output**. Không có khái niệm "chữ trước đó", "cursor position", "inline edit". Nên **không thể** sửa dấu sau khi commit — phải xóa cả từ.

**Q: `AutoCommit=true` khác gì `AutoCommit=false`?**  
A: `false` = gõ `a` vẫn là pre-edit, phải bấm Space mới ra `a`. `true` = gõ `a` ra `a` ngay, gõ `s` → `a` thành `á` ngay.

**Q: Tại sao tắt hết AutoCorrect/LearnMode?**  
A: Đúng triết lý RawTelex — **gõ gì ra đó**, không can thiệp từ vựng. Muốn bật → sửa `unikey.conf`.

**Q: Gõ `viet nam` ra `Việt Nam` không?**  
A: **Không.** Ra `viet nam`. Muốn `Việt Nam` → gõ `vieet s nam s`.

**Q: Chạy được trên Ubuntu/Debian không?**  
A: Được. Thay `pacman -S` → `apt install fcitx5 fcitx5-unikey` (UniKey có trong repo Debian/Ubuntu từ 22.04+).

---

## 📄 License

MIT License — Tự do sử dụng, sửa đổi, phân phối.

Xem [LICENSE](LICENSE) để biết chi tiết.

---

## 👤 Author

**RawTelex** — Cấu hình bởi [Dieter9905](https://github.com/Dieter9905)  
*"Gõ tới đâu dấu ra tới đó — không hỏi han, không tự làm chủ."*

---

## 🙏 Cảm ơn

- [UniKey](https://unikey.org/) — Engine gõ tiếng Việt gốc trên Windows
- [Fcitx5](https://fcitx-im.org/) — Framework nhập liệu tuyệt vời cho Linux
- [Arch Linux](https://archlinux.org/) & [Manjaro](https://manjaro.org/) — Distro tuyệt vời
- Cộng đồng Fcitx5 & UniKey contributors