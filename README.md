# ⚡ Windows Automated Setup Kit & Dotfiles

> **Tự động hóa 100% quá trình cài đặt phần mềm và khôi phục môi trường làm việc trên Windows.**  
> Lấy cảm hứng từ triết lý DevOps & Scripting của **Vũ Nguyễn Coder**, được cá nhân hóa trọn vẹn cho lập trình viên và người dùng hiện đại.

[![OS - Windows 10/11](https://img.shields.io/badge/OS-Windows%2010%20%7C%2011-0078D6?logo=windows&logoColor=white)](#)
[![Shell - PowerShell 5.1/7+](https://img.shields.io/badge/Shell-PowerShell-5391FE?logo=powershell&logoColor=white)](#)
[![Package Manager - WinGet](https://img.shields.io/badge/PackageManager-WinGet-0080FF)](#)
[![Prompt - Starship](https://img.shields.io/badge/Prompt-Starship-DD0B78?logo=starship&logoColor=white)](#)

---

## 📌 Mục lục

- [1. Giới thiệu & Lợi ích](#1-giới-thiệu--lợi-ích)
- [2. Danh sách toàn bộ ứng dụng & công cụ](#2-danh-sách-toàn-bộ-ứng-dụng--công-cụ)
- [3. Hướng dẫn sử dụng nhanh (Quick Start)](#3-hướng-dẫn-sử-dụng-nhanh-quick-start)
- [4. Hướng dẫn chi tiết theo từng kịch bản](#4-hướng-dẫn-chi-tiết-theo-từng-kịch-bản)
  - [Kịch bản A: Thiết lập máy mới tinh / Vừa cài lại Windows](#kịch-bản-a-thiết-lập-máy-mới-tinh--vừa-cài-lại-windows)
  - [Kịch bản B: Chỉ đồng bộ lại cấu hình (Dotfiles)](#kịch-bản-b-chỉ-đồng-bộ-lại-cấu-hình-dotfiles)
  - [Kịch bản C: Kích hoạt WSL & Docker ảo hóa](#kịch-bản-c-kích-hoạt-wsl--docker-ảo-hóa)
- [5. Bảng tham số tùy chọn của Script](#5-bảng-tham-số-tùy-chọn-của-script)
- [6. Cấu trúc thư mục dự án](#6-cấu-trúc-thư-mục-dự-án)
- [7. Hướng dẫn tùy biến & thêm phần mềm mới](#7-hướng-dẫn-tùy-biến--thêm-phần-mềm-mới)
- [8. Xử lý sự cố thường gặp (Troubleshooting)](#8-xử-lý-sự-cố-thường-gặp-troubleshooting)

---

## 1. Giới thiệu & Lợi ích

Mỗi lần mua máy tính mới hoặc cài lại Windows, bạn thường phải mất cả ngày:
- Lên Google gõ tìm từng ứng dụng, tải từng file `.exe` / `.msi`.
- Ngồi click *Next... Next... Install...* lặp đi lặp lại.
- Tự tay tinh chỉnh theme, phím tắt, font chữ, cài extension VS Code, cấu hình Git Bash, Terminal, SSH...

**Bộ công cụ này giải quyết triệt để vấn đề đó:**
- **Chỉ 1 câu lệnh duy nhất:** Tự động tải, cài đặt tất cả phần mềm qua trình quản lý gói chính chủ `WinGet`.
- **Nạp cấu hình Dotfiles:** Khôi phục ngay lập tức prompt đẹp mắt, phím tắt Terminal quen thuộc, cấu hình VS Code và các alias thường dùng.
- **Không cài đè nếu đã có:** Script tự nhận diện phần mềm đã tồn tại để bỏ qua hoặc cập nhật lên bản mới nhất.

---

## 2. Danh sách toàn bộ ứng dụng & công cụ

Bộ công cụ đã tích hợp sẵn danh sách ứng dụng chuẩn xác của bạn:

| Nhóm | Ứng dụng & Định danh WinGet | Mô tả |
| :--- | :--- | :--- |
| **🌐 Trình duyệt** | • `Google.Chrome`<br>• `Mozilla.Firefox` | Trình duyệt web chính & phụ |
| **💻 Lập trình & Terminal** | • `Git.Git`<br>• `Microsoft.VisualStudioCode`<br>• `Microsoft.WindowsTerminal.Preview`<br>• `Starship.Starship`<br>• `OpenJS.NodeJS.LTS`<br>• `Docker.DockerCLI`<br>• `Docker.DockerCompose`<br>• `Termius.Termius`<br>• `Google.Antigravity` | Môi trường lập trình hoàn chỉnh: Git, VS Code, Node.js LTS, Docker, Terminal, SSH Client, Shell Prompt hiện đại |
| **🛠️ Tiện ích hệ thống** | • `Microsoft.PowerToys`<br>• `Tailscale.Tailscale`<br>• `voidtools.Everything`<br>• `Tonec.InternetDownloadManager`<br>• `nomacs.nomacs` | PowerToys, VPN Tailscale, tìm kiếm file siêu tốc Everything, IDM, trình xem ảnh nhẹ nomacs |
| **💬 Giao tiếp & Media** | • `Telegram.TelegramDesktop`<br>• `VNGCorp.Zalo`<br>• `OBSProject.OBSStudio`<br>• `ByteDance.CapCut`<br>• `Spotify.Spotify` | Telegram, Zalo PC, quay màn hình OBS, dựng video CapCut, nghe nhạc Spotify |
| **📦 Thư viện hệ thống** | • `Microsoft.VCRedist.2010.x86 / x64`<br>• `Microsoft.VCRedist.2015+.x86 / x64` | Visual C++ Redistributable đầy đủ giúp app chạy mượt mà, không báo lỗi thiếu `.dll` |

---

## 3. Hướng dẫn sử dụng nhanh (Quick Start)

Nếu bạn vừa cài lại Windows hoặc đang ở trên máy mới:

1. Bấm phím **`Windows + S`**, gõ **`PowerShell`**, bấm chuột phải chọn **`Run as Administrator`**.
2. Dán dòng lệnh sau và nhấn **Enter**:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
git clone https://github.com/bimm1010/dotfile.Win.git $HOME\dotfile.Win
cd $HOME\dotfile.Win
.\setup.ps1 -EnableWSL
```

> ☕ Sau đó bạn chỉ cần ngồi uống cà phê thư giãn. Script sẽ tự động chạy từ đầu đến cuối!

---

## 4. Hướng dẫn chi tiết theo từng kịch bản

### Kịch bản A: Thiết lập máy mới tinh / Vừa cài lại Windows
Đây là kịch bản chạy toàn diện nhất:
1. Mở **PowerShell** (quyền Administrator).
2. Tải repository về máy:
   ```powershell
   git clone https://github.com/bimm1010/dotfile.Win.git
   cd dotfile.Win
   ```
3. Chạy lệnh cài đặt toàn bộ:
   ```powershell
   .\setup.ps1 -EnableWSL
   ```
4. **Kết quả:** Toàn bộ app sẽ được tải và cài đặt nền (silent), các file config được copy vào đúng thư mục của hệ điều hành, tính năng ảo hóa được bật. Sau khi xong, hãy khởi động lại máy tính 1 lần.

---

### Kịch bản B: Chỉ đồng bộ lại cấu hình (Dotfiles)
Nếu bạn đã có sẵn các phần mềm và chỉ muốn cập nhật hoặc nạp lại cấu hình (Starship prompt, phím tắt Terminal, `.bashrc`, PowerShell profile, VS Code settings):

```powershell
cd dotfile.Win
.\setup.ps1 -SkipApps
```

Script sẽ bỏ qua phần tải cài app và chỉ khôi phục các file cấu hình trong vòng **2 giây**.

---

### Kịch bản C: Kích hoạt WSL & Docker ảo hóa
Để chạy được Docker Desktop, Kubernetes hoặc môi trường dòng lệnh Linux (Ubuntu) trên Windows:

```powershell
.\setup.ps1 -EnableWSL -SkipApps
```

Script sẽ tự động bật các tính năng tùy chọn của Windows:
- `Microsoft-Windows-Subsystem-Linux` (WSL)
- `VirtualMachinePlatform`

---

## 5. Bảng tham số tùy chọn của Script

File `setup.ps1` hỗ trợ các cờ lệnh linh hoạt:

| Tham số | Ý nghĩa | Ví dụ sử dụng |
| :--- | :--- | :--- |
| *(Mặc định)* | Cài đặt toàn bộ phần mềm + Nạp toàn bộ file cấu hình | `.\setup.ps1` |
| `-SkipApps` | Bỏ qua bước cài đặt phần mềm, chỉ nạp lại cấu hình Dotfiles | `.\setup.ps1 -SkipApps` |
| `-SkipConfigs` | Chỉ cài phần mềm, không đè các file cấu hình hiện có | `.\setup.ps1 -SkipConfigs` |
| `-EnableWSL` | Tự động kích hoạt WSL & Virtual Machine Platform (yêu cầu Admin) | `.\setup.ps1 -EnableWSL` |
| `-InstallScoop` | Cài đặt thêm Scoop (Package Manager độc lập cho lập trình viên) | `.\setup.ps1 -InstallScoop` |

*Bạn có thể kết hợp các tham số cùng lúc, ví dụ:*
```powershell
.\setup.ps1 -SkipApps -EnableWSL
```

---

## 6. Cấu trúc thư mục dự án

```text
dotfile.Win/
├── setup.ps1                                # 🚀 Kịch bản chính điều phối toàn bộ quá trình
├── README.md                                # 📖 Tài liệu hướng dẫn sử dụng chi tiết
├── configs/                                 # 📂 Thư mục chứa các file cấu hình cá nhân (Dotfiles)
│   ├── starship.toml                        # Cấu hình thanh Prompt Starship (icon, màu sắc, nhánh git)
│   ├── .bashrc                              # Cấu hình Git Bash: alias 'her', 'ag', 'agy' & nạp starship
│   ├── Microsoft.PowerShell_profile.ps1     # Profile cho Windows PowerShell & PowerShell 7
│   ├── terminal-settings.json               # Cấu hình Windows Terminal (Git Bash mặc định, phím tắt)
│   └── vscode-settings.json                 # Cài đặt VS Code (Unicode highlight, Terminal profile)
└── manifests/                               # 📂 Thư mục chứa danh sách gói phần mềm
    ├── app-list.json                        # Danh mục phần mềm phân loại rõ ràng (dễ chỉnh sửa)
    └── winget-packages.json                 # Manifest xuất chuẩn từ WinGet
```

---

## 7. Hướng dẫn tùy biến & thêm phần mềm mới

### Cách thêm một phần mềm mới vào danh sách cài đặt:
1. Mở file [`manifests/app-list.json`](file:///C:/Users/bimm/.gemini/antigravity/scratch/dotfiles-windows/manifests/app-list.json).
2. Tra cứu ID của phần mềm bằng lệnh:
   ```powershell
   winget search "tên phần mềm"
   ```
3. Thêm một đối tượng vào danh mục phù hợp trong `app-list.json`. Ví dụ thêm Notepad++:
   ```json
   { "name": "Notepad++", "winget_id": "Notepad++.Notepad++" }
   ```
4. Lưu file, commit và push lên GitHub để lưu lại:
   ```bash
   git add manifests/app-list.json
   git commit -m "feat: add Notepad++ to app list"
   git push
   ```

### Cách cập nhật cấu hình cá nhân (Dotfiles):
Khi bạn thay đổi cấu hình Starship (`~/.config/starship.toml`) hoặc `.bashrc`:
1. Copy file đã chỉnh sửa vào thư mục `configs/`.
2. Đẩy lên GitHub:
   ```bash
   git add configs/
   git commit -m "update: refresh prompt settings"
   git push
   ```

---

## 8. Xử lý sự cố thường gặp (Troubleshooting)

### Lỗi 1: `cannot be loaded because running scripts is disabled on this system`
* **Nguyên nhân:** Windows chặn thực thi file `.ps1` theo mặc định.
* **Cách khắc phục:** Chạy lệnh sau trong PowerShell trước khi thực thi script:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
  ```

### Lỗi 2: Lệnh `winget` không nhận diện (`The term 'winget' is not recognized...`)
* **Nguyên nhân:** Windows phiên bản cũ hoặc chưa kích hoạt ứng dụng *App Installer*.
* **Cách khắc phục:** Mở **Microsoft Store**, tìm kiếm và cập nhật ứng dụng **App Installer**, hoặc tải file `.msixbundle` từ [Releases chính thức của Winget CLI](https://github.com/microsoft/winget-cli/releases).

### Lỗi 3: Không thể bật WSL (`Enable-WindowsOptionalFeature`)
* **Nguyên nhân:** Thiếu quyền Administrator.
* **Cách khắc phục:** Hãy chắc chắn mở PowerShell bằng tùy chọn **Run as Administrator**.

---

## 👤 Tác giả

* **Repository:** [https://github.com/bimm1010/dotfile.Win.git](https://github.com/bimm1010/dotfile.Win.git)  
* **Tác giả:** [bimm1010](https://github.com/bimm1010)  
* **Cảm hứng & Triết lý:** [Vũ Nguyễn Coder](https://www.youtube.com/@VuNguyenCoder)
