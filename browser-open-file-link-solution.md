# Browser 開啟 `file://` 連結解法整理

## 結論

一般網頁中的 HTML / JavaScript 不能直接突破瀏覽器安全限制去開啟或讀取 `file://` 本機檔案連結。這個限制和前端框架無關，使用 Vue 2、Angular、純 HTML 或 ASP.NET MVC View 都一樣會受限。

如果系統需要讓使用者從網頁點擊檔案連結，建議優先改成後端代理下載或預覽；若必須保留 `file://` 連結，則可評估自製 Chrome / Edge extension，搭配使用者或企業政策授權。

## 為什麼不能直接用 JavaScript 解決

- 現代瀏覽器會阻擋網頁任意存取本機檔案，避免惡意網站讀取使用者電腦內容。
- `file://` 和 `http://` / `https://` 屬於不同安全模型，不能由一般網頁任意操作。
- JavaScript 無法要求瀏覽器切換 IE mode，也不能強制 Edge 用 IE mode 開啟特定連結。
- Vue 2、Angular 只是前端框架，無法改變瀏覽器底層安全政策。

## 可行方案比較

| 方案 | 適用情境 | 優點 | 限制 |
| --- | --- | --- | --- |
| ASP.NET MVC 後端串流 | 檔案在伺服器、NAS 或後端可存取位置 | 安全、標準、不需使用者安裝額外工具 | 後端服務帳號必須有檔案存取權 |
| 本機或內網 Web Server | 檔案可由 IIS / Nginx / Node.js 對外提供 | 前端只需改成 `http://` / `https://` URL | 需維護 Web Server 與權限控管 |
| Browser Extension | 必須保留 `file://` 連結，且使用者可安裝擴充功能 | Chrome / Edge 可共用，改動較小 | 每台電腦需安裝與授權 |
| Electron / Tauri 桌面化 | 系統需要大量本機檔案操作 | 權限與體驗最接近桌面程式 | 需重新包裝與部署桌面應用 |
| IE mode / 企業原則 | 舊系統依賴 IE 專屬功能 | 可延續舊系統相容性 | 不適合作為新功能主要方案 |

## 建議優先順序

1. **後端串流檔案**：最適合企業內部系統，權限集中在後端控管。
2. **將檔案轉成 HTTP/HTTPS 資源**：適合檔案本來就在共享目錄或檔案服務器。
3. **自製 Browser Extension**：適合既有系統已大量使用 `file://`，短期不易重構。
4. **桌面化包裝**：適合系統定位已接近本機工具，而不是一般網站。

## ASP.NET MVC 後端串流範例

前端不要直接連到 `file:///C:/data/report.pdf`，改連後端 Controller：

```html
<a href="/File/Download?fileName=report.pdf" target="_blank">下載/預覽檔案</a>
```

Controller 由白名單目錄讀檔並回傳：

```csharp
public class FileController : Controller
{
    public ActionResult Download(string fileName)
    {
        var basePath = @"C:\data";
        var filePath = Path.Combine(basePath, fileName);

        if (!System.IO.File.Exists(filePath))
        {
            return HttpNotFound();
        }

        var contentType = MimeMapping.GetMimeMapping(filePath);
        return File(filePath, contentType, fileName);
    }
}
```

實作時務必加上路徑白名單、檔名檢查、權限檢查，避免使用者用 `../` 或絕對路徑讀到不該讀的檔案。

## 自製 Chrome / Edge Extension

Chrome 和 Microsoft Edge 都是 Chromium extension 架構，Manifest V3 的基本寫法可共用，程式碼中使用 `chrome.runtime`、`chrome.tabs` 即可，不需要改成 `edge.*`。

### 檔案結構

```text
local-file-opener/
  manifest.json
  content.js
  background.js
```

### `manifest.json`

`matches` 請限制在公司內部系統網址，不要開放到所有網站。

```json
{
  "manifest_version": 3,
  "name": "企業專用本機檔案開啟器",
  "version": "1.0.0",
  "description": "允許指定內部系統開啟 file:// 連結",
  "permissions": ["tabs"],
  "background": {
    "service_worker": "background.js"
  },
  "content_scripts": [
    {
      "matches": ["https://intranet.example.com/*"],
      "js": ["content.js"],
      "run_at": "document_start"
    }
  ]
}
```

### `content.js`

```javascript
document.addEventListener(
  "click",
  function (event) {
    const anchor = event.target.closest("a");

    if (!anchor || !anchor.href.startsWith("file://")) {
      return;
    }

    event.preventDefault();
    chrome.runtime.sendMessage({
      action: "openFileUrl",
      url: anchor.href
    });
  },
  true
);
```

### `background.js`

```javascript
chrome.runtime.onMessage.addListener((message) => {
  if (message.action !== "openFileUrl") {
    return;
  }

  chrome.tabs.create({ url: message.url });
});
```

## 安裝與測試

### Chrome

1. 開啟 `chrome://extensions/`。
2. 啟用「開發人員模式」。
3. 點選「載入未封裝項目」。
4. 選擇 extension 資料夾。
5. 進入 extension 詳細資料，啟用「允許存取檔案網址」。

### Edge

1. 開啟 `edge://extensions/`。
2. 啟用「開發人員模式」。
3. 點選「載入解壓縮」。
4. 選擇 extension 資料夾。
5. 進入 extension 詳細資料，啟用「允許存取檔案網址」。

## 企業部署注意事項

- 建議由 IT 統一管理 extension 安裝與更新，避免每台電腦手動設定。
- 可透過 Chrome / Edge 企業原則部署 extension 與限制可執行網站。
- extension 的 `matches` 應限制為內部系統網域。
- 不要使用 `<all_urls>`，除非有完整風險評估。
- 即使使用 extension，也應避免讓網頁產生任意 `file://` 路徑。
- 若檔案路徑來自資料庫或使用者輸入，需要做白名單與格式驗證。

## 選型建議

如果檔案位於伺服器或 NAS，優先使用 MVC 後端串流或轉成 HTTP/HTTPS 檔案服務。這是長期最穩定、最容易稽核的做法。

如果現有內部系統已經大量產生 `file://` 連結，短期可用自製 Chrome / Edge extension 補上開啟能力，但要限制適用網站並由 IT 控管部署。

如果需求是開啟本機 Word、Excel、PDF 或特定程式，且未來會有更多本機整合，應評估 Electron / Tauri 或既有桌面程式整合，而不是把所有本機操作都塞進一般網站。
