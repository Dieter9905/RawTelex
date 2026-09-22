# RawTelex

> **Raw Vietnamese Telex Input Method** — Pure diacritics, zero intelligence.  
> Không từ điển, không tự động sửa, không gợi ý — chỉ map phím → Unicode thuần túy.

---

## ✨ Tính năng

| Tính năng | Trạng thái |
|-----------|------------|
| Tự động sửa `Viet Nam` → `Việt Nam` | ❌ **KHÔNG** |
| Từ điển / Gợi ý / Học từ mới | ❌ **KHÔNG** |
| Hiển thị khung ứng viên (candidate window) | ❌ **KHÔNG** |
| Hỗ trợ `z`, `q`, `c`, `v` với 5 dấu | ✅ **CÓ** |
| Telex chuẩn cho tiếng Việt | ✅ **CÓ** |
| Chỉ thêm dấu, không can thiệp từ vựng | ✅ **CÓ** |

---

## 🎯 Dành cho ai?

- Muốn gõ `zẻ`, `zú`, `zạ`, `qá`, `cô`... tự do không bị sửa
- Ghét bộ gõ tự động "thông minh" nhảy `Viet Nam` → `Việt Nam`
- Cần bộ gõ **bị động hoàn toàn**: gõ gì ra đó
- Dùng **Fcitx5** trên Arch/Manjaro/EndeavourOS (Linux)

---

## ⌨️ Bảng phím Telex (RawTelex)

| Tone | Key | Ví dụ |
|------|-----|-------|
| Sắc (´) | `s` | `as` → `á`, `es` → `é` |
| Huyền (`) | `f` | `af` → `à`, `ef` → `è` |
| Hỏi (?) | `r` | `ar` → `ả`, `er` → `ẻ` |
| Ngã (~) | `x` | `ax` → `ã`, `ex` → `ẽ` |
| Nặng (.) | `j` | `aj` → `ạ`, `ej` → `ẹ` |
| Móc (ă/ơ/ư) | `w` | `aw` → `ă`, `ow` → `ơ`, `w` → `ư` |
| Mũ (â/ê/ô) | `a`/`e`/`o` kép | `aa` → `â`, `ee` → `ê`, `oo` → `ô` |

### Mở rộng cho ký tự không chuẩn:
| Gõ | Kết quả |
|----|---------|
| `zer` | `zẻ` |
| `zus` | `zú` |
| `zaj` | `zạ` |
| `qas` | `qá` |
| `cs` | `ć` |
| `vs` | `v́` |

> **Lưu ý**: Nhấn **SPACE** sau mỗi từ để commit (vì `AutoCommit=false`).

---

## 📦 Cài đặt (Arch/Manjaro/EndeavourOS)

### Yêu cầu
```bash
sudo pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-table-other
```

### Cài RawTelex
```bash
git clone https://github.com/<your-username>/rawtelex.git
cd rawtelex
chmod +x install.sh
./install.sh
```

Sau đó **logout/login** (hoặc reboot).

### Bật tiếng Việt
- Hotkey mặc định: **`Super+Space`**
- Hoặc cấu hình trong `fcitx5-configtool`

---

## 🔧 Cấu hình nâng cao

### Thay đổi hotkey
Sửa `~/.config/fcitx5/conf/fcitx5.conf`:
```ini
[Hotkey]
TriggerInputMethod=Super+Space
SwitchForward=Control+Shift+space
```

### Thêm/khim mapping mới
Sửa `rawtelex.txt` rồi chạy lại `./install.sh`:
```txt
# Ví dụ thêm mapping cho 'k'
ks	ḱ
kf	ḱ
kr	ḱ
kx	ḱ
kj	ḱ
```

---

## 🗂️ Cấu trúc repo

```
rawtelex/
├── rawtelex.txt          # Bảng mã chính (format fcitx5-table-other)
├── install.sh            # Script cài đặt tự động
├── uninstall.sh          # Script gỡ cài đặt
├── LICENSE               # MIT License
└── README.md             # File này
```

---

## 🐛 Debug

```bash
# Kiểm tra bảng mã đã load
ls ~/.local/share/fcitx5/table/rawtelex.txt

# Xem profile hiện tại
cat ~/.config/fcitx5/profile

# Restart Fcitx5
systemctl --user restart fcitx5

# Chẩn đoán
fcitx5-diagnose
```

---

## 📄 License

MIT License — Tự do sử dụng, sửa đổi, phân phối.

---

## 👤 Author

**RawTelex** — Tạo bởi [Nhat](https://github.com/nhat) cho riêng mình.  
*"Gõ gì ra đó, không hỏi han, không tự làm chủ."*