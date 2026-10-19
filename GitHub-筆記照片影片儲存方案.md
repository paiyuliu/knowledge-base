# GitHub 筆記的照片、影片與長期儲存方案

> 對話整理日期：2026-10-19。容量、價格與服務條款可能變動，實際使用前請以文末官方資料為準。

## 問：未來這個 repo 會放水電學習筆記，預期有很多照片和影片。GitHub repo 有容量上限，怎麼解決？

**答：讓 GitHub 管筆記與少量壓縮圖片，把原始照片和影片放在外部儲存。**

目前這個 repo 的 Git 資料約 7.2 MiB，還很小。GitHub 對一般 Git 檔案超過 50 MiB 會提出警告，超過 100 MiB 會拒絕；官方建議 repository 最好低於 1 GB。已提交的大檔即使日後從工作目錄刪除，仍會留在 Git 歷史中。

| 內容 | 建議存放方式 |
| --- | --- |
| Markdown 筆記、圖表 | 直接放 repo |
| 筆記中要顯示的照片 | 縮小、壓縮後放 repo，例如每張約 0.2–1 MB；或放在有穩定公開網址的物件儲存 |
| 原始照片、長影片 | 放外部儲存，在筆記中附連結 |
| 少量必須隨 repo 一起下載的大檔 | 考慮 Git LFS |

Git LFS 能處理大檔，但 GitHub Free 目前包含 10 GiB 儲存與每月 10 GiB 下載流量。檔案每次更新都會計入新版本的儲存用量，因此大量照片、影片持續增加時仍可能碰到額度。現階段先不需要導入 Git LFS。

筆記範例：

```md
![配電箱接線近照](images/配電箱-接線-縮圖.jpg)

[觀看操作影片](https://你的影片或雲端儲存連結)
[下載原始照片](https://你的原始檔連結)
```

## 問：除了 Google Drive，網路上有哪些地方能長期放檔案？也可以在三大雲平台架類似 EC2 的伺服器，用指令和 AI agent 操作。

**答：優先選物件儲存，不必為了放檔案先架 VM。**物件儲存可透過 CLI、API 或 AI agent 上傳，容量可隨需求增加，也省去維護作業系統和磁碟的工作。

| 選項 | 適合情況 | 2026-10 查得的費用重點 |
| --- | --- | --- |
| Cloudflare R2 | 筆記中的照片、影片要透過網址提供觀看或下載 | Standard 每月含 10 GB 儲存；超過後 US$0.015/GB／月，直接由 R2 對外傳輸不收流量費；讀寫操作另有計價與免費額度 |
| Backblaze B2 | 大量原始照片、影片，主要供自己備份與取回 | 前 10 GB 免費；付費容量價格較低，免費下載流量約為每月平均儲存量的 3 倍 |
| AWS S3／Azure Blob／Google Cloud Storage | 已在該平台使用其他服務，想統一帳號與權限 | 應合併估算儲存、請求、下載流量及冷儲存取回費用 |

### 建議架構

```text
GitHub repo                 Markdown 筆記、少量縮圖
R2 公開區                   筆記要顯示的照片、供觀看的影片
R2 私有區或 B2              原始照片、原始影片
本機或另一家雲端             第二份備份
```

例如筆記可引用固定網址：

```md
![插座配線](https://media.example.com/wiring/outlet-01.jpg)
```

R2 支援 S3 相容工具與 CLI 批次上傳。若公開網址要長期使用，建議綁自己的網域；Cloudflare 的 `r2.dev` 網址定位為測試用途。公開照片與私人原檔應分開管理存取權限。VM 可留待日後需要轉檔或其他運算工作時再用。

無論選哪一家服務，仍應保留第二份獨立備份，並定期確認檔案能取回。雲端服務無法防止自己誤刪檔案或失去帳號存取權。

## 官方資料

- [GitHub：一般 Git 大檔與 repository 大小建議](https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github)
- [GitHub：Git LFS 用量與免費額度](https://docs.github.com/en/billing/concepts/product-billing/git-lfs)
- [Cloudflare R2：價格與免費額度](https://developers.cloudflare.com/r2/pricing/)
- [Cloudflare R2：使用方式](https://developers.cloudflare.com/r2/get-started/)
- [Cloudflare R2：公開 bucket 與自訂網域](https://developers.cloudflare.com/r2/buckets/public-buckets/)
- [Backblaze B2：價格](https://www.backblaze.com/cloud-storage/pricing)
- [AWS S3：價格](https://aws.amazon.com/s3/pricing/)
- [Google Cloud Storage：價格](https://cloud.google.com/storage/pricing)
