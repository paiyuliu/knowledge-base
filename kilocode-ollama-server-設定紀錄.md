# Kilo Code 連接 Ollama Server 設定紀錄

日期：2026-08-13

目標：將已安裝的 `kilocode` CLI 設定為連接 Ollama server：

```text
http://172.18.13.114:11434
```

## 1. 確認 kilocode 安裝位置

先確認 `kilocode` 指令是否存在：

```powershell
Get-Command kilocode -ErrorAction SilentlyContinue | Format-List *
```

結果顯示 `kilocode` 是全域 CLI，入口位於：

```text
D:\u09889\Download\node-v24.13.0-win-x64\kilocode.ps1
```

實際執行的 Node script：

```text
D:\u09889\Download\node-v24.13.0-win-x64\node_modules\@kilocode\cli\bin\kilo
```

套件版本：

```text
@kilocode/cli 7.4.21
```

## 2. 查詢 Ollama Server 可用模型

用 Ollama API 查詢模型清單：

```powershell
Invoke-RestMethod -Uri http://172.18.13.114:11434/api/tags -TimeoutSec 10 |
  ConvertTo-Json -Depth 8
```

查到的模型：

```text
qwen3-coder:30b
qwen3-vl:8b
minicpm-v:latest
glm-ocr:latest
gemma4:e4b
```

其中 `qwen3-coder:30b` 適合作為 coding agent 預設模型，因此設定為 Kilo 預設模型。

## 3. 設定 Kilo 全域設定檔

Kilo 全域設定檔位置：

```text
C:\Users\u09889\.config\kilo\kilo.jsonc
```

原本內容只有 schema：

```json
{
  "$schema": "https://app.kilo.ai/config.json"
}
```

更新後內容：

```json
{
  "$schema": "https://app.kilo.ai/config.json",
  "model": "ollama/qwen3-coder:30b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (172.18.13.114)",
      "options": {
        "baseURL": "http://172.18.13.114:11434/v1"
      },
      "models": {
        "qwen3-coder:30b": {
          "name": "qwen3-coder:30b",
          "limit": {
            "context": 32768,
            "output": 8192
          }
        },
        "qwen3-vl:8b": {
          "name": "qwen3-vl:8b"
        },
        "minicpm-v:latest": {
          "name": "minicpm-v:latest"
        },
        "glm-ocr:latest": {
          "name": "glm-ocr:latest"
        },
        "gemma4:e4b": {
          "name": "gemma4:e4b"
        }
      }
    }
  }
}
```

重點：

- Provider ID：`ollama`
- OpenAI-compatible endpoint：`http://172.18.13.114:11434/v1`
- 預設模型：`ollama/qwen3-coder:30b`

## 4. 安裝 OpenAI-compatible Provider 套件

Kilo/OpenCode 的 Ollama 設定需要 `@ai-sdk/openai-compatible`。

在 Kilo 設定目錄安裝：

```powershell
cd C:\Users\u09889\.config\kilo
npm install @ai-sdk/openai-compatible
```

安裝結果：

```text
added 7 packages
found 0 vulnerabilities
```

注意：npm 顯示一個 `EBADENGINE` warning，原因是目前 Node.js 版本為 `v24.13.0`，其中一個相依套件偏好 `^24.15.0` 或更新版本。套件仍已成功安裝。

## 5. 驗證 Ollama OpenAI-compatible Endpoint

測試 `/v1/chat/completions`：

```powershell
$body = @{
  model = 'qwen3-coder:30b'
  messages = @(
    @{
      role = 'user'
      content = 'reply with OK only'
    }
  )
  stream = $false
} | ConvertTo-Json -Depth 6

Invoke-RestMethod `
  -Uri http://172.18.13.114:11434/v1/chat/completions `
  -Method Post `
  -Body $body `
  -ContentType 'application/json' `
  -TimeoutSec 60 |
  ConvertTo-Json -Depth 8
```

回覆成功：

```json
{
  "model": "qwen3-coder:30b",
  "choices": [
    {
      "message": {
        "role": "assistant",
        "content": "OK"
      },
      "finish_reason": "stop"
    }
  ]
}
```

## 6. 遇到的 Kilo CLI Windows 啟動問題

直接執行：

```powershell
kilocode --version
```

會出現錯誤：

```text
EEXIST: file already exists, mkdir 'C:\Users\u09889\.config\kilo'
```

這表示目前 `@kilocode/cli 7.4.21` 的 Windows binary 在設定目錄已存在時仍嘗試建立同名資料夾，造成啟動失敗。

測試結果：

- `KILO_CONFIG='C:\Users\u09889\.config\kilo\kilo.jsonc'` 仍會觸發同樣錯誤。
- `KILO_CONFIG_CONTENT` 可以正常啟動。

因此用 `KILO_CONFIG_CONTENT` 作為暫時 workaround。

## 7. 建立啟動腳本

在目前筆記目錄建立：

```text
D:\01 TASK\WORK_REPORT\UMEC\技術筆記\kilocode-ollama.ps1
```

內容：

```powershell
$configPath = "C:\Users\u09889\.config\kilo\kilo.jsonc"

if (-not (Test-Path -LiteralPath $configPath)) {
  throw "Kilo config not found: $configPath"
}

$env:KILO_CONFIG_CONTENT = Get-Content -Raw -LiteralPath $configPath
kilocode @args
```

之後要啟動 Kilo，建議使用：

```powershell
.\kilocode-ollama.ps1
```

確認 wrapper 可用：

```powershell
.\kilocode-ollama.ps1 --version
```

結果：

```text
7.4.21
```

## 8. 設定檢查

用 workaround 執行 Kilo 設定檢查：

```powershell
$env:KILO_CONFIG_CONTENT = Get-Content -Raw C:\Users\u09889\.config\kilo\kilo.jsonc
kilocode config check
```

結果：

```text
No config warnings.
```

## 9. 目前結論

Kilo 已設定為連接 Ollama server：

```text
http://172.18.13.114:11434/v1
```

預設模型為：

```text
ollama/qwen3-coder:30b
```

因為目前 Windows 版 `@kilocode/cli 7.4.21` 有設定目錄 `EEXIST` 啟動問題，暫時使用以下指令啟動：

```powershell
.\kilocode-ollama.ps1
```

後續若更新 Kilo CLI 後修正此問題，可以再改回直接使用：

```powershell
kilocode
```
