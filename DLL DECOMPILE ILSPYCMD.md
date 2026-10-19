
# 我有一套已經沒簽維護合約的 c# .net framework 3.5 程式(廠商說已無維護舊系統，團隊成員皆已離職)，有沒有 方式 能以 command 方式 decompile dll，目前這些程式可以透過 https://www.decompiler.com/dll decompile dll，只是要一支一支程式拉，有些辛苦！



根據目前搜尋到的頁面內容（decompiler.com/dll），這個線上工具本身**只支援網頁拖拉上傳、單支 DLL 逐一解譯**，並沒有提供 command line 批次操作的功能[[1](https://www.decompiler.com/dll)]，所以無法用它來達成你想要的「一次處理多支 DLL」的需求。

不過你的需求（批次、命令列 decompile .NET DLL）是很常見的場景，這裡提供幾個實務上可行的替代方案，都能透過 command line 對 .NET Framework 3.5 的 DLL 進行批次反編譯：

## 推薦方案：ILSpy 的命令列版本 `ilspycmd`

ILSpy 是開源、免費且社群長期維護的 .NET 反編譯工具，其命令列工具 `ilspycmd` 可以直接透過 `dotnet tool` 安裝，非常適合批次處理。

**安裝步驟：**

```bash
dotnet tool install --global ilspycmd
```

**單支 DLL 反編譯成 C# 原始碼：**

```bash
ilspycmd YourAssembly.dll -o OutputFolder
```

**批次處理整個目錄下所有 DLL（PowerShell 範例）：**

```powershell
Get-ChildItem -Path "C:\LegacyApp\bin" -Filter *.dll | ForEach-Object {
    $outDir = Join-Path "C:\Decompiled" $_.BaseName
    ilspycmd $_.FullName -o $outDir
}
```

**批次處理（Windows CMD 範例）：**

```cmd
for %%f in (C:\LegacyApp\bin\*.dll) do (
    ilspycmd "%%f" -o "C:\Decompiled\%%~nf"
)
```

這樣就能把整個 bin 目錄下所有 DLL 一次性反編譯成各自的 C# 專案資料夾，不用再一支一支手動拉檔案。

## 其他可考慮的工具

| 工具 | 是否支援 CLI | 特點 |
|---|---|---|
| **ilspycmd**（ILSpy CLI） | 支援 | 免費開源、可用 dotnet tool 安裝、適合腳本化批次處理 |
| **dotPeek** | 不支援原生 CLI | JetBrains 出品，主要是 GUI，但可用命令列匯出符號檔（有限） |
| **dnSpy / dnSpyEx** | 部分支援 | 主要 GUI 操作，社群 fork（dnSpyEx）仍在維護 |
| **Telerik JustDecompile** | 不支援 CLI | 免費但主要 GUI |
| **.NET Reflector** | 不支援 CLI | 商業授權，主要 GUI |

## 補充建議

1. **確認 DLL 是否有混淆（Obfuscation）**：如果原廠商曾對 DLL 做過 obfuscate，反編譯出來的程式碼會非常難讀（變數名稱亂碼、控制流程被打亂），這種情況需要搭配 de4dot 之類的反混淆工具先處理。
2. **著作權與授權注意事項**：雖然技術上可行，但反編譯他人開發的商業軟體涉及授權合約與智慧財產權問題，建議先確認貴公司與原廠商之間的合約條款，是否允許在無維護合約狀態下進行反編譯與後續維護，避免法律風險。
3. **.NET Framework 3.5 相容性**：ilspycmd 對舊版 .NET Framework（含 3.5）的 DLL 支援度良好，因為它主要是基於 CIL bytecode 分析，跟目標 framework 版本關聯不大。

如果你可以提供這些 DLL 的存放路徑結構或是否有混淆處理，我可以再協助寫出更完整、可直接執行的批次腳本。





# 32 bit 也可以嗎?



可以。**32 位的 .NET Framework 3.5 DLL 通常可以用 ILSpy／`ilspycmd` 反編譯**，不需要先在 32 位 Windows 上執行。

## 常見情況

| DLL 類型 | 64 位 Windows 上反編譯 |
|---|---|
| 純 C#／VB.NET、32-bit（x86） | 可以 |
| AnyCPU .NET DLL | 可以 |
| C++/CLI 混合模式 DLL | 可能需要額外處理 |
| 純原生 C/C++ DLL | 不能還原成完整 C# 原始碼 |

反編譯主要是讀取 DLL 裡的 **IL/CIL 與 .NET metadata**，並不是執行該 DLL，因此 DLL 是 x86 通常不會造成問題。

## 命令列範例

```cmd
ilspycmd "C:\LegacyApp\bin\OldApp.dll" -o "C:\Decompiled\OldApp"
```

批次處理：

```cmd
for %%f in ("C:\LegacyApp\bin\*.dll") do (
    ilspycmd "%%f" -o "C:\Decompiled\%%~nf"
)
```

如果希望輸出 Visual Studio 專案，可視 `ilspycmd` 版本使用：

```cmd
ilspycmd "C:\LegacyApp\bin\OldApp.dll" -p -o "C:\Decompiled\OldApp"
```

## 需要注意的例外

1. **`ilspycmd` 本身的執行環境**
   - 在 64 位 Windows 上處理 32 位 .NET DLL，通常沒有問題。
   - 如果你的電腦本身是 32 位 Windows，則要確認所安裝的 `dotnet` runtime 和 `ilspycmd` 版本是否支援 32 位環境。
   - 建議在 64 位 Windows 上執行，即使目標程式是 32 位。

2. **混合模式 DLL**
   有些 C++/CLI DLL 同時包含 managed 和 native code。這類 DLL 可能無法像純 C# DLL 一樣完整反編譯，通常只能看到部分 managed 程式碼。

3. **相依 DLL**
   如果程式引用其他自訂 DLL，最好把整個 `bin` 目錄一起保留。必要時可用 `--referencepath` 指定相依組件位置，例如：

   ```cmd
   ilspycmd "C:\LegacyApp\bin\MainApp.dll" ^
     -r "C:\LegacyApp\bin" ^
     -o "C:\Decompiled\MainApp"
   ```

4. **原始碼不會完全恢復**
   類別與方法邏輯通常可以恢復，但以下內容可能無法完整還原：

   - 原始變數名稱
   - 註解
   - 原始專案設定
   - `app.config`、資源檔、安裝程式
   - 被混淆過的程式碼
   - 編譯前的檔案結構與版本控制資訊

簡單說，**32-bit 的 C# .NET Framework 3.5 DLL 可以批次反編譯；在 64-bit Windows 上執行 `ilspycmd` 通常是最方便的做法**。




## 参考资料

1. [DLL Decompiler Online - Decompile .NET DLL Files - Decompiler.com](https://www.decompiler.com/dll) 
