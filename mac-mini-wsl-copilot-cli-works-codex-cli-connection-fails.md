# Mac mini 與 WSL：Copilot CLI 可用、Codex CLI 連線失敗的排查紀錄

這份筆記的核心問題是：Mac mini 上 Copilot CLI 可以使用，但 Codex CLI 連線失敗；同事的 WSL 環境也出現類似情況。先前 Mac mini 的處理經驗指向 Fortinet 憑證設定，因此想請 Agent CLI 協助排查 WSL 中 Codex CLI 的連線問題。下方保留當時從 Windows／WSL 操作方式開始的問答紀錄；其中的原因與解法仍須依實際錯誤訊息驗證。

> From: https://www.google.com/search?atvm=2&source=hp&sxsrf=APpeQnvT2OwRaNhUnO0X8aZlqsZ4ZY1ArQ%3A1792374462270&mstk=AUtExfBWhJKZYBaaipTqTlgXUhW-PF97l9pXnY9iMQg1sQc-pTAQ3xJySTLyQR9D29cDeQGaH-DDGbBqaaEtJfo4fMO_QssB5m_XJ20ZaOSvkDHcHfFn3TcF14cKIkeZ_mGCI9F9GR81ZPNgZGQLoQk4TEmx-dueQ43CpT9aW2I4tfRaSRgGqh78f9sB4-X3scX66tlzJ_gBGRAMEK03buLJx8S1EYdwRudGIGf3TT4Svay3CFXFwHJgY7cG1d0p6MlTsE3lXp7Uuqz8cU_EBGnYBBtJsPpSYTdMbR33f8reRQgcW2Kj9OOaDbM4d3YAeW78jGa6A5EYJcddUg&mtid=wX7NatHBC_a6vr0PmMCf0A8&csuir=1&aep=26&q=%E5%9C%A8+windows+%E4%B8%8B+codex+cli+or+github+copilot+cli+%E5%8F%AF%E4%BB%A5%E9%80%B2%E5%85%A5+WSL+%E6%93%8D%E4%BD%9C+COMMAND+%E5%97%8E&ved=0CAEQ2_wOahgKEwjg9pKx-8SXAxUAAAAAHQAAAAAQhw0&udm=50

# you asked

message time: 2026年10月13日

在 windows 下 codex cli or github copilot cli 可以進入 WSL 操作 COMMAND 嗎

---

# googlesearch response

可以。在 Windows 下，無論是 **Codex CLI** 還是 **GitHub Copilot CLI**，都可以直接在 **WSL (Windows Subsystem for Linux)** 環境中安裝並操作指令。

運作與安裝重點：

-   **環境是分開的**：Windows（如 PowerShell / CMD）與 WSL 內部的 Linux 檔案系統是兩個獨立的環境。你在 Windows 裝的 CLI，預設不能直接在 WSL 裡面呼叫，反之亦然，因此**建議直接在 WSL 裡面用 npm 安裝**。
-   **Codex CLI 在 WSL 中的使用**：
    -   可以在 PowerShell 先下 `wsl` 進入 Linux，或是直接打開 WSL 終端機（如 Ubuntu）。
    -   在 WSL 內安裝 Node.js 後，透過 `npm install -g @openai/codex` 進行安裝。
    -   啟動與操作：直接在 WSL 內輸入 `codex` 或指定專案路徑執行。
-   **GitHub Copilot CLI 在 WSL 中的使用**：
    -   在 WSL 終端機內安裝並登入 GitHub 帳號（`/login`）後，即可直接在 Linux 專案目錄下執行指令、產生或偵錯代碼。
    -   實務上在 WSL 裡跑 CLI 往往比在原生 Windows PowerShell 遭遇更少的權限或路徑轉譯問題。

如果你需要：

-   **WSL 內的完整安裝與登入步驟**
-   **如何處理 API key 或跨 Windows / WSL 檔案路徑問題**

可以告訴我你想先安裝哪一個（Codex 或 Copilot），我可以提供詳細指令。

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多

---

# you asked

message time: 2026年10月13日

我指得不是在 WSL 啟動 codex cli or github copilot cli ,而是在 windows 下啟動,但在外層進入 WSL

---

# googlesearch response

這點**做不到**。如果是在 Windows（PowerShell / CMD）下直接啟動 Windows 版的 **Codex CLI** 或 **GitHub Copilot CLI**，它們**無法直接穿透、並在作業中「自動外掛」或控制 WSL 內部的 Linux 子系統指令**。

這是因為：

1.  **環境上下文受限**：當你在 Windows 環境啟動這些 CLI 工具時，其底層觸發的 Shell 執行器（Shell Runner）是 Windows 的系統環境（PowerShell 或 CMD）。
2.  **AI 工具的局限性**：AI CLI（如 Copilot CLI 或 Codex CLI）本身不具備「自動將產生的 Linux 指令轉譯並主動投遞進 WSL」的跨系統封裝能力。

* * *

💡 雖然無法直接穿透，但有以下替代方案：

方案一：在 Windows CLI 中利用 `wsl` 前綴執行指令

不論是 GitHub Copilot CLI 的對話模式（或它的 Autopilot 模式），你可以在 Windows 端啟動它，但你在和它對話時，必須**明確要求它在所有產生的 Linux 指令前加上 `wsl` 前綴**，或者在工具直接執行指令時，透過內部 Shell 繞過去。

-   **舉例**：
    在 Windows PowerShell 啟動 `copilot`，詢問「如何檢查 WSL 裡的專案目錄空間？」
    AI 產生的指令必須是：

    powershell

    ```
    wsl df -h
    ```

    請謹慎使用程式碼。

    這樣一來，雖然 CLI 是在 Windows 跑，但它會藉由 Windows 內建的 `wsl.exe` 命令，把這段指令丟進預設的 WSL 中執行並回傳。

方案二：透過 VS Code / Windows Terminal 的整合（最推薦的體驗）

如果你希望在 Windows 桌面的舒適環境下工作，同時又能讓 AI CLI 直接操作 WSL 核心，最好的做法並非強行在 Windows CMD 裡跨過來，而是利用工具建立捷徑：

1.  **Windows Terminal 捷徑**：在 [Windows Terminal](https://superlevin.ifengyuan.tw/%E6%8A%8A-windows-terminal-%E8%AE%8A%E6%88%90%E4%BD%A0%E7%9A%84-ai-%E6%8C%87%E6%8F%AE%E4%B8%AD%E5%BF%83%EF%BC%9Agithub-copilot-cli-%E5%85%A8%E6%94%BB%E7%95%A5/) 設定一個 WSL 設定檔（Profile），並將啟動命令設為 `wsl -e copilot` 或 `wsl -e codex`。這樣你雖然是在 Windows 點擊圖示啟動，但開起來的瞬間就已經在外層包好 WSL 的 Linux 環境了。
2.  **VS Code 遠端開發**：使用 Windows 的 VS Code 搭配官方 [WSL 延伸模組](https://github.com/features/copilot/cli)。在 VS Code 的整合終端機裡，它會完美地將外層 Windows UI 與內層 WSL 終端機進行對接。此時你在 VS Code 終端機（其實就是 WSL 環境）下執行 `copilot`，它就能100% 完美操作所有 Linux 命令而不會出錯。

**總結來說：** 工具本身無法自動「從 Windows 呼叫並自動操作 WSL 內部」，你必須透過 Windows 的 `wsl <command>` 橋樑，或是直接利用終端機工具（如 Windows Terminal）在一開始就完成環境套殼。

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多

---

# you asked

message time: 2026年10月13日

那其實就是可以的意思吧!直接送命令進入 WSL 操作,因為我同事目前在 WSL 中 codex cli 有網路上的問題不能用,但在 windows 下操作正常

---

# googlesearch response

**如果是為了解決「WSL 網路壞掉、但 Windows 網路正常」的痛點，答案是：可以！這確實是一個非常聰明的繞路解法。**

在 Windows 的 PowerShell 裡執行 Windows 版的 `codex`，然後透過 `wsl` 命令強行把指令塞進 Linux 運作。不過在實際操作時，必須注意**路徑代換**與**權限**的細節。

以下為你整理你同事最需要的**「跨界操作生存指南」**：

🎯 實際操作方式（以 Codex CLI 為例）

當你在 Windows PowerShell 啟動 Windows Native 的 Codex CLI 後，在對話中**不要**直接說：「幫我建立一個資料夾並初始化 git」，因為它預設會去呼叫 Windows 的 `mkdir` 和 `cmd`。

你必須像這樣下指令給它：

```text
🗣️ 對話範例：「幫我列出 wsl 裡 /home/user/project 下的檔案」「幫我在 wsl 裡執行 npm run build，路徑在 /home/user/project」
```

AI 就會自動產生帶有 `wsl` 前綴的命令並在 Windows 下呼叫，例如：

```powershell
wsl cd /home/user/project && npm run build
```

請謹慎使用程式碼。

由於連線（呼叫 OpenAI API）是在 Windows 端完成（網路正常），而實際命令是透過 Windows 拋進 WSL 執行，因此能完美避開 WSL 裡面的網路死穴。

* * *

⚠️ 這樣玩會遇到的 2 個小坑（請提醒同事）

1.  **路徑轉譯問題（最常踩的坑）**
    如果是在 Windows 下啟動 Codex，它可能「自作聰明」以為你的專案在 `C:\Users\...`。如果專案原本就放在 WSL 裡面（例如 `\\wsl.localhost\Ubuntu\home\...`），Windows 版的 Codex 往往會因為讀不懂 Linux 原生路徑而報錯（例如出現 `os error 2 / No such file or directory`）。
    -   **解法**：在 Windows 啟動 Codex 時，終端機路徑最好切換到 Windows 掛載 WSL 的硬碟路徑下（例如 `cd \\wsl.localhost\Ubuntu\home\你的帳號\專案`）。
2.  **檔案權限與換行符號 (CRLF / LF)**
    透過 Windows 呼叫 `wsl` 去建立或修改 Linux 檔案時，有時候 Windows 的 Codex 會不小心把檔案寫成 Windows 的 `CRLF` 換行格式，導致 Linux 腳本無法執行。

* * *

💡 終極根治法：為什麼他的 WSL 網路會斷？

你同事遇到的是目前 Windows + WSL 最著名的**「網路與 VPN 衝突殺手」**。因為 WSL2 預設是用虛擬網卡（NAT 模式），只要 Windows 開了公司 VPN、防毒軟體或特定代理，WSL2 內部的連線就會全部被斷掉，導致 Codex CLI 連不上伺服器。

如果他想修好 WSL 內的網路，不需要重裝，只需要在 Windows 開啟 `cmd` 執行以下修正：

1.  在 Windows 的使用者資料夾（例如 `C:\Users\你的使用者名稱\`）下面，建立或編輯一個名為 **`.wslconfig`** 的檔案。
2.  把內容改成 **鏡像網路模式（Mirrored Mode）**，這會讓 WSL 直接共享 Windows 的網路和 VPN 狀態：

    ini

    ```
    [wsl2]
    networkingMode=mirrored
    dnsTunneling=true
    firewall=true
    autoProxy=true
    ```

    請謹慎使用程式碼。

3.  存檔後，在 Windows PowerShell 輸入：

    powershell

    ```
    wsl --shutdown
    ```

    請謹慎使用程式碼。

    重新打開 WSL 終端機，他的 WSL 網路大概就 90% 恢復正常了，這時候就可以直接在 WSL 裡快樂使用 Codex CLI 了！

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多

---

# you asked

message time: 2026年10月13日

我是想請 agent cli 去排除這部份的問題,因為 github copilot cli 在 WSL 下也正常使用,就 codex cli 不行,先前在 MAC MINI 也遇過一樣的問題,似乎是被 fortinet 擋下來,當時 github copilot 的解決方式似乎是去下載憑證然後做了一些設定 codex cli 就可以用了!有這個議題嗎?

---

# googlesearch response

你抓到最關鍵的核心了！這在企業網路環境中是一個非常經典的**中間人截取（SSL/TLS Deep Inspection）**議題。

你提到的 [Fortinet (FortiGate) 設備](https://community.fortinet.com/fortigate-3/technical-tip-creating-and-installing-a-private-ca-certificate-for-deep-inspection-using-openssl-commands-225581)，在多數公司內部都會開啟「SSL 深層檢查」。它會把傳往 GitHub 或 OpenAI 的流量攔截，並用公司內部的**私有憑證（Custom CA Certificate）**重新加密封包。

這就是為什麼 Windows 正常，但 WSL 內會壞掉的原因：**Windows 系統已經預先安裝了公司的根憑證，但 WSL 裡面的 Linux 系統（Ubuntu）並沒有這個憑證**，導致連線時被 Linux 視為安全性錯誤（自簽名憑證無效）而直接阻斷。

此外，這兩個工具的底層邏輯截然不同，這也是為什麼 Copilot 設定完能用、但 Codex 不行的主因：

🛠️ 核心差異：為什麼 GitHub Copilot CLI 可以，Codex CLI 不行？

1.  **GitHub Copilot CLI（基於 Node.js）**：
    Copilot CLI 底層是 Node.js 寫的。Node.js 官方有一個專屬的環境變數叫 `NODE_EXTRA_CA_CERTS`。當初你在 Mac Mini 或是其他地方，只要把公司的 Fortinet 憑證（`.pem` 或 `.crt` 檔）下載下來，並在環境變數指向它，Node.js 就能順利讀取並放行。
2.  **Codex CLI（基於 Rust）**：
    這是最致命的盲點——**最新版本的 Codex CLI 底層核心是用 Rust 語言編寫的，並使用 `reqwest` 作為 HTTP 請求客戶端**。這意味著它**完全不理會 Node.js 的 `NODE_EXTRA_CA_CERTS` 變數**！你就算在 WSL 裡設定了，Codex 依然會直接噴出 TLS 憑證連線錯誤。

* * *

💡 解決方案：如何在 WSL 內徹底排除 Codex CLI 的憑證問題？

要解決 Codex CLI 在 WSL 內的 Fortinet 憑證阻擋，必須直接將憑證註冊到 **Linux 系統層級的信任庫（OS Trust Store）** 中，讓 Rust 核心去抓取。請讓你同事在 WSL 內依序執行以下步驟：

第一步：從 Windows 匯出或複製 Fortinet 憑證

因為 Windows 下操作正常，代表 Windows 的憑證庫裡已經有該憑證。

1.  在 Windows 搜尋「管理電腦憑證」（`certlm.msc`）。
2.  在「受信任的根憑證授權單位」>「憑證」中，找到公司 Fortinet 的憑證。
3.  按右鍵 -> 所有工作 -> 匯出，選擇 **Base-64 加密 X.509 (.CER)** 格式，存成 `fortinet.crt`。
4.  把這個檔案複製到 WSL 裡面（例如放進 `/home/你的帳號/fortinet.crt`）。

第二步：將憑證導入 WSL (Ubuntu) 系統信任庫

打開 WSL 終端機，執行以下指令將憑證塞進 Linux 系統：

```bash
# 1. 將憑證複製到 Ubuntu 的證書目錄
sudo cp /home/你的帳號/fortinet.crt /usr/local/share/ca-certificates/fortinet.crt

# 2. 更新 Linux 系統的憑證信任庫
sudo update-ca-certificates
```

請謹慎使用程式碼。

_成功後，終端機會顯示 `1 added, 0 removed` 之類的提示。_

第三步：針對 Codex CLI 額外宣告（保險設定）

有些版本的 Rust 執行檔會去讀 Linux 的 OpenSSL 標準路徑，請在 WSL 的 `~/.bashrc` 或 `~/.zshrc` 檔案底部加上這幾行，確保萬無一失：

```bash
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_DIR=/etc/ssl/certs
```

請謹慎使用程式碼。

存檔後執行 `source ~/.bashrc` 重新整理。

此時再回到 WSL 裡面輸入 `codex`，它就能像 Windows 下一樣，繞過 Fortinet 的防火牆阻擋順利連線了！這個方法同時也能根治未來其他非 Node.js 寫的 Agent CLI（如基於 Go 或 Rust 的 AI 工具）在 WSL 裡遇到的網路阻礙。

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多
