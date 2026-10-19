> From: https://gemini.google.com/app/ab3950fcdb033fba?hl=zh-TW

# you asked

message time: 2026-08-06 13:08:29

說明如何安裝 Hermes CLI

---

# gemini response

根據 [hermes-agent GitHub 頁面](https://github.com/nousresearch/hermes-agent) 的說明，安裝 **Hermes Agent / CLI** 非常簡單，不同作業系統的安裝方式如下：

---

## 1. Linux / macOS / WSL2 / Termux (Android)

開啟終端機（Terminal）並執行以下一鍵安裝指令：

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

安完成後，請重新載入 Shell 設定檔（或重新開啟終端機）：

```bash
source ~/.bashrc   # 若使用 zsh 則為 source ~/.zshrc
```

---

## 2. Windows (原生 PowerShell)

Hermes 支持原生 Windows 環境，無需強制安裝 WSL。開啟 **PowerShell** 並執行：

```powershell
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
```

> **說明：**
> * 安裝程式會自動處理所有相依套件，包括 `uv`、Python 3.11、Node.js、ripgrep、ffmpeg 以及獨立的可攜式 Git Bash (MinGit)。
> * 若偏好使用 Linux 環境，亦可在 Windows 的 WSL2 中執行上方 Linux 版的安裝指令。

---

## 3. 啟動與常用指令

安裝完成後，即可直接在終端機或命令提示字元中輸入：

* **開始對話（啟動 CLI）**：
  ```bash
  hermes
  ```
* **首次設定嚮導（一鍵配置模型與工具）**：
  ```bash
  hermes setup
  ```
* **選擇 LLM 模型與提供者**：
  ```bash
  hermes model
  ```
* **檢查安裝與系統狀態**：
  ```bash
  hermes doctor
  ```
* **更新至最新版本**：
  ```bash
  hermes update
  ```

---

# you asked

message time: 2026-08-06 13:09:41

我希望是 portable 架構，並且安裝在 d:/ ，而且我已經有 uv 和 node 了

---

# gemini response

若你希望以 **Portable (可攜式) 架構** 將 Hermes Agent 安裝在 **`D:\` 磁碟機**，且善用你**現有的 `uv` 與 `Node.js`**，請參考以下手動與客製化安裝步驟：

---

## 1. 設定環境變數 (指定 Portable 路徑)

Hermes 預設會將設定與主程式存放在 `%LOCALAPPDATA%\hermes` 或 `~/.hermes`。若要指定為全可攜式並存放於 `D:\`，需在安裝前設定環境變數：

在 PowerShell 執行：
```powershell
$env:HERMES_HOME = "D:\Hermes"
$env:PATH = "$env:HERMES_HOME\bin;" + $env:PATH
```

> **提示**：若希望未來每次開啟 PowerShell 或 CMD 都能自動抓到該路徑，可將 `HERMES_HOME` 設定為系統或使用者環境變數（值設為 `D:\Hermes`）。

---

## 2. 使用手動方式 Git Clone 專案至 D 槽

由於官方一鍵指令會下載預設元件，自行掌握 Portable 架構最乾淨的方式是手動 Clone 專案：

```powershell
# 建立目標資料夾並切換
New-Item -ItemType Directory -Force -Path "D:\Hermes"
cd D:\Hermes

# 下載 GitHub 專案
git clone https://github.com/nousresearch/hermes-agent.git D:\Hermes\hermes-agent
cd D:\Hermes\hermes-agent
```

---

## 3. 使用你現有的 `uv` 建立虛擬環境與安裝

因為你已經有 `uv`，可以直接在 `D:\Hermes` 下建立獨立的 Python 虛擬環境：

```powershell
# 1. 在 D:\Hermes\venv 建立 Python 3.11 虛擬環境
uv venv "D:\Hermes\venv" --python 3.11

# 2. 啟動該虛擬環境
D:\Hermes\venv\Scripts\Activate.ps1

# 3. 安裝 Hermes 及其相依套件 (包含可選套件)
uv pip install -e ".[all]"
```

---

## 4. 建立快捷啟動檔 (`hermes.bat`)

為了實現完美的 Portable 體驗，可以在 `D:\Hermes\` 目錄下建立一個批次檔 `hermes.bat`，未來直接點擊或在命令列執行即可：

建立檔案 `D:\Hermes\hermes.bat`，內容如下：

```bat
@echo off
set HERMES_HOME=D:\Hermes
set PATH=%HERMES_HOME%\venv\Scripts;%PATH%
call "%HERMES_HOME%\venv\Scripts\activate.bat"
python -m hermes %*
```

---

## 5. 開始使用

完成以上設定後，只要在 PowerShell / CMD 執行：

* **啟動對話 CLI**：
  ```powershell
  D:\Hermes\hermes.bat
  ```
* **初始化嚮導（設定模型與工具）**：
  ```powershell
  D:\Hermes\hermes.bat setup
  ```

---
Powered by [AI Exporter](https://saveai.net)