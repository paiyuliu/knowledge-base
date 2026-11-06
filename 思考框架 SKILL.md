# 思考框架 SKILL

# you asked

有沒有人將這些框架轉成可以跟 AI 互動的 skill https://www.managertoday.com.tw/magazine/view/129113

---

# googlesearch response

是的，目前國內外已經有非常多開發者與企業，將這類商管思考框架轉化為 AI 的互動 Skill（通常稱為 GPTs、AI Agents 或 Prompt Templates）。
在 AI 時代，這種做法通常被稱為「框架式 Prompt（Framework-based Prompting）」或「結構化 Agent」。像是您提到的 OpenSpec 或 Spec Kit 的概念，在 AI 領域最直接的對應就是 GitHub 上的 Prompt 開源專案或 ChatGPT Plus 的 GPTs 商店。
以下為您整理目前市面上如何將這些框架與 AI 互動結合，以及您可以如何直接使用的管道：

1. 國外開源的「AI 思考框架 Spec」

在 GitHub 上，有幾個非常著名的專案，專門把這些商管與邏輯框架「規格化」成 AI 聽得懂的語法：
• LangChain / LangFlow: 許多開發者會用它將「MECE」、「邏輯樹」或「5個為什麼」寫成一條自動化的 AI 工作流。
• Jina AI / Prompt Engineering 專案: 國外有許多開源的 System Prompt 庫，把「六頂思考帽」或「五力分析」寫成結構化的 JSON 或 Markdown 格式（就像 OpenSpec 一樣），讓 AI 可以嚴格遵守框架來與你對話。

2. 現成的 AI 互動 Skill 平台

如果你不想自己寫程式，以下平台已經有人做好了現成的互動 Skill：
• ChatGPT - GPTs 商店 (GPT Store)
	• 在 ChatGPT 內搜尋「Strategic Frameworks」、「Consulting Frameworks」或「MECE Bot」，就能找到無數個被包裝成 Skill 的 AI。
	• 例如：輸入一個商業點子，它會自動啟動「SWOT + 5力分析」的雙重框架來拷問你。
• Coze (扣子) / Dify
	• 這兩個是目前最流行的 AI Agent 創建平台。上面有大量繁體中文的社群插件。
	• 你可以搜尋「經理人工具箱」或「麥肯錫思考法」，通常會有現成的 Agent，它會引導式地問你：「請輸入你的問題，接下來我們將用 MECE 與邏輯樹來拆解...」。

如何自己把這些框架變成 AI Skill？（附 OpenSpec 範例）

如果您想把《經理人》的這 7 大 PART 框架變成專屬的 AI Skill，您不需要寫程式，只需要用 Markdown 結構化語法（類似 Spec）來定義 AI 的行為。
以下為您示範如何將 「016 豐田5次為什麼」 與 「022 6頂思考帽」 寫成可互動的 AI Skill Spec。您可以直接複製這段文字，貼給 ChatGPT、Claude 或 Custom GPT 的 Instructions（指令區）：

```markdown
# Role: 商業框架思考專家 (Business Framework Skill)

## Profile
你是一個精通商管框架的 AI 互動教練。你的任務是引導使用者使用結構化思維解決問題。

## Skills Configuration

### [SKILL_016: 豐田5次為什麼]
- **觸發條件**: 使用者想要「找問題根本原因」時。
- **互動規則**:
  1. 不要一次給出所有答案。
  2. 請使用者提出一個具體問題。
  3. 針對使用者的回答，連續追問 5 次「為什麼？」，每次追問都要基於上一次使用者的回答。
  4. 最終總結核心病因與對策。

### [SKILL_022: 6頂思考帽]
- **觸發條件**: 使用者需要「創意發想或做決策」時。
- **互動規則**:
  1. 帶領使用者輪流戴上不同的帽子（白、紅、黑、黃、綠、藍）。
  2. 每一輪對話只專注於一種帽子的思考（例如：戴上黑帽時，要求使用者與AI一起瘋狂挑毛病、找風險）。
  3. 嚴格禁止思維混亂，必須一頂一頂帽子依序進行。

## Execution Process
1. 歡迎使用者，並請他們從清單中選擇一個想要使用的框架（例如：PDCA, SWOT, 5 Whys...）。
2. 當使用者選擇後，啟動該框架的 Spec 互動規則，開始引導式對話。
```
請謹慎使用程式碼。

您目前是希望尋找現成做好的 AI 工具直接使用，還是希望學會如何把這份《經理人》的清單寫成 Prompt 規格書（Spec），好讓您建立自己專屬的 ChatGPT 機器人呢？

---

# you asked

那 TRIZ 有人做嗎

---

# googlesearch response

有的，而且 TRIZ（萃思發明問題解決理論）在 AI 領域的「Skill 化」和「Agent 化」程度，甚至比前面提到的基礎商管框架還要更深、更硬核！
因為 TRIZ 本身就是一套高度結構化、演算法化的發明理論（包含 40 個發明原則、矛盾矩陣、技術矛盾與物理矛盾等），這種「規則明確」的特性極度適合被寫成 AI 的 Skill Spec。 [1] (https://intellectual-integration-innovation.blogspot.com/2025/06/triz-ai.html)
目前國內外在 TRIZ 結合 AI 的發展上，已經有非常成熟的開源專案、Prompt 規格書（Spec）以及多 Agent 工作流：

1. 國外開源的 TRIZ Prompt Spec（規格書）

在 GitHub 上有幾個非常著名的開源專案，完全符合您提到的「Spec 套件」概念，把 TRIZ 拆解成 AI 聽得懂的標準規格：
• triz-prompt-engineering (GitHub)：這是一個專門將 TRIZ 提示詞規格化（使用乾淨的 XML 格式）的開源庫。它將 TRIZ 的「功能導向搜尋 (FOS)」、「方法導向搜尋 (MOS)」等核心技術，封裝成一包一包開箱即用的 AI 提示詞 Spec。 [1] (https://github.com/jenson500/triz-prompt-engineering)
• truinorva / triz-skills (GitHub)：這個專案直接把 TRIZ 的各種工具（技術矛盾分析、理想解 IFR、40個發明原則、資源分析）做成專屬於 AI 的個別 "Skills" 資料夾，讓開發者或使用者能像調用模組一樣，直接塞給 AI 使用。 [1] (https://github.com/topics/triz), [2] (https://github.com/truinorva/triz-skills)

2. 演進到「多 AI Agent (Multi-Agent)」的硬核應用

因為 TRIZ 流程很長，現在社群更傾向於用多個 AI 分工（Agentic Workflow）來跑 TRIZ： [1] (https://arxiv.org/abs/2506.18783), [2] (https://github.com/topics/triz)
• triz-engine (GitHub)：這是一個結合 MCP (Model Context Protocol) 伺服器的架構。當你輸入一個工程難題（例如：如何減輕重量卻不損失強度？），它會在後台自動啟動 矛盾分析 Agent → 尋找解答 Agent → 評估驗證 Agent 的管線化作業。 [1] (https://github.com/SharathSPhD/triz-engine/blob/main/README.md)
• InnovateTRIZ & Patent-GPT (GitHub)：這類專案將 TRIZ 與專利分析（RAG）結合。AI Agent 會先用 TRIZ 幫你發想創新解法，再自動去查專利資料庫，避開專利侵權風險，直接輸出結構化的專利草稿。 [1] (https://github.com/topics/triz)

💡 您可以直接複製使用的「TRIZ 技術矛盾 Skill Spec」

如果您想在 ChatGPT、Claude 或自建的 AI Agent 中直接調用 TRIZ，可以使用以下這段仿照 OpenSpec 結構設計的 系統提示詞 (System Prompt)：

```markdown
# Role: TRIZ 系統化創新專家 (TRIZ Innovation Agent)

## Profile
你是一個精通 Altshuller 的 TRIZ（發明問題解決理論）的 AI 教練。你的任務是引導使用者拆解工程或商業上的技術矛盾，並引導出創新的解決方案。

## Skill: [SKILL_TRIZ_CONTRADICTION]
- **目標**: 解決「既想要 A，但又會導致 B 變差」的技術矛盾。
- **互動流程**:
  1. **問題定義**: 請使用者用一句話描述他們遇到的物理或技術挑戰。
  2. **矛盾提取**: 幫使用者將問題轉化為標準的 TRIZ 矛盾：
     - *改善的參數* 是什麼？（例如：速度、強度、自動化程度）
     - *惡化的參數* 是什麼？（例如：重量、成本、複雜度）
  3. **矩陣查詢與發明原則提示**:
     - 根據這對矛盾，模擬 TRIZ 39×39 矛盾矩陣。
     - 挑選出 2-3 個最相關的「TRIZ 40個發明原則」（例如：分割原則、動態性原則、不對稱原則）。
  4. **引導構想**: 不要直接給答案，每次提供一個發明原則，並針對使用者的產品提供具體的「聯想提問」，引導使用者自己想出解法。

## 邊界限制
- 嚴格禁止一次性倒出所有矩陣結果。
- 必須採用引導式對話（Interactive），等使用者回應完上一步，再進行下一步。
```

請謹慎使用程式碼。

現在不論是企業端的研發團隊，還是個人的創新工作者，都已經把 TRIZ 從「需要人工死記、翻查大表格的厚重學門」，成功轉化為「隨時用 AI Agent 調用的創新技能組」了。 [1] (https://intellectual-integration-innovation.blogspot.com/2025/06/triz-ai.html)
您目前是想要將 TRIZ 應用在特定的專案（例如硬體研發、軟體架構、或是商業流程）上，還是想要了解如何把這個 TRIZ 提示詞直接安裝進 ChatGPT / Claude 的自訂功能（GPTs / Project）中呢？

---
