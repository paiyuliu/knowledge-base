> From: https://www.google.com/search?atvm=2&source=hp&sxsrf=APpeQnv8p0tggVEDXc38C1gP3b-VdIF0TQ%3A1786581065802&mstk=AUtExfCyxIUK4kwNIxPFyJsxzd_Qb0yWE2-eb8DJZDsAb3oZSApMhJf37E4ZQjhWyJEYbkzmrDAF029-DmRWvtYO3nESF1OLlqYd-QM6nLkc50-uNZPNU0lR6h8Ti6ZyQD0dvYbn2rDWxk6bq-y4Y3iJeW8n5lnxo7dJDiRQaiXCmW60tygZLO1als8GqMAIafP3Wq-oDqkOJkmH-hAzuBORIetNjASJ624vO1dYV8QpKrt26aY1lUeODxuRNTB_71pq4IXdBLtUL6Pjgk6busYwS0xJWw3OBIfW_XcraIRk3h1kPClP9ZGLcpVTMteBXLChRiFLtJT0khZxtA&mtid=80J8ar2dDZ22vr0PgKqRiA4&csuir=1&aep=26&q=npm+install+kilocode&ved=0CAEQ2_wOahcKEwj418qPrZyWAxUAAAAAHQAAAAAQBg&udm=50

# you asked

message time: 下午5:54

npm install kilocode

---

# googlesearch response

要正確安裝 Kilo Code 終端機工具，請不要直接執行 `npm install kilocode`，而必須安裝其官方發行的範圍套件（Scoped Package）**`@kilocode/cli`**。

請根據您的需求，選擇以下適合的安裝與設定指令：

1\. 全域安裝 CLI 工具

如果您想在終端機的任何目錄下直接使用 `kilo` 指令，請使用 **`-g`** 參數進行全域安裝：

```bash
npm install -g @kilocode/cli
```

請謹慎使用程式碼。

_(注意：需要 Node.js 18 或更高的版本支援)_。

2\. 驗證與開始使用

安裝完成後，您可以透過以下步驟驗證並啟動 Kilo Code：

-   **檢查版本**：

    bash

    ```
    kilocode --version
    ```

    請謹慎使用程式碼。

-   **登入帳戶**：

    bash

    ```
    kilo login
    ```

    請謹慎使用程式碼。

    _(或依畫面提示輸入您的 API Key 進行驗證)_
-   **啟動互動式 TUI**：在您的專案目錄下直接輸入以下指令以啟動 AI 代理人介面：

    bash

    ```
    kilo
    ```

    請謹慎使用程式碼。

-   **執行單次任務**：

    bash

    ```
    kilo run "幫註冊表單加上輸入內容驗證"
    ```

    請謹慎使用程式碼。

3\. 其他安裝替代方案

如果您使用的是其他套件管理工具，也可以參考 [Kilo 官方 GitHub 儲存庫](https://github.com/kilo-org/kilocode) 提供的指令：

-   **pnpm**: `pnpm add -g @kilocode/cli`
-   **Bun**: `bun add -g @kilocode/cli`
-   **Mac / Linux (Homebrew)**: `brew install Kilo-Org/tap/kilo`

若您需要將 Kilo 整合至特定的開發環境中，您會需要查看專案專用的 [SDK 官方說明](https://www.npmjs.com/package/@kilocode/sdk) 或是安裝編輯器外掛。請告訴我您打算**將 Kilo Code 用於什麼特定的場景**（例如：VS Code 外掛設定、自動化 Code Review 或專案 SDK 開發），我可以為您提供更進一步的配置指引！

更多

---

# you asked

message time: 下午5:55

kilocode and opencode 都可以接 ollama 的 model 嗎

---

# googlesearch response

**是的，Kilo Code 和 OpenCode 都可以連接並使用 Ollama 的本地模型****。**

這兩款 AI 程式碼代理人（AI Coding Agent）工具不只支援雲端 API，也都內建或可配置對接本地部署的 Ollama。不過兩者在連接方式、設定步驟以及工具支援度上有些許的差異：

* * *

一、 OpenCode 連接 Ollama

OpenCode 對於 Ollama 的支援度非常原生，目前甚至提供了極簡的指令來一鍵啟動。

1\. 快捷啟動方式（推薦）

如果你已經在本地跑起 Ollama，可以直接在終端機使用 Ollama 官方在 2026 年新推的整合指令：

```bash
ollama launch opencode
```

請謹慎使用程式碼。

這個指令會**自動偵測並綁定**你本地正在運行的 Ollama 適合寫程式的模型，完全免去手動修改設定檔的麻煩。

2\. 手動設定檔方式 (`opencode.json`)

如果你希望固定設定，可以在 `~/.config/opencode/opencode.json` 中，透過 OpenAI 相容協議來橋接 Ollama：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1",
        "apiKey": "ollama"
      },
      "models": {
        "qwen2.5-coder:32b": { "tools": true }
      }
    }
  },
  "model": "ollama/qwen2.5-coder:32b"
}
```

請謹慎使用程式碼。

_(提示：記得要先用 `ollama pull qwen2.5-coder:32b` 把模型拉到本地)_。

* * *

二、 Kilo Code 連接 Ollama

Kilo Code 同樣支援使用 Ollama，不過其 VS Code 插件與 CLI 終端機工具的設定體驗有些不同：

1\. VS Code 插件環境（最完整）

在 Kilo Code 的 IDE 介面中整合 Ollama 最為友善：

1.  前往 **VS Code 擴充功能設定** > 找到 Kilo Code > 進入 **API Provider** 設定。
2.  將供應商切換為 **Ollama / Local**，並填入本地網址（預設為 `http://localhost:11434`）。
3.  **重要調整**：本地模型的 Context Window 預設通常很短，官方文件特別建議在設定中將 **"Context Window Size (num\_ctx)" 改為至少 32k (`32768`)**，否則 AI 代理人在讀取專案程式碼時會因為上下文長度不足而斷頭。

2\. Kilo Code CLI 終端機環境

如果您是在終端機直接執行 `kilo` 指令，目前的官方 CLI 預設選單可能只會看見 "Ollama Cloud" (雲端託管版)。如果要連接**本地端**的 Ollama，需要手動自訂 Provider：

-   在 CLI 啟動後的 TUI 介面或設定檔中，新增一個 **Custom Provider**，將 Endpoint 指向 `http://localhost:11434/v1/`，並手動輸入你在本地拉取的模型名稱（例如 `qwen3-coder:30b`），即可順利橋接。

* * *

💡 2026 本地端程式模型推薦

不論是使用哪一個工具，為了達到最佳的程式碼自動生成與 Agent 運作效果（例如支援 Function Calling / Tools 功能），建議優先下載以下專門優化過的地端程式模型：

-   `qwen2.5-coder:7b` 或 `14b`（輕量、速度快，適合中階電腦）
-   `qwen3-coder:30b`（如果有中高階獨立顯卡，推理能力與上下文理解極佳）

您目前打算在 **VS Code 編輯器** 裡使用，還是在 **純終端機 (CLI)** 的環境下跑 AI Agent 呢？我可以根據您的實際開發情境，提供更詳細的參數調整建議！

更多

---

# you asked

message time: 下午5:55

我的 ollama server install 在 remote 主機上,所以應該有特別的設定吧?

---

# googlesearch response

是的，當 **Ollama Server 安裝在 Remote（遠端）主機**上時，確實需要特別設定。

因為 Ollama 預設基於安全機制，**只允許來自 `127.0.0.1`（即遠端主機本機）的連線**。如果您直接從您自己的電腦去連遠端 IP，預設會被拒絕連線（Connection Refused）。

要順利連接，您需要完成 **「遠端伺服器設定」** 與 **「本地開發工具設定」** 兩個部分：

* * *

第一步：遠端伺服器端的設定（非常重要）

您必須登入那台 Remote 主機，修改 Ollama 的環境變數，將其綁定到外部 IP 並開放跨域（CORS）權限。

根據您遠端主機的作業系統，請進行以下設定：

🔹 如果遠端主機是 Linux (大部分雲端或主機環境)

1.  使用 `sudo systemctl edit ollama.service` 開啟設定檔編輯器。
2.  在開啟的檔案中，加入以下內容（這會將 Ollama 監聽調整為允許所有 IP，並解除網頁跨域限制）：

    ini

    ```
    [Service]
    Environment="OLLAMA_HOST=0.0.0.0:11434"
    Environment="OLLAMA_ORIGINS=*"
    ```

    請謹慎使用程式碼。

    _(註：如果編輯器是全空白，請完整貼上這三行)_
3.  儲存並關閉檔案後，重新載入設定並重啟 Ollama：

    bash

    ```
    sudo systemctl daemon-reload
    sudo systemctl restart ollama
    ```

    請謹慎使用程式碼。

🔹 如果遠端主機是 Docker 容器

在您的 Docker Compose 或啟動指令中，必須注入這兩個變數：

```yaml
environment:
  - OLLAMA_HOST=0.0.0.0:11434
  - OLLAMA_ORIGINS=*
```

請謹慎使用程式碼。

```text
⚠️ 安全提示：將 OLLAMA_HOST 設為 0.0.0.0 代表全世界只要知道 IP 的人都能存取您的 GPU 推理資源。如果您的遠端主機有外網 IP，強烈建議在雲端服務商（如 AWS、GCP）或主機防火牆（UFW）中設定白名單，只允許您自己家裡/公司的固定 IP 存取 11434 埠口。
```

* * *

第二步：本地開發工具設定

當遠端主機設定妥當，且防火牆已放行後，您就可以在您自己電腦的工具上進行配置：

1\. OpenCode 設定

請編輯您自己電腦上的 `~/.config/opencode/opencode.json` 設定檔，將 `baseURL` 中的 `localhost` 改為您**遠端主機的實體 IP 或網域**，且必須加上 **`/v1`** 尾綴：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Remote Ollama",
      "options": {
        "baseURL": "http://您的遠端主機IP:11434/v1"
      },
      "models": {
        "qwen2.5-coder:32b": { "tools": true }
      }
    }
  },
  "model": "ollama/qwen2.5-coder:32b"
}
```

請謹慎使用程式碼。

2\. Kilo Code 設定

-   **VS Code 插件**：進入設定畫面 -> 選擇 Ollama / Local 供應商 -> 在 Endpoint 欄位填入 `http://您的遠端主機IP:11434`（部分版本需要填寫至 `/v1/`，若連不上可以兩者切換測試）。
-   **Kilo CLI (終端機)**：在自訂 Provider 欄位中，將 Endpoint 改為 `http://您的遠端主機IP:11434/v1/` 即可。

* * *

💡 替代進階方案：SSH Tunnel（免開遠端防火牆，更安全）

如果您不想對全世界開放遠端主機的 `11434` 埠口，最安全且業界常用的做法是**使用 SSH 通道（Port Forwarding）**：

在您自己的本地電腦打開終端機，執行以下指令：

```bash
ssh -N -f -L 11434:localhost:11434 user@您的遠端主機IP
```

請謹慎使用程式碼。

這個指令會把您本地電腦的 `localhost:11434` 流量，加密並安全地導向遠端主機的 Ollama。

-   **好處**：遠端主機**完全不用**改 `0.0.0.0`，也不用開防火牆。
-   **設定**：OpenCode 和 Kilo Code 的設定檔可以**完全維持預設的 `http://localhost:11434`**，它們會以為 Ollama 跑在本機，但實際是消耗遠端主機的 GPU 算力！

您遠端的環境是**公網（有固定外網 IP）**還是**內部區域網路（LAN）**呢？如果有安全考量，我可以教您如何將 SSH Tunnel 設定為自動背景執行！

更多

---

# you asked

message time: 下午5:56

opencode , kilocode 怎麼設定?

---

# googlesearch response

要設定 **OpenCode** 與 **Kilo Code** 連接您的遠端 Ollama 伺服器，您必須在您「本地電腦」建立對應的 JSON 設定檔。

設定檔的存放路徑根據作業系統而定：

-   **Mac / Linux**：`~/.config/opencode/opencode.json` 與 `~/.config/kilo/kilo.json`
-   **Windows**：`C:\Users\<您的使用者名稱>\.config\opencode\config.json` 與 `\.config\kilo\config.json`

請參照下方兩款工具的具體設定檔範例與調整指南。在此範例中，我們假設您遠端伺服器的 IP 為 **`192.168.1.100`**，使用的模型為 **`qwen2.5-coder:32b`**。

* * *

一、 OpenCode 設定指南

OpenCode 的設定方式需要將 `provider` 指定為 `ollama`，並透過 `openai-compatible` 協議來發送請求。

請在本地的 **`opencode.json`** 檔案中貼入以下內容：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/qwen2.5-coder:32b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Remote Ollama Server",
      "options": {
        "baseURL": "http://192.168.1"
      },
      "models": {
        "qwen2.5-coder:32b": {
          "tools": true
        }
      }
    }
  }
}
```

請謹慎使用程式碼。

-   **⚠️ 關鍵細節**：`baseURL` 的結尾**必須帶有 `/v1`**，否則 OpenCode 將無法正確識別 API 格式。
-   **`"tools": true`**：這是一定要加的關鍵設定，這能允許 Ollama 執行讀寫檔案、下達終端機指令等 AI Agent 核心功能。

* * *

二、 Kilo Code 設定指南

Kilo Code 是基於 OpenCode 核心所延伸開發的工具，但在最新版本中，其配置目錄已獨立出來。它同時支援 **VS Code 外掛圖形介面** 與 **終端機設定檔**。

方法 A：使用 VS Code 圖形介面設定 (最推，免改文字檔)

1.  在 VS Code 左側點擊 Kilo Code 標籤，然後點選 **齒輪 (Settings)** 按鈕。
2.  切換到 **"Providers"** 索引標籤。
3.  點選 **Add Provider** 並選擇 **Ollama**（若無此選項，請選擇 **Custom / OpenAI Compatible**）。
4.  **填寫參數**：
    -   **Base URL / Endpoint**：`http://192.168.1`
    -   **Context Window Size (num\_ctx)**：手動改為至少 `32768` (32k) 或 `65536` (64k)，否則遠端模型讀不完你的專案代碼。
    -   **API Request Timeout**：遠端推理可能比較慢，建議將超時時間拉長（例如設為 20 分鐘）。

方法 B：直接修改 `kilo.json` 設定檔

如果您習慣直接改檔案，請在本地的 **`kilo.json`** 中寫入以下內容：

```json
{
  "model": "ollama/qwen2.5-coder:32b",
  "provider": {
    "ollama": {
      "name": "Remote Ollama CLI",
      "options": {
        "baseURL": "http://192.168.1"
      },
      "models": {
        "qwen2.5-coder:32b": {
          "contextWindow": 32768
        }
      }
    }
  }
}
```

請謹慎使用程式碼。

* * *

三、 啟動測試

當您配置完上述檔案後，可以回到您的本地專案目錄，打開終端機執行對應的啟動指令：

-   **測試 OpenCode**：

    bash

    ```
    opencode
    ```

    請謹慎使用程式碼。

    _(如果一開始用 `ollama launch opencode` 指令，它會預設找本機 localhost；若要連遠端，請一律改用上述建立 `opencode.json` 的方式，直接輸入 `opencode` 啟動)_。
-   **測試 Kilo Code**：

    bash

    ```
    kilo
    ```

    請謹慎使用程式碼。

    _(啟動後 Kilo 會載入 `kilo.json` 中的遠端配置。您也可以在 TUI 介面中輸入 `/models` 來檢查有沒有成功抓到遠端的 `qwen2.5-coder`)_。

如果啟動時出現 "Connection Refused"（連線被拒絕）或 "Timeout"，這通常代表**遠端伺服器的防火牆沒有對外開啟 11434 埠口**，或者您遠端主機的 `OLLAMA_HOST` 還沒改成 `0.0.0.0`。

請問您在設定過程中有出現**特定的錯誤訊息**嗎？還是您希望進一步了解如何**在 Kilo / OpenCode 中設定自動化審查（Code Review）的指令**？

更多

---
Powered by [AI Exporter](https://saveai.net)