# Ollama 可用模型整理（OCR / 發票 / ABC Notation）

以下整理自 `ollama_影像辨識_OCR_abc_notation.md` 與 `ollama_影像辨識_OCR_invoice_統一發票.md` 中，適合在 Ollama server 直接使用的模型。

## 影像 OCR / 文件辨識

| 模型 | 主要用途 | 備註 |
| --- | --- | --- |
| MiniCPM-V（如 MiniCPM-Llama3-V 2.5 / 2.6） | 中文 OCR、複雜版面文件、發票辨識 | 對高解析度圖片與細小中文字表現佳 |
| GLM-OCR | 複雜文件理解、表格 / 圖表 / 中文文件 OCR | 中文語境支援強 |
| Llama 3.2 Vision | OCR、圖片文字提取、發票辨識 | Ollama 常用視覺模型 |
| LLaVA | OCR、圖片文字提取 | 常與 Ollama-OCR 搭配 |
| Qianfan-OCR | 直接將圖片轉成 Markdown | 適合保留文件結構 |

## 樂譜 / ABC Notation / 簡譜

| 模型 | 主要用途 | 備註 |
| --- | --- | --- |
| Qwen2-VL（如 qwen2-vl:7b） | 樂譜轉 ABC Notation、簡譜、雙格式輸出 | 兩份筆記中都列為最推薦 |
| Llama 3.2 Vision | 樂譜轉 ABC Notation、簡譜 | 輕量備選 |
| ChatMusician（llamusic） | ABC 樂譜生成 / 音樂內容生成 | 偏向音樂生成，不是 OCR 主力 |

## 發票辨識建議

- 發票（含台灣統一發票、手寫發票）可直接用 `MiniCPM-V` 或 `Llama 3.2 Vision` 做視覺辨識。
- 若要更穩定的欄位抽取，建議搭配 OCR + LLM 流程，而不是只靠單一模型。

## 樂譜辨識建議

- 要同時輸出 ABC Notation 與簡譜，優先選 `Qwen2-VL`。
- 若只要 ABC Notation，`Qwen2-VL` 與 `Llama 3.2 Vision` 都可用。

## 補充

- `Taiwan-LLM`、`Breeze` 這類模型在筆記中主要是純文字模型，不算這次整理的 Ollama 影像辨識模型。
- `Omnizart`、`Basic Pitch` 屬於 MP3/MIDI 轉譜工具，不是 Ollama 模型。
