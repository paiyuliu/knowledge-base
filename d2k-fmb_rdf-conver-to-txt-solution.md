> From: https://www.google.com/search?source=hp&sxsrf=APpeQnvjvel2rVDyZN2uc8g7DXXxumhAzg%3A1790135186139&mstk=AUtExfCBMsAOf7CplEA9OzjFqO2iwx_lHaDGAkgONlEBj1Amr4t8JtPGrR8q_n3-ptIZXBfV0sFlz8anyMM53H0N-JBiNICqPyawrk8Np0BqQlnkj_u1AsxuU2srzpYpfQkhXWkes4bs_qn6fDdnQs8HJxeZMjn2lXVsqRfkY4EBTmKsczsNx729Uxb8Cvd1_e-6dhpAbyrp1wzG0Wy3_T_yo2e8j8LiM-nVahtiuM8RN1mYlFWX17af_dQU5gPaZoh67BEP8wGbUWvg7j26yIa16LGZ4xPlijSbrAq9gtiVr-6Q-PMQJv7tM89HaxfzdXEqVAmsJGDMwOJEIQ&mtid=kkqzaqD7Fobf1e8P9-vt0Q8&csuir=1&aep=26&q=d2k+fmb+conver+to+txt+windows+%E6%9C%89+solution+%E5%97%8E%3F&ved=0CAAQ2_wOahcKEwjAm6qg5YOXAxUAAAAAHQAAAAAQEA&udm=50&atvm=2

# you asked

message time: 上午11:40

d2k fmb convert to txt windows 有 solution 嗎?

---

# googlesearch response

在 Windows 環境下將 **Oracle Developer 2000 (D2K) / Oracle Forms 的 .fmb 二進位檔案轉換為 .txt 文字檔**，主要有以下幾種熱門且可行的官方與非官方解決方案：

方案一：官方命令列工具 `frmcmp`（最推薦、適合批次處理）

自帶的編譯器可以直接透過命令列將 `.fmb` 導出為包含所有屬性與 PL/SQL 程式碼的 `.txt` 報告檔案。

根據你的 D2K / Forms 版本，元件名稱可能會有些許不同（例如 6i 版本為 `ifcmp60.exe`，10g 之後為 `frmcmp.exe`）。

**執行指令：**

```bat
frmcmp.exe module=你的表單名稱.fmb LOGON=NO forms_doc=yes output_file=輸出名稱.txt BATCH=YES Window_State=Minimize
```

請謹慎使用程式碼。

-   **關鍵參數**：`forms_doc=yes` 會指示系統生成一份詳細的文字結構報告（純文字）。
-   **批次處理**：如果要一次轉換資料夾內所有的 `.fmb`，可以寫一個 Windows 批次檔 (`.bat`)：

    cmd

    ```
    for %%f in (*.fmb) do (
        frmcmp.exe module=%%f LOGON=NO forms_doc=yes output_file=%%~nf.txt BATCH=YES Window_State=Minimize
    )
    ```

    請謹慎使用程式碼。

* * *

方案二：Forms Builder 圖形介面操作（適合單一檔案）

如果你只想手動轉一兩個檔案，直接在工具內操作最快。

-   **方法 A（生成可讀報告）**：
    開啟 [Oracle Forms Builder](/url?sa=i&source=web&rct=j&url=https://www.youtube.com/watch?v%3De1I39Y_A7iI&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCNYBEAI&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000) 載入 `.fmb` → 點選上方選單 **File (檔案)** → **Administration (管理)** → **Object List Report (物件列表報告)**。這會在同目錄下自動產生一個同名的 `.txt` 檔，內含清晰的 PL/SQL 程式碼。
-   **方法 B（轉為原始文字格式 FMT）**：
    點選 **File** → **Convert (轉換)** → 選擇 **Binary-to-Text**（部分舊版本叫 `FMB to FMT`）。這會產生 `.fmt` 檔，可用記事本打開，但它的排列主要是給 Oracle 系統還原二進位用的，人類閱讀起來較不直觀。

* * *

方案三：轉換為 XML 再處理（適合代碼比對、现代維護）

Oracle 現代版本（9i、10g、11g、12c、19c+）強烈建議將二進位轉成 XML 格式。XML 本身就是純文字，非常適合放入 Git 作版本管理或進行關鍵字搜尋。

-   **使用官方工具 `frmf2xml`**：

    cmd

    ```
    frmf2xml 你的表單名稱.fmb
    ```

    請謹慎使用程式碼。

    這會產生一個 `你的表單名稱_fmb.xml` 檔案。
-   **進階開源工具**：你可以參考 上的開源專案 [LUMC/fmb2txt](/url?sa=i&source=web&rct=j&url=https://github.com/LUMC/fmb2txt&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCNoBEAY&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)，這個 Java 工具可以自動將 `.fmb` 轉為 XML，並進一步將圖形屬性（如座標、顏色）過濾掉，只留下最乾淨、階層分明的純程式碼 `.txt` 檔案。

方案對比總結

| 解決方案 | 產出副檔名 | 優點 | 缺點 |
| --- | --- | --- | --- |
| **`frmcmp` 命令列** | `.txt` | **支援批次處理**、程式碼完整 | 需有安裝 Forms 執行環境 |
| **Object List Report** | `.txt` | 排版最漂亮、**極好閱讀** | 只能在 IDE 裡手動單個操作 |
| **Binary-to-Text** | `.fmt` | 未來可以再轉回 `.fmb` | 充斥系統語法，不易閱讀 |
| **Forms2XML** | `.xml` | **最適合版控(Git)**與關鍵字搜尋 | 標籤繁多，需搭配編輯器看 |

請問您將這些 `.fmb` 轉換成 `.txt` 的**主要目的**是什麼呢？

-   需要**跨多個檔案搜尋某個關鍵字 / SQL 欄位**？
-   準備導入 **Git 或 SVN 進行代碼版本管理**？
-   單純需要**列印或檢視某個表單的 PL/SQL 邏輯**？

說明您的具體需求，我可以為您提供更進一步的批次指令或自動化過濾腳本。

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多

---

# you asked

message time: 上午11:42

老舊系統想要瞭解每個 form 的工作及相關 table,另外 report 也有類似的工具嗎?

---

# googlesearch response

針對老舊系統進行資產盤點（了解每個 Form/Report 的功能、查詢了哪些 Table），這在系統翻新或維護中非常常見。

對於 **（副檔名通常為 `.rdf`）**，官方和社群確實提供了**完全對應**的工具與解決方案，可以幫你把二進位的 `.rdf` 轉成純文字，進而快速搜尋與盤點 Table。

以下為您整理 Report 的轉換工具，以及如何高效利用這些純文字檔案進行 Table 與功能盤點的方法：

* * *

一、 Oracle Reports (`.rdf`) 轉換為文字的工具

與 Forms 類似，Reports 也有命令列工具與圖形介面兩種方式：

方案 1：官方命令列工具 `rwconverter` / `rwcon60`（最推薦批次處理）

提供專屬的轉換工具，在舊版本（如 6i）叫做 `rwcon60.exe`，在較新版本（9i/10g/11g/12c）叫做 `rwconverter.exe`。

它可以將 `.rdf` 轉換成 **`.rex` 檔案（Report 改成文字後的專屬副檔名）** 或 **`.xml`**。

-   **轉換為 `.rex` (純文字格式)**：

    cmd

    ```
    rwconverter.exe userid=帳號/密碼@資料庫 source=你的報表.rdf dest=輸出名稱.rex stype=rdffile dtype=rexfile batch=yes overwrite=yes
    ```

    請謹慎使用程式碼。

-   **轉換為 `.xml` (現代版控/搜尋格式)**：

    cmd

    ```
    rwconverter.exe userid=帳號/密碼@資料庫 source=你的報表.rdf dest=輸出名稱.xml stype=rdffile dtype=xmlfile batch=yes overwrite=yes
    ```

    請謹慎使用程式碼。

-   **批次檔範例**（寫成 `.bat` 即可一次轉整張資料夾）：

    cmd

    ```
    for %%f in (*.rdf) do (
        rwconverter.exe userid=scott/tiger@orcl source=%%f dest=%%~nf.rex stype=rdffile dtype=rexfile batch=yes overwrite=yes
    ```

    請謹慎使用程式碼。

方案 2：Reports Builder 圖形介面操作（適合單一檔案）

-   開啟 \[\] 載入 `.rdf`。
-   點選上方選單 **File (檔案)** → **Administration (管理)** → **Convert... (轉換)**。
-   在彈出視窗中，將 **Source** 選為你的 `.rdf`，**Destination Type** 選擇 **REX**（或 XML），點擊確定即可轉出純文字檔。

* * *

二、 如何利用轉出的文字檔快速盤點 Table 與功能？

不論是 Form 轉出的 `.txt` / `.xml`，還是 Report 轉出的 `.rex` / `.xml`，變成純文字後，你就不用再一個個開啟 IDE 檢查。你可以使用以下方法來建立系統的「功能與資料表對照表」：

1\. 使用關鍵字全域搜尋（如 VS Code / Notepad++）

將所有轉好的 `.txt`、`.rex`、`.xml` 檔案集中放到一個資料夾，使用 [VS Code](/url?sa=i&source=web&rct=j&url=https://code.visualstudio.com/&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCOoBEAE&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000) 或 [Notepad++](/url?sa=i&source=web&rct=j&url=https://notepad-plus-plus.org/&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCOoBEAI&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000) 開啟該資料夾，利用「**跨檔案搜尋 (Find in Files)**」功能：

-   **盤點關鍵字**：搜尋 `SELECT` 、`FROM` 、`UPDATE` 、`INSERT` 。
-   **好處**：你能立刻抓出哪一個 Form 或 Report 的哪一行程式碼存取了特定的資料表（例如：搜尋 `FROM emp`，就能找出所有用到員工資料表的表單與報表）。

2\. 自製簡單的 Python/PowerShell 腳本自動生成 Excel

如果你有上百個 Form 和 Report，可以用簡單的指令或腳本，自動把檔案名稱與裡面的 SQL 語句提取出來。
例如，使用 Windows 內建的 **PowerShell** 在文字檔資料夾內執行以下指令，就能抓出所有含有特定 Table 名稱的檔案清單：

```powershell
Get-ChildItem -Recurse -Include *.txt, *.rex | Select-String -Pattern "FROM \w+" | Group-Object Path
```

請謹慎使用程式碼。

3\. 注意 Reports 特有的 Table 藏身處

在盤點 Report (`.rex` 或 `.xml`) 時，Table 通常會出現在以下兩個地方，搜尋時可以特別留意：

1.  **Data Model (資料模型)**：報表主要的 SQL 查詢語句（通常包裹在 `<dataQuery>` 或 `Q_1` 這種 Query 物件中）。
2.  **Formula / Format Triggers (公式與格式觸發程序)**：有些複雜的報表會在觸發程序裡寫 PL/SQL 去額外 select 欄位或計算數值。

* * *

三、 進階：Oracle 官方的升級盤點工具

如果你的老舊系統未來有打算要移轉升級（例如轉向 、BI Publisher 或 Web Forms），Oracle 官方在現代版本中有提供 等轉換助理工具。這些工具在初始評估階段，會自動掃描舊有的 FMB 和 RDF 檔案，並直接產出一份系統複雜度報告與預估的 Table 關聯清單。

為了幫您更好地規劃盤點工作，請問：

-   您的 D2K/Oracle Forms & Reports 的**具體版本**大約是多少呢？（例如 6i、9i、10g 或是更早期版本？）
-   轉換出來的純文字檔案，您後續會希望用**什麼樣的格式**來呈現這份對照表（例如 Excel、Word 文件，還是純粹供團隊搜尋的 Wiki 頁面）？

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多

---

# you asked

message time: 上午11:43

目前可以 standalone 執行的 solution 有哪些? 如果我只有 fmb file and rdf file

---

# googlesearch response

如果你**只有 `.fmb` 和 `.rdf` 原始檔案**，且**完全不想（或無法）在 Windows 上安裝龐大的 Oracle Form/Report Builder、Fusion Middleware 或是資料庫環境**，想要純粹以 Standalone（獨立運行）的方式將它們轉換並分析，目前市面上有以下幾種可行的第三方、開源與輕量解決方案：

* * *

1\. 線上/免安裝瀏覽器分析工具（最快、完全免安裝）

如果你可以接受將檔案或轉出來的 XML 內容上傳（或者工具是在瀏覽器本地端解析），有一些國外開發者製作了專門的 Web 獨立工具：

-   [1sxxnb2](/url?sa=i&source=web&rct=j&url=https://www.reddit.com/r/oracle/comments/1sxxnb2/i_built_a_webpage_for_viewing_oracle_forms/&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCLABEAM&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)：這是一個獨立的網頁工具，允許使用者直接將 `.fmb` 檔案拖入瀏覽器中。它會在**瀏覽器本地端**直接讀取檔案，並轉化為可視化的階層樹狀結構，讓你能直接點選檢視 Triggers、Program Units 內含的 SQL 與 Table 邏輯，完全不需要 Oracle 環境。

2\. 獨立的第三方桌面提取工具

-   ：這類工具是專門為了「不打開 Builder 就能進行資產代碼審計」而設計的獨立桌面應用程式。
    -   **運作方式**：它們擁有獨立的 UI 介面，可以直接批量載入 `.fmb` 或由其轉出的 XML。
    -   **功能**：會在內部將 UI 元件（Blocks、Items）與資料庫引用（Table、View）建立關聯圖，並自動提取出 PL/SQL 代碼，非常適合用於盤點老舊系統的商業邏輯。

3\. 開源 Java / Kotlin 輕量方案（需安裝 Java 即可執行）

如果你有工程師背景，可以使用這兩個在 上的獨立開源專案，它們只需要安裝 Java 執行環境（JRE），不需要 Oracle 軟體：

-   **LUMC / fmb2txt** [fmb2txt](/url?sa=i&source=web&rct=j&url=https://github.com/LUMC/fmb2txt&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCLoBEAM&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)：這是一個 Java 寫的 Standalone 工具。它專門用來清理與轉換格式。它會解析檔案並自動過濾掉無用的圖形屬性（如：視窗大小、顏色、字體），只把純程式碼和結構提取成階層分明、非常易讀的 `.txt` 檔案，方便你用 VS Code 等工具一鍵搜尋裡面的 Table 名稱。
-   **Oracle Forms MCP Server** [oracle-forms-mcp](/url?sa=i&source=web&rct=j&url=https://github.com/aoreshkov/oracle-forms-mcp&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCLoBEAk&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)：這是一個新穎的 Kotlin/JVM 獨立工具。它能在本地端直接讀取 `.fmb`、`.mmb`、`.pll` 檔案，並在背後建立一個程式碼索引服務。

4\. 針對 Report (.rdf) 的獨立架構：BI Publisher 轉換公用程式

-   **BIPBatchConversion 獨立封裝**：Oracle 官方針對 Report 的轉換，有一套基於 Java 運行的獨立工具 `BIPBatchConversion`（通常隨附於 Oracle BI Publisher 的目錄中）。
    -   如果你能從其他有 Oracle 環境的地方拿到該公用程式的 Java 軟體包（如 `xdocore.jar`, `xmlparserv2.jar` 等），你就可以直接在任意一台只安裝了 Java 的 Windows 電腦上，以命令列方式將大量的 `.rdf` 批量轉為純文字的 XML 報表結構，從而分析其中的 Data Model 與 SQL 查詢語句。

* * *

💡 實務上的「折衷最佳解」建議

由於 `.fmb` 和 `.rdf` 是 Oracle 的私有二進位格式（Binary Formats），完全不借助 Oracle 的 DLL API 去解譯有時會遇到特定版本不相容的問題。如果您在 standalone 盤點時遇到阻礙，最無痛的標準做法是：

1.  **僅一次性**找一台有安裝舊版 Forms/Reports 環境的電腦（或虛擬機），使用官方的命令列工具 `frmf2xml` 與 `rwconverter`，把幾百個檔案**一次性全部轉成 `.xml` 格式**。
2.  把這批轉好的 `.xml` 檔案打包帶走。
3.  回到你自己的乾淨 Windows 電腦上（Standalone 狀態），這時所有的檔案都已經是純文字了。你不需要任何 Oracle 工具，直接用 或是用一個簡單的 **Python 腳本** 去全域搜尋 `FROM <table_name>`，就能在幾秒鐘內把「哪個 Form 讀取了哪個 Table」的清單完整拉出來。

為了幫您評估哪種工具最不會出錯，請問：

-   您的這些 `.fmb` 和 `.rdf` 檔案大約是**哪一個年代/版本**的系統呢？（例如 6i、10g 或是 12c ？）
-   總檔案數量大約是**幾十個**還是**成百上千個**呢？

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多

---

# you asked

message time: 上午11:44

稍早提到的 github 專案是什麼?

---

# googlesearch response

剛才提到的那兩個 **開源專案**，主要是國外開發者為了不依賴繁重的 Oracle 官方 GUI 介面（Forms Builder），而專門為「程式碼代碼審計、結構導出、分析」所開發的輕量工具。

這兩個專案的詳細背景、功能與連結如下：

專案一：LUMC / fmb2txt（最實用的文字清理工具）

-   **GitHub 連結**：[LUMC/fmb2txt 專案頁面](/url?sa=i&source=web&rct=j&url=https://github.com/LUMC/fmb2txt&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOeggIAggBCC4QAw&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)
-   **開發背景**：由荷蘭萊頓大學醫學中心（LUMC）的技術團隊開源釋出。
-   **功能與特色**：
    -   **去除圖形噪音**：一般的 `unset .fmb` 轉成文字後，會包含大量的 UI 座標、視窗大小、字體顏色等「視覺排版」欄位，導致檔案變得非常肥大且難以閱讀。
    -   **結構化程式碼**：這個工具會將轉出來的結構進行深度清理，**只保留最關鍵的階層結構、Trigger 以及 Program Unit 的純 PL/SQL 程式碼**，並輸出成極易閱讀的 `unset .txt` 檔案。
    -   **非常適合盤點**：你只需用 打開這個專案處理後的資料夾，全域搜尋 `unset FROM` 或 `unset UPDATE` ，就能用最乾淨的程式碼抓出哪些 Table 被哪些 Form 使用。
-   **技術需求**：基於 **Java 8+** 開發，可用 Maven 編譯執行。_(注意：它的底層轉換邏輯仍會調用 Oracle 本地的環境路徑，故建議在一台有 Forms 基礎環境的機器上跑批次)_。

* * *

專案二：aoreshkov / oracle-forms-mcp（現代 AI 輔助分析工具）

-   ：[aoreshkov/oracle-forms-mcp 專案頁面](/url?sa=i&source=web&rct=j&url=https://github.com/aoreshkov/oracle-forms-mcp&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCKoBEAM&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)
-   **開發背景**：這是一個專門為了結合**現代 AI（如 LLM、Cursor 編輯器、Claude 等）**所設計的全新開源工具。
-   **功能與特色**：
    -   **免開 Builder 讀取**：它是基於 **MCP (Model Context Protocol)** 協議開發的獨立伺服器工具。它能在本地端直接讀取指定資料夾內所有的 `unset .fmb` （表單）、`unset .mmb` （選單）、`unset .pll` （函式庫）檔案。
    -   **建立程式碼索引**：它會在背後將所有的 Blocks、Items、Triggers 和 PL/SQL 邏輯解析並建立結構化索引（Index）。
    -   **AI 自動化盤點**：建立索引後，你可以直接透過支援 MCP 的 AI 工具（例如 VS Code 插件、Cursor 等）問它：「請幫我列出這個資料夾中，所有讀取過表 A 的 Form 名稱」，AI 就會透過該工具的 API 自動把答案撈出來。
-   **技術需求**：基於 **Kotlin / JVM** 開發。它也提供了 **Docker 鏡像 (Container Image)** 的執行方式，如果你的檔案已經事先在別處轉過文字版的 XML，你可以直接在完全乾淨、無 Oracle 環境的電腦上用 Docker 把這個工具跑起來進行 Standalone 分析。

* * *

同場加映：paulcoiffier / Forms2NG（網頁本地端分析）

除了上述兩個，如果你想找的是「純網頁、把檔案拖進去就能看結構」的 Standalone 工具， 上還有一個早期專案叫做：

-   **GitHub 連結**：[paulcoiffier/Forms2NG 專案頁面](/url?sa=i&source=web&rct=j&url=https://github.com/paulcoiffier/Forms2NG&ved=2ahUKEwi_3si75YOXAxXOdfUHHeObIBwQy_kOegkIAggBCLYBEAM&opi=89978449&cd&psig=AOvVaw1UZRwUamZaUK6QEkg8jQKW&ust=1790221646139000)
-   **功能**：旨在讓工程師可以在**瀏覽器**上直接解析、閱讀 `unset .fmb` 的內容，藉此擺脫對 Oracle Forms Builder 的依賴。

您評估後，會傾向使用哪種方式來處理您的老舊系統呢？

-   使用 **fmb2txt** 這種工具將程式碼轉成乾淨的**純文字後，再自己用關鍵字搜尋**？
-   或是打算嘗試用 **oracle-forms-mcp** 這類新工具，**導入 AI（如 Cursor/LLM）幫您自動閱讀與分析**？

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多