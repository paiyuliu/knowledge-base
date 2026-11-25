# Git 分支與共同祖先筆記

這份筆記整理兩件事：多項功能同時開發時如何選擇分支起點，以及如何只檢視幾個分支自共同祖先之後的歷史。以下名稱與網址均為示例，使用時請換成自己的專案設定。

## 一、分支應從哪裡開？

以**預計發布時要接續的正式版本**為起點。若團隊的 `production` 是目前正式環境，而 `main` 在正式環境穩定後才同步，新的功能分支通常從 `production` 開。只有確認 `main` 和 `production` 指向同一提交時，從兩者開分支才等效。

```bash
git fetch origin
git rev-parse origin/main origin/production
git switch -c feature/a origin/production
```

`develop` 可以作為測試整合分支，但它可能含有尚未核准上線的功能。因此，從 `develop` 開新的獨立功能分支，會把那些功能納入新分支的祖先歷史。

### 測試與發布

1. 每個需求各開一支功能分支，從同一個正式版本起點開發。
2. 完成後將功能分支合併到 `develop` 測試。
3. 若 `develop` 的**所有內容**都已核准上線，可將它合併到 `production`。
4. 若 `develop` 尚有未核准內容，將已通過測試的功能分支各自合併到 `production`。
5. 正式環境穩定後，再依團隊流程同步 `production` 與 `main`。

選擇乾淨的分支起點，並不會自動使 `develop` 變得可以整支發布。發布前仍須檢查 `production..develop` 的實際差異。

```bash
git log --oneline origin/production..origin/develop
git diff --stat origin/production..origin/develop
```

### 已從 `develop` 開發的功能，如何單獨發布？

先找出該功能在 `develop` 之後新增的提交，再從正式版本開乾淨的發布分支，依序挑入那些提交：

```bash
git log --oneline origin/develop..origin/feature/b
git switch -c feature/b-release origin/production
# 以下兩個 ID 僅為範例；請換成上一行找到的實際提交
git cherry-pick abc1234 def5678
```

`cherry-pick` 時應按原始先後順序操作，並檢查衝突與結果。若兩個功能都修改了共用檔案，例如啟動設定、權限 SQL 或選單，須逐段確認每個變更屬於哪個功能。不要只根據「新增檔案」判斷功能範圍；既有檔案的修改也可能是功能必需的一部分。

## 二、找出多個分支的共同祖先

`git merge-base --octopus` 可找出多個分支的共同祖先；它表示分支在歷史中的共同起點，**不是**最早的一筆提交，也不代表那之後的所有提交都適合發布。

若只需分析歷史，並希望減少檔案內容的下載量，可先做部分複製：

```bash
git clone --filter=blob:none --no-single-branch \
  https://example.com/your-org/your-repo.git repo
cd repo
git config core.quotepath false
```

`--filter=blob:none` 先取得提交和目錄結構，檔案內容會在需要時下載。伺服器必須支援部分複製；若不支援，改用一般 `git clone --no-single-branch`。`core.quotepath false` 讓中文路徑在 Git 輸出中較易閱讀。

假設要比較下列五個遠端分支：

```bash
COMMON=$(git merge-base --octopus \
  origin/main \
  origin/develop \
  origin/production \
  origin/feature/a \
  origin/feature/b)

printf '共同祖先：%s\n' "$COMMON"

git log --graph --oneline --decorate --boundary \
  origin/main origin/develop origin/production \
  origin/feature/a origin/feature/b ^"$COMMON"
```

最後一個指令只顯示指定分支在共同祖先**之後**的提交；`--boundary` 會將被排除的邊界提交標示出來。若 `COMMON` 為空，先確認遠端分支名稱是否正確，以及這些分支是否有共同歷史。

### 「只顯示」與「只保留」是兩回事

上述 `git log` 只是限制畫面上顯示的歷史；儲存庫內仍可能保有更早的提交。`--filter=blob:none` 減少的是檔案內容下載量，也不是按共同祖先裁切提交歷史。

淺層複製的 `--depth` 或 `--shallow-since` 可在**重新複製時**限制取得的歷史，但前者按提交深度、後者按時間，不能保證恰好停在多分支共同祖先。對已補齊歷史的儲存庫執行 `git fetch --shallow-since=...`，也不等於把舊歷史精確刪除。若目的只是閱讀各分支交集後的紀錄，使用上面的共同祖先與 `git log` 範圍即可。

## 發布前的簡短檢查

- 功能分支的起點是否為預期的正式版本？
- `develop` 是否還有不打算隨本次發布上線的提交？
- 需單獨發布的功能是否只含自己的提交與共用檔案變更？
- `production` 與 `main` 是否已依團隊流程同步？
