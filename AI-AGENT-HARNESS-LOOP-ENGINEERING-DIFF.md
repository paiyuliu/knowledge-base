> From: google search

# you asked

message time: 上午9:00

ai agent = harness + LLM ai agent = (loop engineering) + LLM 所以 loop engineering 就是 harness 嗎?

---

# googlesearch response

**不是完全一樣。** Loop Engineering（迴圈工程）與 Harness Engineering（駕馭工程）是 AI Agent 進化過程中的**不同層次與概念**，不能直接劃上等號。

兩者的關係與差異

-   **Harness Engineering（駕馭工程）**：
    -   **定義**：指將 LLM 包裹起來的「外圍骨架與環境」。包含：定義模型能呼叫哪些工具、設定權限邊界、提供系統提示詞、攔截錯誤、以及管理記憶與人工介入（Human-in-the-loop）。
    -   **核心公式**：`Agent = Model + Harness`。
    -   **目的**：解決「能不能管得動」的問題，確保 Agent 在執行任務時不會亂改資料、失控或變成黑盒。
-   **Loop Engineering（迴圈工程）**：
    -   **定義**：在 Harness 所建構的環境與架構之上，進一步設計讓 Agent **自己自動化跑迴圈**的機制（觀察 -> 執行 -> 檢查結果 -> 自我修正 -> 再執行，直到達成停止條件）。
    -   **目的**：解決「如何持續推進並完成任務」的問題，讓 AI 不再需要人類逐次手動按 Enter 下指令，而是自己迭代、試錯與驗證。

演進順序

在當前的 AI 工程脈絡中，這兩者是**疊加演進**的關係（從基礎到上層）：

1.  **Prompt Engineering**（提示工程：怎麼問）
2.  **Context Engineering**（上下文工程：餵對背景資料）
3.  **Harness Engineering**（駕馭工程：提供工具、邊界與安全網）
4.  **Loop Engineering**（迴圈工程：讓 Agent 在環境裡自動循環迭代直到完成）

簡單來說：**Harness 是「幫 Agent 蓋好一個安全、有工具的工作場地」；而 Loop 是「讓 Agent 在這個場地裡自己動起來、重複做到好」。**

如果你正準備開發或導入 AI Agent，我可以幫你解析：

-   **你目前使用的框架**（如 Claude Code 或 LangChain）屬於哪一個工程層次
-   如何為你的任務**設計適合的 Hook 與回饋機制**

---

# you asked

message time: 上午9:01

所以現在所說的 BMAD 是這上述中的其中一項觀念嗎?

---

# googlesearch response

是的，**BMAD 完整涵蓋並實踐了上述所有的觀念**。

[BMAD-METHOD（Breakthrough Method for Agile AI-Driven Development）](https://github.com/bmad-code-org/BMAD-METHOD) 是目前 AI 開發（AI-driven development）中最火熱的**敏捷 AI 團隊框架**。它專門為了解決只靠感覺與 AI 盲目對話的「氛圍開發（Vibe Coding）」亂象。

如果將 BMAD 拆解，你會發現它完美對應了我們先前討論的演進層次：

1\. BMAD 的環境基礎 ＝ Harness Engineering

在 BMAD 中，它不讓單一的 LLM 當成「全能助手」。相反地，它透過 Markdown 檔案（如 `.cursorrules` 或 `agents.md`）定義了多個**具備特定專業的角色（Persona）**，例如 BMAD-Master（主導者）、PM、Architect（架構師）、Dev（開發）、QA（測試）。

-   **如何對應**：這就是 **Harness Engineering（駕馭工程）** 的展現。BMAD 幫 AI 蓋好了工作場地，精準限制了每個 AI 角色只能拿到的上下文（Context）與能動用的工具，設定好權限邊界，不讓 AI 在開發時越權失控。

2\. BMAD 的運作核心 ＝ Loop Engineering

BMAD 的精髓在於它的**多智能體協同（Multi-Agent Flow）**。當你要開發一個功能時，它會按照 YAML 藍圖定義好的工作流，讓不同的 AI 角色「跑起自動化迴圈」：

```
[PM 產出 PRD] ➔ [Architect 設計架構] ➔ [Dev 寫程式] ➔ [QA 自動測試與抓錯] ➔ (發現錯誤) ➔ 回到 Dev 修正
```

-   **如何對應**：這就是標準的 **Loop Engineering（迴圈工程）**。AI 角色們在各自的 Harness 邊界內，彼此交接文件（Handoff），自己觀察結果、互相檢查 work（自我修正）、循環迭代直到測試完全通過才停下來。

* * *

總結

BMAD 不是其中單一的一項，而是**「利用 Harness Engineering 來封裝角色，並透過 Loop Engineering 把這些角色串成一條自動化敏捷流水線」的完整方法論**。

你目前是否正嘗試導入 **BMAD** 來管理你的 AI 寫程式流程呢？

-   如果是，你目前使用的是哪款 IDE 工具（例如 **Cursor**、**Windsurf** 或 **Claude Code**）？
-   你在設定 `agents.md` 或分配 AI 角色權限時有遇到什麼瓶頸嗎？

---
Powered by [AI Exporter](https://saveai.net)