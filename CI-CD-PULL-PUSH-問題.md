> From: https://www.google.com/search?q=ci+cd+%E4%BD%88%E7%BD%B2%E4%B8%8A%EF%BC%8C%E5%88%B0%E5%BA%95%E6%98%AF%E5%9C%A8+git+server+%E4%B8%8A%E5%9F%B7%E8%A1%8C%EF%BC%8C%E9%82%84%E6%98%AF%E5%9C%A8+target+server+%E4%B8%8A+pull+git+repo+%E5%BE%8C%E5%9F%B7%E8%A1%8C%3F&sca_esv=f41a325adc193426&sxsrf=APpeQnvMUwvnvWIRwN9f8bnYkYC2lsiI1Q%3A1792386406110&ei=O6XVav2uKYvJ1e8Pw_bwkAw&iflsig=ABILxe8AAAAAatWzS48hGzA6cmmbJDoeYS2NA7wlwuU_&uact=5&sclient=gws-wiz&udm=50&fbs=ABfTbFUhNGvvPEUFOvrsPMHwBXgOBaujescnqPHvnnJ8fnHu17PbcurfovuKKjl7m0lU4CgzG40fJPVl-5QUbawjwSbvxEH8Ztzql-3FpjOfKewNijnNk7qhCzboBMjcAz8zUizozoaTdLQCiP353-dESmDoAkMroo7oXJ74hfEQHi8_DCgdPWrRiKteD5bgZxP5GkObC0Rq&aep=10&ntc=1&mstk=AUtExfBH6a8MDmmWJDAlQbhj8xVmQjNhfgJkOGTSd038bEz2YmY8cNiX_fvwYNUMtSS0KU76-a5A16pOXGvOixGdaEGHKy59K4PhfUl2mm4B4UX0QO5JbqnyuIct6gfq4mQcCLuc3FvUeKvWfg_iNfJZY5KYGuhfFYYgWQyMQdfaU_8dsHTPOFOh6PEJky1CVR0HQH_EbjXvUNQRhK9xTnRGCXmV8T46S0gnZ54XcCrLH2Tqc52jnfeHaQKKvWC0JnzDGUAWDrNwNbmSqYbyGdI0WOBnGaKe3Kmww804aHqscqFCjGOMayTyEwkPNA7KwgDa-0gkrZPdIUEZyw&aioh=3&csuir=1&cs=1&mtid=ZqXVavj4Gq-pvr0PgIml4AE

# you asked

ci cd 佈署上,到底是在 git server 上執行,還是在 target server 上 pull git repo 後執行?

---

# googlesearch response

在 CI/CD 的部署架構中，**這兩種方式都有人使用，但現代標準的實作（Best Practice）通常是在一個「獨立的第三方環境（CI/CD Runner/Worker）」上執行**，而不是單純地在 Git Server 或 Target Server 二選一。

不過，如果就你提到的這兩種思維（在「推動端」執行還是「接收端」執行），它們在概念上對應了現代部署的兩大主流模式：**Push-based（推模式）** 與 **Pull-based（拉模式）**。

這兩種作法有著本質上的差異：

* * *

1\. 在 Git Server 端（或 CI/CD Runner）執行：Push-based 部署

這是最傳統且常見的作法。當程式碼推送到 Git Server 後，觸發 CI/CD 流程（如 GitHub Actions、GitLab CI、Jenkins）。

-   **執行流程：**
    1.  程式碼推送到 Git。
    2.  CI/CD 伺服器（Runner）接手，進行測試與打包（例如打包成 Docker Image，或編譯成二進位檔）。
    3.  CI/CD 伺服器**透過 SSH、API 或雲端指令（如 AWS CLI）**，將打包好的產物「推」到 Target Server 上，並重啟服務。
-   **優點：** Target Server 保持乾淨，不需要安裝 Git，也不需要知道原始碼，只需要接收最終的運行檔案或 Docker 鏡像。
-   **缺點：** CI/CD 伺服器必須擁有 Target Server 的高權限（例如 SSH Key、密碼或雲端權限）。如果 CI/CD 伺服器被駭，Target Server 就會暴露。

2\. 在 Target Server 上 Pull 後執行：Pull-based 部署

這種作法通常出現在小型專案（直接在伺服器用 Webhook 觸發 `git pull`），或是**現代進階的 GitOps 架構**（如 ArgoCD、FluxCD）。

-   **執行流程：**
    1.  程式碼推送到 Git。
    2.  Target Server 上運行的一個「代理程式（Agent）」偵測到 Git 有新版本。
    3.  Target Server **主動向 Git Server（或容器倉庫）拉取（Pull）** 最新內容，並在本地端更新、部署。
-   **優點：** 安全性極高！Target Server 不需要對外開放任何入站（Inbound）埠口（例如 SSH 22 埠），也不用把伺服器權限交給 CI/CD。
-   **缺點：** Target Server 需要安裝相關的工具或 Agent。如果是傳統的直接 `git pull`，伺服器上就必須安裝 Git、安裝編譯環境（Node.js, Python 等），會讓生產環境變得複雜、不夠純粹。

* * *

直接比較：我該選哪一種？

| 比較項目 | Push 模式 (在 CI/CD 端打包推送) | Pull 模式 (在 Target Server 拉取) |
| --- | --- | --- |
| **常見工具** | GitHub Actions, GitLab CI, Jenkins | ArgoCD, 傳統 Webhook 觸發 `git pull` |
| **Target 伺服器負擔** | **極低**。只負責運行最終產物（如 Docker 容器）。 | **較高**。如果是傳統作法，必須在正式環境進行編譯與安裝。 |
| **安全性（防火牆）** | 較低。必須開防火牆讓 CI/CD 連進來。 | **極高**。伺服器完全不用對外開埠，主動往外拉取即可。 |
| **適用場景** | 絕大多數中小企業、微服務、標準 Docker 部署。 | 嚴格要求網路安全的公司、**Kubernetes (K8s) 雲原生環境**。 |

* * *

💡 業界的標準建議（Best Practice）

1.  **不要在 Target Server 上直接 `git pull` 生產程式碼：**
    如果是傳統非 K8s 環境，強烈建議在 CI/CD 環境（如 GitHub Actions）將程式碼打包成一個**不變的產物（Artifact）**，例如一個 `.tar.gz` 壓縮檔、`.jar` 檔或 **Docker Image**。然後再將這個產物推送到 Target Server。這樣可以確保測試環境與生產環境的檔案完全一致，也不會在伺服器上留下源原始碼。
2.  **如果您使用的是 Kubernetes：**
    建議採用 **Pull-based (GitOps)**。在 K8s 叢集內部安裝 ArgoCD，讓它去監控你的 Git 檔案庫，一旦有變更，ArgoCD 就會自動在 K8s 內部把新的 Image 拉下來部署。

如果您想為您的專案設計佈署流程，可以告訴我：

-   您的**應用程式語言/框架**（例如 Node.js, Python, Go, Java）
-   您的**目標伺服器環境**（例如 獨立 Linux VM、AWS、還是 Kubernetes）

我可以為您推薦最適合的 CI/CD 管道設計！

已複製到剪貼簿無法複製到剪貼簿，請稍後再試。

更多