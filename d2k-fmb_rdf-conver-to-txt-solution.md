# D2K / Oracle Forms `.fmb` 與 Reports `.rdf` 轉換與盤點方案

## 背景

老舊的 Oracle Developer 2000（D2K）系統，常見的 Form 與 Report 檔案通常分別是：

- Oracle Forms：`.fmb`
- Oracle Reports：`.rdf`

如果想了解每個 Form / Report 的功能、使用到的 Table，以及其中的 PL/SQL 或 SQL 邏輯，通常需要先將二進位檔案轉換成文字或 XML，再進行搜尋與分析。

## `.fmb` 轉換方式

### 1. 使用 Oracle Forms 官方命令列工具

依 Forms 版本不同，工具名稱可能是 `frmcmp.exe` 或舊版的 `ifcmp60.exe`。較新的 Forms 環境可以使用 `forms_doc=yes` 產生文字格式的結構報告：

```bat
frmcmp.exe module=你的表單名稱.fmb LOGON=NO forms_doc=yes output_file=輸出名稱.txt BATCH=YES Window_State=Minimize
```

批次處理資料夾內所有 `.fmb` 的範例：

```bat
for %%f in (*.fmb) do (
    frmcmp.exe module=%%f LOGON=NO forms_doc=yes output_file=%%~nf.txt BATCH=YES Window_State=Minimize
)
```

`forms_doc=yes` 主要用來產生包含表單結構、物件屬性與 PL/SQL 內容的文字報告。

### 2. 使用 Forms Builder 圖形介面

若只需要處理少量檔案，可以在 Forms Builder 中開啟 `.fmb`，再使用物件列表報告或轉換功能：

- **Object List Report**：產生較適合閱讀的文字報告。
- **Binary-to-Text / FMB to FMT**：將二進位 Form 轉成 `.fmt` 文字格式。

`.fmt` 主要是供 Oracle 還原或交換使用，雖然是文字檔，但通常會包含大量系統語法，閱讀性不如報告格式或 XML。

### 3. 轉換成 XML

較新的 Oracle Forms 環境可以使用 `frmf2xml` 將 Form 轉成 XML：

```bat
frmf2xml 你的表單名稱.fmb
```

XML 適合放入 Git 做版本管理，也方便使用 VS Code、PowerShell 或其他工具進行搜尋與比對。

## `.rdf` 轉換方式

### 1. 使用 `rwconverter` / `rwcon60`

Oracle Reports 的轉換工具依版本不同，可能叫做：

- 舊版：`rwcon60.exe`
- 較新版：`rwconverter.exe`

轉換成 Report Exchange Format（`.rex`）的範例：

```bat
rwconverter.exe userid=帳號/密碼@資料庫 source=你的報表.rdf dest=輸出名稱.rex stype=rdffile dtype=rexfile batch=yes overwrite=yes
```

轉換成 XML 的範例：

```bat
rwconverter.exe userid=帳號/密碼@資料庫 source=你的報表.rdf dest=輸出名稱.xml stype=rdffile dtype=xmlfile batch=yes overwrite=yes
```

批次處理範例：

```bat
for %%f in (*.rdf) do (
    rwconverter.exe userid=scott/tiger@orcl source=%%f dest=%%~nf.rex stype=rdffile dtype=rexfile batch=yes overwrite=yes
)
```

> 實際參數與是否需要資料庫連線，會依 Oracle Reports 版本與報表內容而異。使用正式帳號前，建議先確認工具版本與環境設定。

### 2. 使用 Reports Builder

如果有 Reports Builder，可以開啟 `.rdf`，使用轉換功能將檔案輸出為 `REX` 或 XML 格式。這種方式適合處理單一或少量報表。

## Standalone 使用情境

如果手上只有 `.fmb` 與 `.rdf`，但沒有 Oracle Forms / Reports Builder，必須先注意：這些檔案是 Oracle 的私有二進位格式，純粹使用一般文字工具無法可靠解析。

可行方案如下：

1. **找一台具備相容 Oracle Forms / Reports 環境的電腦或虛擬機**，使用官方工具一次批次轉成 `.txt`、`.rex` 或 `.xml`。
2. 將轉換後的文字檔案帶到乾淨的 Windows 電腦上，以 VS Code、Notepad++ 或 PowerShell 進行分析。
3. 若要嘗試第三方工具，先確認其支援的 Forms / Reports 版本，以及是否仍依賴 Oracle DLL 或 Builder 安裝環境。

先轉換成文字或 XML，再進行分析，通常比直接尋找完全獨立且相容所有版本的 `.fmb` / `.rdf` 解析器更可靠。

## 如何盤點 Form / Report 使用的 Table

### 使用文字搜尋工具

將所有轉換後的 `.txt`、`.rex` 與 `.xml` 放在同一個目錄，使用 VS Code 或 Notepad++ 的「在檔案中尋找」搜尋：

- `SELECT`
- `FROM`
- `UPDATE`
- `INSERT`
- `DELETE`
- `EXECUTE`
- `TABLE`
- `VIEW`

Report 還需要特別檢查：

1. **Data Model / Data Query**：主要 SQL 通常位於 Query 物件中。
2. **Formula Column**：可能在公式欄位中執行額外的 PL/SQL 或查詢。
3. **Format Trigger**：可能依條件查詢資料或計算欄位。
4. **Report Trigger**：可能包含整份報表共用的初始化或收尾邏輯。

### 使用 PowerShell 快速找出 SQL 相關檔案

```powershell
Get-ChildItem -Recurse -Include *.txt, *.rex, *.xml |
    Select-String -Pattern '\b(FROM|JOIN|UPDATE|INSERT\s+INTO|DELETE\s+FROM)\s+[A-Za-z0-9_$#.]+' |
    Select-Object Path, LineNumber, Line
```

若只想依檔案分組：

```powershell
Get-ChildItem -Recurse -Include *.txt, *.rex, *.xml |
    Select-String -Pattern '\b(FROM|JOIN|UPDATE|INSERT\s+INTO|DELETE\s+FROM)\s+[A-Za-z0-9_$#.]+' |
    Group-Object Path
```

這類正規表示式只能作為初步盤點工具。動態 SQL、字串組合、Synonym、Database Link、Stored Procedure 以及透過 View 或 Package 間接存取的 Table，仍需要人工確認。

## 盤點結果建議

可以建立一份對照表，至少包含以下欄位：

| 類型 | 檔案名稱 | 功能摘要 | 直接使用的 Table / View | 主要 Trigger / Query | 備註 |
| --- | --- | --- | --- | --- | --- |
| Form | `example.fmb` |  |  |  |  |
| Report | `example.rdf` |  |  |  |  |

建議將原始檔案、轉換後檔案與盤點結果分開保存，例如：

```text
legacy-system/
├── source/
│   ├── forms/
│   └── reports/
├── converted/
│   ├── forms/
│   └── reports/
└── inventory/
    ├── form-report-inventory.csv
    └── table-usage.csv
```

## 方案比較

| 方案 | 輸入 | 輸出 | 是否需要 Oracle 環境 | 適用情境 |
| --- | --- | --- | --- | --- |
| `frmcmp` / `forms_doc` | `.fmb` | `.txt` | 通常需要 | 批次產生可讀報告 |
| `frmf2xml` | `.fmb` | `.xml` | 通常需要 | 版本控制與結構分析 |
| `rwconverter` | `.rdf` | `.rex` / `.xml` | 依版本與設定而定 | 批次轉換 Report |
| Forms / Reports Builder | `.fmb` / `.rdf` | 報告、`.fmt`、`.rex` 或 XML | 需要 | 單檔或少量轉換 |
| 第三方解析工具 | 依工具而定 | 文字、XML 或索引 | 需確認 | 無 Builder 環境時嘗試 |

## 注意事項

- 不同 Oracle Forms / Reports 版本的檔案格式與工具參數可能不相容。
- `.fmb` 與 `.rdf` 不應直接當成一般文字檔開啟或修改。
- 轉換前先保留原始檔案，並使用副本進行測試。
- 轉換結果可能包含資料庫連線資訊、帳號、密碼、內部主機名稱或公司機密，提交到 GitHub 前應先檢查並遮蔽敏感資訊。
- 若報表或表單使用動態 SQL，單純搜尋固定的 `FROM table_name` 可能無法找完整依賴關係。
- 最終的 Table 關聯清單應搭配資料庫端的 View、Synonym、Package、Procedure 與 Function 定義一起確認。
