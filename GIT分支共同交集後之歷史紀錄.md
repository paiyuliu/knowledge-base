# Git 淺層複製（Shallow Clone）並僅保留分支共同交集後之歷史紀錄

## 需求背景
* 從 Gitea 複製（Clone）專案的多個分支（包含中文名稱分支）。
* **不下載完整歷史紀錄（Log）**，僅從這幾個分支「最早有交集的 Commit（`merge-base`）」開始保留紀錄，以節省下載時間與硬碟空間。

### 目標分支清單
1. `main`
2. `develop`
3. `Production`
4. `feature_A功能`
5. `feature_B功能`

---

## 執行步驟（Bash / macOS / Linux / Git Bash）

請將 `<your-gitea-repo-url>` 與 `<repository-name>` 替換為你的實際專案資訊後，依序執行以下指令：

```bash
# 1. 淺層複製所有分支（每個分支先只抓最新 1 筆 commit，速度極快）
git clone --depth=1 --no-single-branch <your-gitea-repo-url>
cd <repository-name>

# 2. 確保中文路徑與分支名稱在終端機正常顯示（避免變成 \345\230... 亂碼）
git config core.quotepath false

# 3. 只抓取 commit 歷史樹狀結構（不含實體檔案內容，傳輸量極小），以便計算交集
git fetch --filter=blob:none --unshallow

# 4. 明確指定這 5 個分支，找出它們最早的共同交集 commit (merge-base)
COMMON_COMMIT=\$(git merge-base --octopus \
  origin/main \
  origin/develop \
  origin/Production \
  origin/feature_A功能 \
  origin/feature_B功能)

echo "共同交集 Commit: \$COMMON_COMMIT"

# 5. 將歷史紀錄精準截斷在該交集 commit 的時間點
git fetch --shallow-since=\((git show -s --format=\%ct\)COMMON_COMMIT)

# 6. 清理多餘的暫存結構與未使用的物件，釋放硬碟空間
git reflog expire --expire=now --all
git gc --prune=now

# 7. 建立這 5 個分支的本地追蹤（若預設分支已存在會自動略過）
for b in main develop Production feature_A功能 feature_B功能; do
    git branch --track "b" "origin/b" 2>/dev/null
done

# 8. 驗證結果：查看精簡後的 5 個分支樹狀圖
git log --oneline --graph --all
```

---

## 關鍵參數與注意事項

| 指令 / 參數 | 作用說明 |
| :--- | :--- |
| `--depth=1 --no-single-branch` | 抓取所有遠端分支的最新 1 筆 Commit，而非只抓預設分支。 |
| `core.quotepath false` | 避免終端機將中文字元轉義為八進位編碼，確保中文分支名稱能正常比對。 |
| `--filter=blob:none --unshallow` | 僅補齊 Commit 歷史關聯圖（不下載檔案實體），用來計算最早交集點。 |
| `git merge-base --octopus` | 同時比對多個分支，找出它們在歷史樹中最早分岔的共同祖先 Commit。 |
| `--shallow-since=<timestamp>` | 依指定時間點截斷更早之前的歷史紀錄。 |
| `2>/dev/null` | 隱藏預設分支（如 `main`）在建立追蹤時因「已存在」而跳出的提示訊息。 |

### 常見排錯
* **若 Gitea 版本較舊不支援 `--filter=blob:none`**：步驟 3 若出現不支援 partial clone 的錯誤，請直接改用標準的 `git fetch --unshallow` 即可正常運作。
* **若某分支完全獨立（無共同交集）**：`git merge-base --octopus` 會回傳空值，此時需先排除該獨立分支再計算交集。
