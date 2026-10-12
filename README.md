# Dotfiles & Automated Setup Kit for Windows

Bộ kịch bản tự động hóa cài đặt và khôi phục môi trường làm việc trên Windows, được xây dựng theo đúng triết lý từ video của **Vũ Nguyễn Coder**, nhưng được **cá nhân hóa 100% dựa trên toàn bộ ứng dụng và cấu hình đang có trên chiếc laptop của bạn**.

---

## 📦 Danh sách toàn bộ ứng dụng & công cụ được đồng bộ

### 1. Trình duyệt Web
- **Google Chrome** (`Google.Chrome`)
- **Mozilla Firefox** (`Mozilla.Firefox`)

### 2. Bộ công cụ Lập trình & Terminal
- **Git for Windows** (`Git.Git`)
- **Visual Studio Code** (`Microsoft.VisualStudioCode`)
- **Windows Terminal Preview** (`Microsoft.WindowsTerminal.Preview`)
- **Starship Cross-shell Prompt** (`Starship.Starship`)
- **Node.js LTS (npm / npx)** (`OpenJS.NodeJS.LTS`)
- **Docker CLI & Docker Compose** (`Docker.DockerCLI`, `Docker.DockerCompose`)
- **Termius (SSH Client)** (`Termius.Termius`)
- **Google Antigravity** (`Google.Antigravity`)

### 3. Tiện ích Hệ thống & Tìm kiếm
- **Microsoft PowerToys** (`Microsoft.PowerToys`)
- **Tailscale Mesh VPN** (`Tailscale.Tailscale`)
- **Everything (voidtools)** – Tìm kiếm tập tin tức thì (`voidtools.Everything`)
- **Internet Download Manager (IDM)** (`Tonec.InternetDownloadManager`)
- **nomacs - Image Lounge** – Trình xem ảnh gọn nhẹ (`nomacs.nomacs`)

### 4. Giao tiếp, Giải trí & Sáng tạo nội dung
- **Telegram Desktop** (`Telegram.TelegramDesktop`)
- **Zalo PC** (`VNGCorp.Zalo`)
- **OBS Studio** – Quay màn hình & livestream (`OBSProject.OBSStudio`)
- **CapCut PC** – Chỉnh sửa video (`ByteDance.CapCut`)
- **Spotify** – Nghe nhạc (`Spotify.Spotify`)

### 5. Thư viện hệ thống C++ Runtimes
- **Microsoft Visual C++ 2010 x86 & x64**
- **Microsoft Visual C++ 2015-2022 Redistributable x86 & x64**

---

## ⚙️ Các file cấu hình (Dotfiles) được sao lưu & tự động nạp

1. **`configs/starship.toml`**  
   File cấu hình Starship Prompt hiện tại của bạn: hiển thị thư mục rút gọn, nhánh Git, trạng thái Git, runtime NodeJS/Python/Go/Rust/Docker và thời gian thực thi lệnh.
2. **`configs/.bashrc` & `.bash_profile`**  
   Cấu hình cho Git Bash: các alias `her='herdr'`, `ag='agy --dangerously-skip-permissions'`, `agy='...'` và lệnh kích hoạt Starship.
3. **`configs/Microsoft.PowerShell_profile.ps1`**  
   Profile cho PowerShell và PowerShell 7: tích hợp alias `her` và Starship.
4. **`configs/terminal-settings.json`**  
   Cấu hình Windows Terminal Preview: đặt **Git Bash làm shell mặc định**, tích hợp phím tắt `Ctrl+C` copy, `Ctrl+V` paste, `Alt+Shift+D` chia cửa sổ pane.
5. **`configs/vscode-settings.json`**  
   Cấu hình cài đặt cho VS Code.

---

## 🚀 Cách sử dụng

### 1. Chạy ngay trên máy này (hoặc máy mới)
Mở **PowerShell** (khuyến nghị chạy với quyền Administrator để kích hoạt luôn các thư viện hệ thống và WSL nếu muốn):

```powershell
# Chạy toàn bộ quy trình: Cài app + nạp config
.\setup.ps1

# Chỉ nạp lại cấu hình (không cài lại app):
.\setup.ps1 -SkipApps

# Bật cả tính năng ảo hóa và WSL:
.\setup.ps1 -EnableWSL
```

### 2. Cách đưa lên GitHub để dùng vĩnh viễn (như Vũ Nguyễn Coder)

1. Tạo một repository mới trên GitHub (ví dụ: `my-windows-dotfiles`).
2. Mở terminal tại thư mục này và đẩy code lên:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: full windows setup kit"
   git branch -M main
   git remote add origin https://github.com/<username>/my-windows-dotfiles.git
   git push -u origin main
   ```
3. Khi mua máy mới hoặc cài lại Win, bạn chỉ cần mở PowerShell và gõ:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
   git clone https://github.com/<username>/my-windows-dotfiles.git
   cd my-windows-dotfiles
   .\setup.ps1 -EnableWSL
   ```
   Toàn bộ máy tính sẽ tự động được thiết lập về trạng thái hiện tại trong vòng vài phút!
