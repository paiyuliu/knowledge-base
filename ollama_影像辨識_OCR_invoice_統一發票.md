
# ollama 開源模型中 目前 哪些 適合 taiwan 繁體中文 正體中文 的 影像辨識 OCR



在 Ollama 的開源生態系中，要進行適合台灣「繁體中文（正體中文）」的影像辨識與 OCR（光學字元辨識），需要使用**視覺語言模型（Vision-Language Models, VLMs）**。雖然像 `Taiwan-LLM` 或聯發科的 `Breeze` 是專為台灣繁體中文優化的大型語言模型，但它們主要處理純文本[[1](https://www.largitdata.com/course/240/)][[2](https://ollama.com/wangrongsheng/taiwanllm-7b-v2.1-chat)]。

針對影像辨識與 OCR，目前在 Ollama 中有幾款表現優異且對中文支援度高的開源模型，您可以透過設定提示詞（Prompt）來確保其輸出符合台灣用語習慣的繁體中文：

## 推薦的 Ollama OCR 視覺模型

### 1. MiniCPM-V (如 MiniCPM-Llama3-V 2.5 / 2.6)
MiniCPM-V 系列在開源視覺模型中對 OCR 的表現非常突出。
* **優勢**：它能夠處理任意長寬比及高達 180 萬像素的高解析度圖片，這對於辨識文件上的細小中文字體非常關鍵[[3](https://github.com/imanoop7/Ollama-OCR)][[4](https://ollama.com/openbmb/minicpm-v2.5:q6_K)]。
* **特點**：在 OCRBench 測試中獲得高分，且其中文辨識能力極佳，非常適合用於複雜版面的中文文件提取[[4](https://ollama.com/openbmb/minicpm-v2.5:q6_K)]。

### 2. GLM-OCR
這是專為複雜文件理解而設計的多模態 OCR 模型[[5](https://ollama.com/library)]。
* **優勢**：基於 GLM-V 架構，GLM 系列模型本身對中文語境有極強的原生支援[[6](https://ollama.com/library/glm-ocr)]。
* **特點**：適合處理包含表格、圖表或複雜排版的中文文件。

### 3. Llama 3.2 Vision 與 LLaVA
這兩款是目前最主流且廣泛使用的開源視覺模型，常被整合於各類 OCR 工具中（如 Ollama-OCR）[[7](https://www.threads.com/@akiraxtwo/post/DEp07Z6yW4K)][[8](https://www.reddit.com/r/ollama/comments/1j3fh7d/ollamaocr/)]。
* **優勢**：Llama 3.2 Vision 具有強大的圖像推理與文字提取能力[[9](https://dev.to/bytefer/ollama-ocr-for-high-precision-ocr-with-ollama-4o31)]。
* **繁中應用**：雖然它們並非專為繁體中文訓練，但您可以透過強大的系統提示詞（System Prompt），例如強制規定「`請精準提取圖片中的文字，並一律以台灣繁體中文輸出`」，來獲得不錯的辨識效果[[3](https://github.com/imanoop7/Ollama-OCR)][[9](https://dev.to/bytefer/ollama-ocr-for-high-precision-ocr-with-ollama-4o31)]。

### 4. Qianfan-OCR
這是一款 4B 參數的視覺語言模型，專注於將圖片直接轉換為 Markdown 格式[[10](https://ollama.com/maternion/Qianfan-OCR)]。
* **優勢**：能夠取代傳統的多步驟 OCR 流程，直接進行端到端的文件數位化，適合需要保留文件結構（如標題、列表）的中文 OCR 任務[[10](https://ollama.com/maternion/Qianfan-OCR)]。

## 提升繁體中文 OCR 效果的實用技巧

如果您發現視覺模型直接輸出的繁體中文不夠道地，或者夾雜簡體字，可以採用**「兩階段處理法」**：

1. **第一階段（影像辨識）**：使用 `MiniCPM-V` 或 `GLM-OCR` 等視覺模型，先將圖片中的文字精準提取出來。
2. **第二階段（文本優化）**：將提取出的文字交給專為台灣繁體中文優化的純文本模型（如 `taiwanllm-7b-v2.1-chat` 或聯發科的 `Breeze 7b`），並下達指令：「`請將以下 OCR 辨識出的文字進行校對，修正錯別字，並轉換為流暢的台灣繁體中文`」[[1](https://www.largitdata.com/course/240/)][[2](https://ollama.com/wangrongsheng/taiwanllm-7b-v2.1-chat)]。

此外，您也可以搭配開源工具 **Ollama-OCR** 來進行實作，該工具支援 Llama 3.2 Vision、LLaVA、MiniCPM-V 等多種模型，並允許使用者自訂提示詞（Custom Prompts）與輸出格式（如 Markdown、JSON），能大幅簡化繁體中文文件的批次處理流程[[3](https://github.com/imanoop7/Ollama-OCR)][[9](https://dev.to/bytefer/ollama-ocr-for-high-precision-ocr-with-ollama-4o31)]。





# 如果需要辨識各類 invoice( 包括 taiwan 統一發票 ) 的話呢?  invoice 會有印刷及手寫，也是上面這些 model 嗎?



針對台灣各類發票（包含統一發票、二聯式、三聯式、熱感應紙及手開發票），您**確實可以使用前面提到的視覺語言模型（如 MiniCPM-V、Llama 3.2 Vision）**，但因為發票具有高度結構化且常夾雜手寫與印章的特性，在實務應用上，單純依賴單一模型往往不夠，業界目前更傾向採用**「OCR + LLM」的混合架構**或**AI 智能文件處理（AiDP）**技術[[11](https://www.ricoh.com.tw/events/invoice-process-webinar)][[12](https://github.com/stone16/Invoice-Manager)]。

以下是針對台灣發票（印刷與手寫混合）的辨識策略與模型應用建議：

## 1. 印刷與手寫發票的辨識挑戰
台灣的發票格式多樣，且經常面臨以下痛點：
* **手寫辨識率差異**：傳統 OCR（如 Tesseract）對固定版型的印刷文字辨識率可達 95% 以上，但遇到手寫、模糊或不固定版型的發票時，辨識率可能暴跌至 60% 以下[[13](https://nabi.104.com.tw/posts/nabi_post_bd9ede2e-adcd-4db2-862b-35e3f1a6790a)]。
* **AI 視覺模型的優勢**：導入 AI OCR 後，對於台灣繁體手寫發票的辨識率約可提升至 75% 到 90%[[13](https://nabi.104.com.tw/posts/nabi_post_bd9ede2e-adcd-4db2-862b-35e3f1a6790a)]。前面提到的 **MiniCPM-V** 等模型，因為具備強大的圖像理解能力，對於手寫字跡、熱感應紙褪色或非標準格式的發票，確實能提供比傳統 OCR 更好的辨識效果[[11](https://www.ricoh.com.tw/events/invoice-process-webinar)]。

## 2. 實務最佳解法：「OCR + LLM」雙重驗證
如果直接把發票圖片丟給視覺模型（VLM）並要求輸出 JSON，有時會遇到模型「幻覺」或漏抓欄位。目前開源社群與商業方案最推薦的做法是 **OCR + LLM 雙源驗證**[[12](https://github.com/stone16/Invoice-Manager)]：

* **步驟一（精準定位與提取）**：先使用專門針對排版與文字偵測優化的開源 OCR 工具（例如 `PaddleOCR` 或 `Surya OCR`），將發票上的所有文字（包含手寫與印刷）與座標精準抓取出來[[14](https://www.reddit.com/r/LocalLLaMA/comments/1jcm5p2/ocr_llm_for_invoice_extraction/?tl=zh-hant)]。
* **步驟二（資料結構化與校正）**：將抓取到的生硬文字，交給 Ollama 運行的純文本大型語言模型（如 `Llama 3` 或 `Taiwan-LLM`），並透過提示詞要求模型提取關鍵欄位（如：發票號碼、買賣方統編、總金額、明細、日期），同時讓 LLM 自動校正 OCR 辨識錯誤的錯別字[[12](https://github.com/stone16/Invoice-Manager)]。

## 3. 針對發票推薦的開源模型配置
如果您希望完全在本地端透過 Ollama 處理發票：
* **端到端視覺提取**：可以直接使用 **MiniCPM-V 2.6** 或 **Llama 3.2 Vision**，並設定強提示詞（Prompt）：「`這是一張台灣統一發票，請辨識圖片中的印刷與手寫文字，並以 JSON 格式輸出：發票號碼、統編、金額。`」
* **排版解析輔助**：對於明細行（Line Items）特別多、表格複雜的三聯式發票，建議搭配 `LayoutParser` 等工具先進行版面分析，再進行文字辨識，以確保金額與品名能正確對應[[14](https://www.reddit.com/r/LocalLLaMA/comments/1jcm5p2/ocr_llm_for_invoice_extraction/?tl=zh-hant)]。

**總結來說**，前面提到的模型完全適用於發票辨識，但由於手寫發票的 AI 辨識率極限約在 90% 左右，實務上建議結合 RPA（流程自動化）並保留「人工複核介面」，針對低信心度的欄位（如潦草的手寫金額）進行最後確認，才能確保財務入帳的 100% 準確性[[13](https://nabi.104.com.tw/posts/nabi_post_bd9ede2e-adcd-4db2-862b-35e3f1a6790a)][[11](https://www.ricoh.com.tw/events/invoice-process-webinar)]。




## 参考资料

1. [[AI人工智慧] 使用Ollama 調用本地語言模型生成文章並且辨識圖片內容](https://www.largitdata.com/course/240/) 
2. [wangrongsheng/taiwanllm-7b-v2.1-chat - Ollama](https://ollama.com/wangrongsheng/taiwanllm-7b-v2.1-chat) 
3. [imanoop7/Ollama-OCR - GitHub](https://github.com/imanoop7/Ollama-OCR) 
4. [openbmb/minicpm-v2.5:q6_K - Ollama](https://ollama.com/openbmb/minicpm-v2.5:q6_K) 
5. [library - Ollama](https://ollama.com/library) 
6. [glm-ocr - Ollama](https://ollama.com/library/glm-ocr) 
7. [Ollama-OCR 是一款功能強大的光學字符識別（OCR）工具 ... - Threads](https://www.threads.com/@akiraxtwo/post/DEp07Z6yW4K) 
8. [Ollama-OCR - Reddit](https://www.reddit.com/r/ollama/comments/1j3fh7d/ollamaocr/) 
9. [Ollama-OCR for High-Precision OCR with Ollama - DEV Community](https://dev.to/bytefer/ollama-ocr-for-high-precision-ocr-with-ollama-4o31) 
10. [maternion/Qianfan-OCR - Ollama](https://ollama.com/maternion/Qianfan-OCR) 
11. [AI OCR 升級實戰：手寫發票付款申請流程自動化× 限量封測研討會](https://www.ricoh.com.tw/events/invoice-process-webinar) 
12. [Invoice Manager - 基于OCR + LLM 进行发票管理 - GitHub](https://github.com/stone16/Invoice-Manager) 
13. [RPA + OCR 自動處理發票｜每月省80 工時 - 104學習精靈](https://nabi.104.com.tw/posts/nabi_post_bd9ede2e-adcd-4db2-862b-35e3f1a6790a) 
14. [OCR + LLM 提取發票資訊: r/LocalLLaMA - Reddit](https://www.reddit.com/r/LocalLLaMA/comments/1jcm5p2/ocr_llm_for_invoice_extraction/?tl=zh-hant) 
