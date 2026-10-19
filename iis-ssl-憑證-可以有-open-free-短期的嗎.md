> From: https://www.google.com/search?q=iis+ssl+%E6%86%91%E8%AD%89+%E5%8F%AF%E4%BB%A5%E6%9C%89+open+free+%E7%9F%AD%E6%9C%9F%E7%9A%84%E5%97%8E%3F&sca_esv=9768f4bab40ae0e6&sxsrf=APpeQnuTMpIZ57_WKrEbiqFFtOh7ziDiUw%3A1787804261340&ei=VLqPasC-Aaedvr0Pt6WUqQI&iflsig=ABILxe8AAAAAao_IZKJqsa9Q3fY_y01cESqg0gSGLZkK&uact=5&sclient=gws-wiz&udm=50&fbs=ABfTbFUhNGvvPEUFOvrsPMHwBXgOBaujescnqPHvnnJ8fnHu1zuxi_oOvfp1roc7b9BNn1kv8xCFyvBpqxaLvoZL7kWhVKT8M9x-chdaRRG7vWr9oyXtkD2-vMZKJX9twq28NwYGv39njaeZDtL2vKiq94FETBPEz0yYgjl5vlsP8B-YsZIQpDXacmWkI98WPSVj5QN9652h&aep=10&ntc=1&mstk=AUtExfANXwtpNijcAbuBlVBESVErnPVYHuC-SmgUKGZtCi5OSetMHX8L80f9nawI5bDEKNeOIzgW6ppHNJNApYL6xD8omJaXlNfaKxDTnQfZKVr39t1pBwu1ZkO0gbsrwKLxuRCo6BNxWFYLUYWc4mNLXDLDZdCviNREXx5oRGFygd5OE7pfXcSzhpi8Hj3q8uoy0w8ts5UnEu80OsF8VhW8c_IehUac2X34mq9xEEHEdN9sLSffz6arzz_eSkWe-nl3UcHSMbIps3zYzNkf7GpFXxA4gmqS-NXsRoKWavwLrnSZgjO4gDKEQX4uDCGX-RLxeeJWKSK0PdCBTw&aioh=3&csuir=1&atvm=2&mtid=qrqPapvYLsj31e8P96fP0Qs

# you asked

iis ssl 憑證 可以有 open free 短期的嗎?

---

# googlesearch response

**可以，IIS 完全可以使用免費且短期的 SSL 憑證。** 目前全球最主流、完全開源且免費（Open & Free）的解決方案是 [Let's Encrypt](/url?sa=i&source=web&rct=j&url=https://letsencrypt.org/zh-tw/&ved=2ahUKEwihk7eQ-r-WAxUXdPUHHVYjKiQQy_kOeggIAggBCBwQAg&opi=89978449&cd&psig=AOvVaw2s5CJCW92FOWJyej-qec9c&ust=1787890730609000)。其簽發的憑證**有效期固定為 90 天**（短期憑證），但你可以透過自動化工具讓它**永久自動更新**，完全不需付費或手動介入。

以下為您整理在 Windows IIS 上部署免費短期憑證的最常見做法：

🛠️ 推薦使用的自動化工具

由於 IIS 本身沒有內建 Let's Encrypt 的直接申請介面，通常會搭配以下開源或免費的用戶端工具來達成「一鍵安裝 + 自動排程更新」：

1.  **win-acme（最熱門、輕量化命令行工具）**
    -   **特色**：純文字互動介面，專為 Windows IIS 設計。
    -   **運作機制**：執行後會自動偵測 IIS 站台，完成域名驗證、下載憑證、綁定 IIS 443 埠，並在 Windows 中自動建立一個「工作排程器」，每隔約 55~60 天自動幫你延長憑證，達到永久免費的效果。
2.  **[Certify The Web](/url?sa=i&source=web&rct=j&url=https://certifytheweb.com/&ved=2ahUKEwihk7eQ-r-WAxUXdPUHHVYjKiQQy_kOeggIAggBCDQQCQ&opi=89978449&cd&psig=AOvVaw2s5CJCW92FOWJyej-qec9c&ust=1787890730609000)（最友善的 GUI 圖形介面軟體）**
    -   **特色**：擁有漂亮的視窗管理介面，適合不習慣使用命令行的系統管理員。
    -   **限制**：社群免費版最多支援管理 5 個網域，對於一般架站或測試環境已非常足夠。

📋 部署前的準備工作

在執行工具申請免費憑證前，請確保以下 3 點已設定完成，否則驗證會失敗：

-   **網域解析（DNS）**：你的網域（如 `example.com`）必須已經正確指向該台 IIS 伺服器的對外實體 IP。
-   **防火牆開啟**：伺服器與網路防火牆必須**開啟 Port 80 (HTTP)**。因為 Let's Encrypt 的驗證機制（HTTP-01 挑戰）需要透過 80 埠連入你的網站來確認網域所有權。
-   **IIS 站台設定**：IIS 站台必須先綁定好對應的「主機標頭（Host Name / Domain）」。

⏱️ 基本操作 3 步驟（以 win-acme 為例）

1.  **下載與解壓**：前往官網下載 win-acme，並解壓縮至伺服器中固定的資料夾（例如 `C:\win-acme\`）。
2.  **以管理員身分執行**：右鍵點擊 `wacs.exe` 並選擇「以系統管理員身分執行」。
3.  **照提示輸入**：
    -   輸入 `N` 建立新憑證（New Certificate）。
    -   選擇 `1` 綁定單一 IIS 站台（或依選單選取你的網站編號）。
    -   輸入你的 Email（用來接收憑證異常或過期警告）。
    -   接受合約後，程式便會**自動完成所有設定**並在 IIS 綁定好 HTTPS 協定。

* * *

您目前架設的 IIS 網站是屬於**公司對外營運網站**，還是**內部/開發測試環境**呢？如果您在安裝過程中遇到任何錯誤訊息，歡迎提供給我，我可以幫您診斷問題！

更多

---

# googlesearch response

如果在**純內網環境（沒有對外實體 IP、外部網域名稱系統無法解析）**，Let's Encrypt 的預設驗證方式（HTTP-01 挑戰）會失效，因為 Let's Encrypt 的官方驗證伺服器無法連入您的內網。

針對純內網的 IIS 伺服器，主要有以下三種解決方案：

1\. 使用 DNS-01 挑戰（仍可使用免費、自動更新的憑證）

如果您的網域是在[對外公開的 DNS 服務商](/url?sa=i&source=web&rct=j&url=https://www.win-acme.com/reference/plugins/validation/dns/&ved=2ahUKEwjKn_GQ-r-WAxUlUPUHHQwTJ0wQy_kOegYIAAgOEAE&opi=89978449&cd&psig=AOvVaw33b5pkvnW9ZbAgOImLH1qQ&ust=1787890731623000)（如 [Cloudflare](/url?sa=i&source=web&rct=j&url=https://www.cloudflare.com/&ved=2ahUKEwjKn_GQ-r-WAxUlUPUHHQwTJ0wQy_kOegYIAAgOEAI&opi=89978449&cd&psig=AOvVaw33b5pkvnW9ZbAgOImLH1qQ&ust=1787890731623000)、[Gandi](/url?sa=i&source=web&rct=j&url=https://www.gandi.net/&ved=2ahUKEwjKn_GQ-r-WAxUlUPUHHQwTJ0wQy_kOegYIAAgOEAM&opi=89978449&cd&psig=AOvVaw33b5pkvnW9ZbAgOImLH1qQ&ust=1787890731623000)、[AWS Route 53](/url?sa=i&source=web&rct=j&url=https://aws.amazon.com/route53/&ved=2ahUKEwjKn_GQ-r-WAxUlUPUHHQwTJ0wQy_kOegYIAAgOEAQ&opi=89978449&cd&psig=AOvVaw33b5pkvnW9ZbAgOImLH1qQ&ust=1787890731623000) 等）代管，即使伺服器在內網，依然可以申請 Let's Encrypt 憑證。

-   **驗證原理**：[win-acme](/url?sa=i&source=web&rct=j&url=https://www.win-acme.com/&ved=2ahUKEwjKn_GQ-r-WAxUlUPUHHQwTJ0wQy_kOegYIAAgREAI&opi=89978449&cd&psig=AOvVaw33b5pkvnW9ZbAgOImLH1qQ&ust=1787890731623000) 或 [Certify The Web](/url?sa=i&source=web&rct=j&url=https://certifytheweb.com/&ved=2ahUKEwjKn_GQ-r-WAxUlUPUHHQwTJ0wQy_kOegYIAAgREAM&opi=89978449&cd&psig=AOvVaw33b5pkvnW9ZbAgOImLH1qQ&ust=1787890731623000) 透過 API 自動在您的對外 DNS 上寫入一筆特殊的 `TXT 記錄`。Let's Encrypt 只要查到這筆記錄，就能證明網域是您的，並核發憑證。**過程中您的 IIS 完全不需要開通對外網路。**
-   **操作步驟**：
    1.  在外網 DNS 服務商後台申請一個 `API Key / Token`。
    2.  執行 win-acme 時，驗證方式不要選 HTTP，改選 **`[dns] Create verification records manually or programmatically`** 並選擇您的 DNS 服務商。
    3.  輸入 API Key，工具即會自動化完成後續的申請與每 60 天的更新綁定。

2\. 建立自簽憑證（Self-Signed Certificate）並佈署信任

如果您的內網主機名稱完全是虛構的（例如 `myserver.local` 或 `test.internal`），這種網域在國際上是不允許申請公開憑證的。此時最標準的做法是**自行建立自簽憑證**：

-   **中小型環境（手動信任）**：
    1.  直接在 IIS 管理員中點擊伺服器節點，選擇 **「伺服器憑證」** → **「建立自簽憑證」**。
    2.  將建立好的憑證匯出為 `.cer` 檔案。
    3.  把該檔案複製到需要連線的內網用戶端電腦上，手動匯入至**「信任的根憑證授權單位」**。如此一來，瀏覽器就不會再跳出安全警告。
-   **企業大型環境（AD 網域控制站授權）**：
    -   如果公司內網有 Windows Active Directory (AD) 環境，請架設 **Active Directory 憑證服務 (AD CS)** 作為企業內部的憑證授權單位 (CA)。
    -   透過網域控制站的**群組原則 (GPO)**，可以一鍵讓公司內所有電腦自動信任這台內部 CA 簽發的所有 IIS 憑證，並能透過內部腳本達到自動更新。

3\. 免費憑證申請方式對比

以下為您快速比較內網環境適用的憑證方案：

| 方案 | 網域要求 | 外部網路需求 | 優點 | 缺點 |
| --- | --- | --- | --- | --- |
| **DNS-01 驗證** | 必須是真實擁有的公開網域 | 僅 Server 需發送 HTTPS 請求至 DNS API | 完全免費、全自動、瀏覽器無警告 | 需支援 API 的外網 DNS 代管 |
| **自簽憑證** | 任意網域/內部主機名皆可 | 完全不需連網 | 設定極快、不受任何網域限制 | 每台用戶端電腦必須手動匯入信任 |
| **企業內部 CA** | 配合企業內網 AD 網域 | 完全不需連網 | 企業內部集中管理、批次派送信任 | 架設成本高，需有 Windows AD 架構 |

您目前的內網主機名稱是**真實擁有的公開網域（例如：`://yourcompany.com`）**，還是**自訂的內部名稱（例如：**`iis-server.local`）呢？另外，公司內部是否有架設 **Windows AD 網域服務**？提供這些資訊我可以為您建議最省時的設定路徑！

更多

---

# googlesearch response

同時存在 `abc.local` 與 `bi.abc.com.tw` 時，必須**分開處理**，因為沒有任何公開的憑證機構（CA）能為 `.local` 簽發正式憑證。

最完美的解決方案是將兩張憑證同時綁定在 IIS 的同一個站台上：

1\. `bi.abc.com.tw` 的處理方式：使用外網 DNS 自動化免費憑證

由於這是公開網域，您可以使用 **Let's Encrypt** 免費憑證。因為伺服器在內網，請使用前文提到的 **DNS-01 驗證**：

1.  **取得 API 金鑰**：登入代管 `abc.com.tw` 的外網 DNS 後台（如 Cloudflare、Gandi、中華電信、AWS 等），申請一組 API 憑證（Token/Key）。
2.  **使用工具申請**：在內網 IIS 伺服器上下載 `win-acme` 或 `Certify The Web`。
3.  **設定 DNS-01**：在工具中輸入 `bi.abc.com.tw`，驗證方式選擇您所屬的 DNS 服務商並貼上 API 金鑰。
4.  **自動產出與續約**：工具會自動透過外網 DNS 驗證，並將核發的免費 90 天憑證自動安裝到 IIS，未來也會每 60 天自動更新。

2\. `abc.local` 的處理方式：建立內部自簽憑證

`.local` 是保留給私有網路的虛擬後綴，網際網路不承認。您必須自行當作憑證發行商：

1.  **建立憑證**：
    -   **方法 A（無 AD 環境）**：在 IIS 管理員點擊伺服器節點 → 進入「伺服器憑證」 → 點選右側「建立自簽憑證」 → 填入 `abc.local`。
    -   **方法 B（有公司 AD 網域）**：透過企業內部的 Windows AD CS（憑證服務）直接簽發一張 `abc.local` 的憑證。
2.  **派送信任（關鍵步驟）**：
    -   自簽憑證預設會被瀏覽器判定為「不安全」。您必須將這張憑證匯出成 `.cer` 檔，並安裝到內網所有要連線的電腦中的**「信任的根憑證授權單位」**。如果是 AD 環境，可直接透過群組原則（GPO）一鍵強制派送給全公司電腦。

3\. 如何在 IIS 站台同時綁定這兩張憑證？

IIS 支援 **SNI（伺服器名稱指示）**，允許同一個 443 埠口依據不同的網址出示不同的憑證：

1.  開啟 IIS 管理員，對著您的網站點擊右側的 **「繫結... (Bindings...)」**。
2.  點擊 **「新增」**：
    -   類型：`https`
    -   主機名稱：`bi.abc.com.tw`
    -   勾選：**「需要伺服器名稱指示 (Require Server Name Indication)」**（必勾）
    -   SSL 憑證：選擇 Let's Encrypt 簽發的那張。
3.  再次點擊 **「新增」**：
    -   類型：`https`
    -   主機名稱：`abc.local`
    -   勾選：**「需要伺服器名稱指示 (Require Server Name Indication)」**（必勾）
    -   SSL 憑證：選擇您自己建立的 `abc.local` 自簽憑證。

* * *

請問管理 `abc.com.tw` 的**公開 DNS 服務商**是哪一家呢？（這會決定 `win-acme` 或 `Certify The Web` 工具中要選擇哪一個 DNS 套件來自動化申請）

更多

---

# googlesearch response

即便伺服器完全不在 DMZ \[3\]，且 `bi.abc.com.tw` 只有在內網或透過 VPN 連線時才能解析、讀到，**上述的「DNS-01 驗證」方案依然完全適用，而且是唯一的免費正統解法**。

這是因為 **DNS-01 驗證完全不需要外網連入這台 IIS 伺服器**。

以下為您說明在純內網/VPN 環境下，這兩張憑證具體的運作與設定方式：

* * *

一、 `bi.abc.com.tw` 在內網/VPN 的 SSL 運作機制

Let's Encrypt 驗證時，它的伺服器**完全不會**嘗試連線到您的內網 IIS（也就是不需要經過 DMZ 或穿透防火牆）。

1\. 它是如何完成驗證的？

-   您的內網 IIS 伺服器（透過 win-acme 工具）只要能**單向對外連網**，發送 HTTPS 請求給您的**公開 DNS 服務商**（例如 Cloudflare、AWS Route53、Gandi 等）\[1\]。
-   工具會透過 API，在公開的 DNS 上暫時寫入一筆 `_acme-challenge.bi.abc.com.tw` 的 `TXT` 記錄。
-   Let's Encrypt 的官方伺服器直接去檢查這台**公開的 DNS**，只要查到這筆 `TXT` 記錄，就代表您確實擁有 `abc.com.tw` 這個網域，接著就會核發免費憑證。
-   核發後，憑證會直接下載並自動安裝到您的內網 IIS 上。

2\. 內網與 VPN 用戶端要如何順利連線？

由於外網的公開 DNS 不需要知曉內網 IP，您只需要在**內部 DNS 伺服器（Internal DNS）**或 Windows AD 的 DNS 上，新增一筆 `A 記錄`：

-   **名稱**：`bi`
-   **網域**：`abc.com.tw`
-   **IP 位址**：指向您那台 IIS 的**內網虛擬 IP**（例如 `192.168.X.X` 或 `10.X.X.X`）。

這樣不論是內網電腦，或是海外出差透過 VPN 連回公司的員工，向內部 DNS 查詢 `bi.abc.com.tw` 時，都會拿到內網 IP \[2\]，同時因為 IIS 上已經裝好了合法的 Let's Encrypt 憑證，**瀏覽器就會完全信任，顯示安全的綠色鎖頭，且完全不跳警告**。

* * *

二、 `abc.local` 的內網處理方式

誠如前述，`.local` 是非公開的虛擬後綴，Let's Encrypt 或任何公開 CA 都無法為其簽發憑證。

1.  **申請方式**：直接在 IIS 管理員點擊「伺服器憑證」 → 「建立自簽憑證」，名稱填寫 `abc.local`。
2.  **派送信任（重要）**：將該憑證匯出成 `.cer` 檔案，佈署到內網與會透過 VPN 連線的電腦中，將其安裝至**「信任的根憑證授權單位」**。

* * *

三、 在 IIS 上的最終繫結 (Bindings) 配置

當兩張憑證都準備好後，在 IIS 的網站「繫結」中新增兩筆 HTTPS 設定：

| 主機名稱 (Host Name) | 連接埠 (Port) | 勾選 SNI \[2\] | 選用的 SSL 憑證 | 用戶端瀏覽器狀態 |
| --- | --- | --- | --- | --- |
| **`bi.abc.com.tw`** | 443 | ✅ 必須勾選 | Let's Encrypt 免費憑證 (自動續約) | 🟢 **安全** (免手動設定，全自動信任) |
| **`abc.local`** | 443 | ✅ 必須勾選 | 內部自簽憑證 \[2\] | 🟢 **安全** (需手動或透過 GPO 派送信任) \[2\] |

_註：不論用戶是直接在辦公室內網，還是透過 VPN 連入，只要勾選了 **SNI (伺服器名稱指示)**，IIS 就會根據他們在網址列輸入的是哪一個網址，精準出示對應的憑證 \[2\]。_

若要實行 `bi.abc.com.tw` 的自動化免費憑證，請確認代管您 `abc.com.tw` **公開網域的 DNS 服務商**（如 Cloudflare、GoDaddy、中華電信、Gandi 等）是哪一家？我可以為您查詢 win-acme 支援該服務商的專用套件名稱！

更多