# 我目前架設了 ollama server，以及 open web ui

但現在需要和 AD 整合，使 經過 AUTH 的人可以詢問特定問題的 RAG 或 退而求其次 架設 KM 系統
我還可以怎麼做?

> **來源頁面**: [Felo Search](https://felo.ai/search/SoYoyfYeZ6FyTvvs2KjVff)
> **模型**: claude-4-6-sonnet

你的需求很清楚：在現有的 Ollama + Open WebUI 架構上，加入 AD 身份驗證，並讓通過認證的使用者能存取 RAG 或 KM 系統。以下是幾條可行路徑。

## 整體架構思路

你目前的堆疊缺少的是「身份驗證閘道」和「知識存取控制層」這兩塊。補上這兩塊後，整個系統才能做到「誰可以問什麼」的管控。

---

## 方案一：Open WebUI 原生 LDAP/AD 整合（最直接）

Open WebUI 本身支援 OAuth/OIDC 登入，你可以在前面架一個 Identity Provider 橋接 AD：

**做法**：
- 部署 **Keycloak**（開源 IdP），設定 LDAP/AD 作為 User Federation 來源
- Keycloak 會將 AD 帳號轉成 OIDC token
- Open WebUI 設定 `OAUTH_CLIENT_ID` / `OAUTH_CLIENT_SECRET` 指向 Keycloak
- 使用者登入時走 AD 帳密 → Keycloak 驗證 → Open WebUI 授權

這樣所有 AD 使用者就能 SSO 進入 Open WebUI，無需另建帳號系統[5]。

---

## 方案二：在 Open WebUI 前加 Reverse Proxy 做 AD 認證

如果不想動 Open WebUI 設定，可以在前端加一層：

- 用 **Nginx + ldap-auth module** 或 **Traefik + ForwardAuth**
- 搭配 **Authelia** 或 **Authentik**（都支援 LDAP/AD 整合）
- 通過 AD 驗證才能 proxy 到 Open WebUI

**Authentik 特別適合**，因為它支援：
- AD/LDAP 同步
- Group-based 存取控制（不同 AD 群組看到不同功能）
- 內建管理介面

---

## 方案三：RAG 整合（核心需求）

若要讓不同 AD 使用者存取不同知識庫，建議這樣設計：

**知識隔離層**：
- Open WebUI 內建支援「Knowledge」（知識庫）功能，可將不同文件分組
- 搭配使用者角色（透過 Keycloak/Authentik 帶入 AD Group），限制哪些 Group 能存取哪個知識庫
- Ollama 本身不做存取控制，控制層要在 Open WebUI 或 API Gateway 這一層做

**向量資料庫建議**：
- Open WebUI 預設用 ChromaDB，支援基本 RAG
- 若需要更細緻的權限控管，可改用 **Weaviate** 或 **Qdrant**，它們支援 multi-tenant 設計，可依使用者隔離向量資料

---

## 方案四：退而求其次 — 架設 KM 系統

如果 RAG 整合複雜度太高，先用 KM 系統作為知識載體也是合理的：

知識管理系統的核心是將分散的企業內部知識，透過系統化流程進行收集、儲存、傳遞與應用，解決「知識孤島」和「經驗流失」的痛點[2]。

**開源選項**：
- **BookStack** — 支援 LDAP/AD 登入，Wiki 式文件管理，適合文字知識庫
- **Confluence** — 商業方案，AD 整合完整
- **Outline** — 支援 OIDC，現代化介面

**KM + RAG 結合**：
- 在 KM 系統存放文件
- 用爬蟲或 API 定期將 KM 內容 ingest 到 Open WebUI 的知識庫
- 這樣 KM 負責人工整理，RAG 負責 AI 查詢

---

## 建議路徑（優先順序）

1. **先用 Authentik 或 Keycloak 橋接 AD → Open WebUI OIDC 登入**，解決身份驗證問題
2. **在 Open WebUI 建立知識庫分組**，對應 AD 群組做存取控制
3. **若需要更細緻的文件管理**，補上 BookStack 作為 KM，再定期同步到 RAG

這個架構全部可以在內網自架，不需要送資料出去，符合企業資安要求[2]。


## 參考來源

[1] [什麼是KM知識管理系統？ - MAYOHR](https://www.mayohr.com/tw/blog/detail/knowledge_management_system)
   > 2025 / 03 / 10 ｜ 招募與人才發展  ### 分享  ## **什麼是KM知識管理系統？**  一般慣稱**KM**的完整名詞是**知識管理系統（Knowledge Management System, 也有人會用KMS）**，就如其名，主要在收集、整合、分享與應用企業**「內部知識」**的系統，目的是**為企業解決「知識孤島」、「經驗流失」**的痛點。舉例來說，當一位資深工程師離職，他的技術是他帶走，但他的寶貴經驗其實是可以系統性保存下來的。或是，不同部門都在用各自的方式建立客戶畫像，彼此卻不知情、沒辦法系統性共享資料，導致浪費資源與時間。以上這些情況，其實都可以透過KM知識管理系統來避免。  ## **KM知識管理系統的5大核心功能與實用情境**  KM系統不僅僅是用來儲存資訊的工具，它涵蓋了知識從收集、組織到應用的整個過程，幫助企業更好地挖掘內部智慧並將其轉化為實際的業務價值。  以下是KM知識管理系統的主要5大功能模塊：  **知識收集**：通過各種方式，如問卷調查、網絡搜索、專家訪談等，收集並整理企業內部和外部的知識資源。 實用情境：將過去的專案報告、技術文件、會議記錄等非結構化資料，集中歸檔至一個統一的系統。  **知識組織**：將收集到的知識資源進行分類、編目、標籤等操作，以便更好地管理和使用。 實用情境：透過關鍵字標籤，客服人員能快速找到特定產品的常見問題（FAQ），提升服務效率。  **知識儲存**：將知識資源儲存在結構化或非結構化的數據庫中，以便於查找、存取和共享。 實用情境：研發部門建立技術知識庫，記錄各種實驗數據和設計規範，避免重複試驗。  **知識共享**：通過各種方式，如內部網絡、知識庫、在線論壇、博客、社交媒體等，共享和交流知識資源，從而促進企業內部的知識流動和創新。 實用情境：新進員工可透過線上知識庫快速了解公司產品、業務流程，大幅縮短培訓時間。  **知識應用**：通過KM知識管理系統，企業可以將知識管理應用於決策、問題解決、創新、產品開發等方面，從而提高企業的經營效率和競爭力。

[2] [知識管理系統是什麼？KM核心功能、痛點解析與導入趨勢一篇搞懂](https://www.microfusion.cloud/news/what-is-kms/)
   > 在數位轉型的浪潮中，我們常常將目光聚焦在雲端運算、大數據分析這些硬體升級，但您是否曾意識到，企業內部知識的流失與分散，才是阻礙成長的隱形殺手？想像一下，當資深工程師或業務一離職，他腦中累積數年的寶貴經驗就跟著消失了。這就是企業最害怕的經驗流失與知識孤島！  今天，我們就要來聊聊這個讓企業重新掌握智慧資產的關鍵武器—**知識管理系統（KMS/KM）**。特別是結合了生成式 AI 技術的現代 KM 知識管理系統，它不再只是個檔案櫃，而是能與您對話、主動提供答案的超級大腦！  目錄  ## 知識管理系統（KM）是什麼？3大企業痛點一次解決  知識管理系統（Knowledge Management System，簡稱 KMS 或 KM），其核心目標是將企業內部分散、隱性的智慧與經驗，透過系統化的流程，進行收集、儲存、傳遞與應用。  簡單來說，KM 系統就是企業的中央智慧圖書館，它的存在就是為了終結以下三大痛點：  ### **1\. 解決經驗流失的恐慌**  避免員工離職或崗位變動，造成知識斷層。資深專家的寶貴經驗會被系統性保存下來，確保企業智慧永續。  ### **2\. 打破知識孤島的藩籬**  許多部門各自為政，形成資訊壁壘。KM 系統能將分散的知識集中管理，促進跨部門協作。  ### **3\. 終結重複造輪的低效**  *   **知識碰撞激發創意：** 來自不同部門、專業背景的員工，能透過系統交流隱性知識（如個人經驗、直覺），共同激發新的產品或服務。 *   **應對市場快速變化：** 企業能快速掌握新技術或新趨勢的相關知識並加以應用，以更靈活地應對市場的動態變化。  ### **3\. 確保經驗傳承與永續（Experience Transfer）**  這是 KM 知識管理系統最核心的使命之一。將個人的寶貴經驗，轉化為組織的永續資產。知識管理系統提供了永續的平台，使企業的核心技術、最佳實踐得以有效保存，並傳承給新的團隊成員。知識管理系統（KM）已經從一個單純的文件儲存工具，進化為結合 AI 智慧的企業核心戰略資產。終結知識孤島和經驗流失，不僅能提升您企業的營運效率，更是激發創新、確保企業永續競爭力的關鍵。  ## **知識管理系統 (KM) 常見問題一次解答！**  以下整理企業在評估與導入知識管理系統時，最常遇到的實務問題，協助快速釐清觀念、降低導入風險：  ### **Q：什麼是知識管理系統（KM）**  知識管理系統（Knowledge Management System，KM）是一套用來蒐集、整理、保存、分享與應用企業內部知識的系統。它的核心目標，是將分散在個人或部門中的經驗、文件與 know-how，轉化為組織可長期運用的智慧資產，避免知識隨人員異動而流失。  ### **Q：知識管理系統和文件管理系統有什麼不同？**  文件管理系統的重點在於「文件存放與版本控管」，而知識管理系統更關注「知識是否能被理解與實際應用」，KM 知識管理系統不只管理文件，還整合流程、經驗、FAQ 與隱性知識，讓使用者能快速取得可直接解決問題的內容，而不只是一份檔案。  ### **Q：哪些企業或產業最適合導入知識管理系統？**  只要企業存在以下情況，就非常適合導入 知識管理系統：  *   人員流動率高，擔心經驗隨離職流失； *   跨部門合作頻繁，卻常出現資訊斷層； *   新人培訓時間長，學習曲線陡峭； *   客服、IT、法遵、研發等高度依賴專業知識的部門。  實務上，金融、科技、製造、醫療、顧問與大型服務業，都是 KM 知識管理系統的常見應用產業。  ### **Q：導入知識管理系統一定要搭配 AI 嗎？**   不一定，但結合 AI 的 知識管理系統，使用效益通常更高，傳統 知識管理KM 系統以關鍵字搜尋為主，而 AI 知識管理系統可透過自然語言理解，讓使用者直接「用問的」，並即時取得整理後的答案，大幅提升實際使用率。  ### **Q：知識管理系統如何確保資料安全與隱私？**  企業級知識管理系統通常具備權限控管、資料分級與存取紀錄機制，若採用企業雲端平台，資料會維持企業專屬與隔離狀態，不會被用於訓練公開模型，能滿足企業對資安與合規的基本要求。  面對瞬息萬變的雲端趨勢，您需要一個專業且可靠的夥伴，協助您進行最優化的雲端部署 與 AI 整合。宏庭科技身為 Google Cloud 菁英級夥伴， 擁有豐富的雲端服務經驗與專業知識。雖然知識管理策略的設計與軟體導入非常複雜，但我們的核心價值在於協助您確保您的知識管理系統（無論是導入 Gemini Enterprise 或其他解決方案）能夠運行在最安全、最穩定、且最具成本效益的[雲端運算](https://www.microfusion.cloud/news/what-is-cloudserver/)環境中。立即聯繫[宏庭科技](https://www.microfusion.cloud/contact/)，取得免費諮詢！延伸閱讀：

[3] [建構AI 系統：從RAG 到Agent](https://blakecrosley.com/zh-Hant/blog/building-ai-systems-rag-to-agents)
   > 我建構了一個3500 行的Agent 系統,包含86 個Hook ・ 從RAG 開始,發現其局限後再加上微調。兩者都能解決檢索和推理問題・ 摘要 RAG 在查詢時檢索・ 個Bash 整合測試用於Hook

[4] [知識管理資訊系統在教學上的應用以Vitals/KM知識管理系統為例](https://www.gss.com.tw/eis/52-eis55/173-vitalskm-3)
   > 建置Vitals/KM知識管理系統，建立知識倉儲，以有效分類管理醫院中醫學資訊、作業流程表單、教育訓練課程的講義、研討會教材、藥品資訊、危機處理案例 央A提升醫療人員 ...

[5] [LDAP, AD, Active Directory, 整合認證帳號密碼, Authentication · GitHub](https://gist.github.com/00a78d3af2378b682d3dc1edc7fb407c)
   > LDAP, AD, Active Directory, 整合認證帳號密碼, Authentication · GitHub Search Gists [All gists](https://gist.github.com/discover)[Back to GitHub](https://github.com/) [Sign in](https://gist.github.com/auth/github?return_to=https%3A%2F%2Fgist.github.com%2Frelyky%2F00a78d3af2378b682d3dc1edc7fb407c) [Sign up](https://gist.github.com/join?return_to=https%3A%2F%2Fgist.github.com%2Frelyky%2F00a78d3af2378b682d3dc1edc7fb407c&source=header-gist) You signed in with another tab or window. Reload to refresh your session.You switched accounts on another tab or window. Dismiss alertInstantly share code, notes, and snippets.  Last active September 28, 2023 03:46Show Gist options  *   [Star 2 (2)](https://gist.github.com/login?return_to=https%3A%2F%2Fgist.github.com%2Frelyky%2F00a78d3af2378b682d3dc1edc7fb407c) You must be signed in to star a gist *   [Fork 1 (1)](https://gist.github.com/login?return_to=https%3A%2F%2Fgist.github.com%2Frelyky%2F00a78d3af2378b682d3dc1edc7fb407c) You must be signed in to fork a gist  [relyky](https://gist.github.com/relyky)/**[AD\_Authenticate\_v1.cs](https://gist.github.com/relyky/00a78d3af2378b682d3dc1edc7fb407c)** Clone this repository at &lt;script src=&quot;https://gist.github.com/relyky/00a78d3af2378b682d3dc1edc7fb407c.js&quot;&gt;&lt;/script&gt; Save relyky/00a78d3af2378b682d3dc1edc7fb407c to your computer and use it in GitHub Desktop.  |     |     | | --- | --- | |     | /// <summary> | |     | /// 使用AD驗證 | |     | /// ref → https://myjeeva.com/querying-active-directory-using-csharp.html | |     | /// </summary> | |     |     | |     | using System; | |     | using System.DirectoryServices; | |     |     | |     | public static Boolean ADAuthenticate(string userId, string userPwd) | |     | {   | |     | const string ldapHost \= @"LDAP://192.168.xxx.xxx"; | |     |     | |     | try | |     | {   | |     | SearchResult rsUser \= null; | |     | using (DirectoryEntry de \= new DirectoryEntry(ldapHost, userId, userPwd)) | |     | {   | |     | using (DirectorySearcher ds \= new DirectorySearcher(de)) | |     | {   | |     | ds.Filter \= string.Format("(&((&(objectClass=User)))(sAMAccountName={0}))", userId); | |     | ds.SearchScope \= SearchScope.Subtree; | |     | rsUser \= ds.FindOne(); | |     | }   | |     | }   | |     |     | |     | //AD 驗證通過 | |     | // return rsUser.Path; | |     |     | |     | // success | |     | return true; | |     | }   | |     | catch //(Exception ex) | |     | {   | |     | return false; | |     | }   | |     | }   |  |     |     | | --- | --- | |     | using System; | |     | using System.Text; | |     | using System.Collections; | |     | using System.DirectoryServices; | |     |     | |     | namespace ADAuthLab | |     | {   | |     | /// <summary> | |     | /// 對 Active Directory 驗證 | |     | /// </summary> | |     | /// <remarks> | |     | /// ref: https://support.microsoft.com/zh-tw/help/316748/how-to-authenticate-against-the-active-directory-by-using-forms-authen | |     | /// </remarks> | |     | public class LdapAuthentication | |     | {   | |     | private String \_authPath; | |     |     | |     | // last result | |     | private String \_errMsg; | |     | private String \_userADsPath; | |     |     | |     | public LdapAuthentication(String path) | |     | {   | |     | \_authPath \= path; | |     | }   | |     |     | |     | #region properties | |     |     | |     | public string ADsPath | |     | {   | |     | get { return \_userADsPath; } | |     | }   | |     |     | |     | public string ErrMsg | |     | {   | |     | get { return \_errMsg; } | |     | }   | |     |     | |     | #endregion | |     |     | |     | public bool IsAuthenticated(String domain, String username, String pwd) | |     | {   | |     | String domainAndUsername \= (domain \== null) ? username : domain + @"\\" + username; | |     | DirectoryEntry entry \= new DirectoryEntry(\_authPath, domainAndUsername, pwd); | |     |     | |     | try | |     | {   | |     | //Bind to the native AdsObject to force authentication. | |     | Object obj \= entry.NativeObject; | |     |     | |     | DirectorySearcher search \= new DirectorySearcher(entry); | |     |     | |     | search.Filter \= "(SAMAccountName=" + username + ")"; | |     | SearchResult result \= search.FindOne(); | |     | if (null \== result) | |     | {   | |     | \_errMsg \= "Error authenticating, the user not found."; | |     | \_userADsPath \= ""; | |     | return false; | |     | }   | |     |     | |     | // success | |     | \_userADsPath \= result.Path; | |     | \_errMsg \= ""; | |     | return true; | |     | }   | |     | catch (Exception ex) | |     | {   | |     | \_errMsg \= "Error authenticating user. " + ex.Message; | |     | \_userADsPath \= ""; | |     | return false; | |     | }   | |     | }   | |     |     | |     | public bool IsAuthenticated(String username, String pwd) | |     | {   | |     | return IsAuthenticated(null, username, pwd); | |     | }   | |     | }   | |     | }   | |     |     | |     | //============ 應用 ============ | |     |     | |     | // 指定認證用的 AD Path 應儘可能指定到部門。 | |     | String adPath \= "LDAP://192.168.xxx.xxx/CN=Users,DC=your\_AD\_host\_dc,DC=com"; | |     | String adPath \= "LDAP://192.168.xxx.xxx"; // 實際上大多指定到主機。 | |     | LdapAuthentication adAuth \= new LdapAuthentication(adPath); | |     |     | |     | // AD認證 | |     | if (adAuth.IsAuthenticated("domain\_name", "user\_name", "your\_password")) | |     | Console.WriteLine("adspath: {0}", adAuth.ADsPath); // get the user's ADsPath | |     | else | |     | Console.WriteLine("AD認證失敗！" + adAuth.ErrMsg); | |     |     | |     | // 有時不需 domain 也能AD認證 | |     | if (adAuth.IsAuthenticated("user\_name", "your\_password")) | |     | Console.WriteLine("adspath: {0}", adAuth.ADsPath); // get the user's ADsPath | |     | else | |     | Console.WriteLine("AD認證失敗！" + adAuth.ErrMsg); |

[6] [km+ 知識管理，10 分鐘快速入門 - 台灣數位訓練課程](https://learning.xms.tw/media/1676)
   > 00:001.  km+ 知識管理讓知識管理，變得很簡單!  00:342.  新增目錄 & 資料夾  02:033.  上傳影片  03:044.  上傳一般檔案  03:565.  上傳照片  04:366.  整理 YouTube 影片  05:097.  整理 & 排序媒體  05:448.  資料夾權限設定  06:589.  全站搜尋  07:3810.  設計重點  09:2211.  設計檢核清單  10:1012.  建立 FAQ  10:5313.  發表討論  11:2514.  10 倍速傳承  未登入或權限不足!  講者：德宙 蘇  日期：2022-04-06  觀看: 2978  *   00:00 1.          km+ 知識管理讓知識管理，變得很簡單!      *   00:34 2.          新增目錄 & 資料夾      *   02:03 3.          上傳影片      *   03:04 4.          上傳一般檔案      *   03:56 5.          上傳照片      *   04:36 6.          整理 YouTube 影片      *   05:09 7.          整理 & 排序媒體      *   05:44 8.          資料夾權限設定      *   06:58 9.          全站搜尋      *   07:38 10.          設計重點      *   09:22 11.          設計檢核清單      *   10:10 12.          建立 FAQ      *   10:53 13.          發表討論      *   11:25 14.          10 倍速傳承       *   索引 *   筆記 *   全螢幕  列印日期 : 2026/07/13台灣數位訓練課程  km+ 知識管理，10 分鐘快速入門  長度: 12:06, 瀏覽: 1279, 最近修訂: 2023-03-27  播放影片: https://learning.xms.tw/media/1187  好的系統 + 策略，絕對可以有效地解決知識管理的 3 大挑戰：  1.  知識，進不去 2.  要用時，卻找不到 3.  好不容易找到了，但已經過時、不完整  *   資料不知道放在哪裡？     km+ 支援各種媒體的儲存，相當於整合 google drive (檔案) / photos (照片) / youtube (影片) / sites (網頁) 的功能，集中管理，不會到處分散而找不到。       *   pdf、word 內文，不好找     內建的全文檢索引擎，除了媒體的內容、索引、討論、FAQ 之外，搜尋範圍更包括 word, pdf, ppt, excel 等內文。       *   缺乏標準流程？     km+ 提供 SOP 與檢核清單的機制，更清楚規範與撰寫每一個步驟，因為線上排版與編輯都很容易，就可以減少使用 word 下載、編輯後再次上傳的不便而導致每個人電腦都有自己版本的問題。       *   經驗無法傳承？     實驗技術，容易卡關、做錯的就是那幾個，透過 FAQ 機制，將過去遇到的問題、如何解決的方法收集與整理，新人將不用重新摸索，學生畢業也不會有技術斷層的困擾。  重點  1.  資料建檔、管理與搜尋      2.  1.          登入          使用系統管理者的帳號登入系統，從上方選單「知識」，進入知識庫首頁。          這是個人化的知識庫入口，顯示的資訊包括：          1.  個人化資訊         近期存取 (媒體、資料夾)、最新上傳、收藏的媒體、資料夾捷徑、 ... 等。               2.  管理功能         維護清單、知識庫管理、 ... 等。      3.  2.          新增目錄 & 資料夾          km+ 採用類似檔案總管的「資料夾」觀念，提供影片、文件等多媒體的儲存與分類，          此外，每個資料夾可以分別設定權限，包括管理者或指定哪些人可以閱讀資料夾內的媒體。          為了讓權限更清楚、容易地設定，資料夾裡面不允許再建立資料夾，若您需要有多層次的分類 (如下圖)，就可以透過建立「目錄」，並在目錄下建立「資料夾」或「子目錄」來完成。          建立的方式很簡單，進入「目錄瀏覽」，點擊工具「新增」，選擇目錄 or 資料夾即可。     更詳細的操作說明，請參考：「[建立目錄、資料夾](http://p.fms.tw/media/134)」。          註: 目錄，是資料夾的分類，不能放媒體。      4.  3.          上傳影片          km+ 支援各種格式的影片，包括 EverCam (.ecm), wmv, mp4, avi, ... 等。          以上傳 EverCam 為例，進入資料夾後，點擊「新增媒體 / EverCam」，直接將原始檔 .ecm 拖曳到網站就完成囉。上傳後，系統後台會自動轉成 mp4 (含段落索引)，讓各種手機、瀏覽器都可以閱讀。          更詳細的操作說明，請參考文件：「[上傳 EverCam / 影片](http://p.fms.tw/media/92)」。      5.  4.          上傳一般檔案          除了用附件的方式上傳檔案之外，也可以透過下拉工具「上傳檔案」的功能，將任何類型的檔案 (如 word, pdf, excel 等)，上傳成為一份「媒體」 (如下圖)。          這樣呈現的好處包括:          1.  檔案列表，符合我們熟悉的檔案總管或是 google drive     2.  每份檔案可以編輯專屬的說明與 FAQ，例如請假的表單，就可以提醒填寫時要注意的事項，或是收集請假相關的常見問題。      6.  5.          上傳照片          雖然照片可以直接插入到媒體中，但系統提供更簡單的方式 ~ 相簿，更方便存放實驗照片等資料。          在資料夾中，點擊「新增媒體 / 相簿」後，就可以將照片拖曳上傳，上傳後，可以編輯相片說明、設定相簿封面，並提供投影片放映的方式瀏覽。      7.  6.          整理 youtube 影片          YouTube 已經有很多很棒的實驗技術影片，透過「新增媒體 / YouTube」貼上 YouTube 的影片網址，系統就會將影片嵌入，並自動建立影片的標題、原始來源、描述 ... 等資料。完成後，還可以建立索引，方便快速找到影片中特定的主題。          更詳細的操作說明，請參考文件：      8.  7.          整理 & 排序媒體          透過工具選單的「檢視模式」中「自訂」媒體排序的功能，就可以「新增章節」並拖曳媒體來調整媒體的順序與結構。          更完整的操作方式，請參考文件：「[檢視模式 (排序文件)](http://p.fms.tw/media/137)」。      9.  8.          資料夾權限設定          上傳的資料，哪些人可以看？          在資料夾的下拉工具的「權限設定」，就可以設定，包括：          *   資料夾管理者         可以管理資料夾內所有的媒體與資料夾的設定。               *   上傳權限         指定哪些人可以上傳，上傳後只能管理自己上傳的媒體。               *   閱讀權限 (註)         可以指定登入後就可以觀看 (一般使用者) 或是指定特定的角色才可以觀看。          更詳細的操作說明，請參考文件：「[設定資料夾權限](https://learning.xms.tw/media/2786)」。          附註：          在目錄中，可以透過資料夾名稱前的圖示，迅速辨識資料夾的閱讀權限，以方便管理，例如： 代表一般使用者 (登入後) 都可以看到資料夾內的媒體。      10.  9.          全站搜尋          在最上方的搜尋框，輸入關鍵字即可。          內建的全文檢索引擎，只會從您有「閱讀權限」的資料夾中搜尋，範圍包括：          *   檔案的內文 (word、pdf、PowerPoint、Excel 等)     *   文件的標題、內容、重點、索引     *   討論     *   FAQ          更完整的操作說明，請參考文件：「[全文檢索](http://p.fms.tw/media/140)」。          小技巧:          1.  若有多個關鍵字時，請用「空白」分隔。     2.  除了全站搜尋之外，也可以在資料夾中透過「搜尋這個資料夾」的功能，縮小搜尋範圍。      11.  建立標準作業流程      12.  10.          設計重點          進入媒體，點擊「新增重點」即可，優點包括：          *   排版清楚         重點編號、圖片 (框線) 或為重點分類 (說明)，閱讀時一目了然。               *   獨立編輯         每一個重點獨立編輯、插入重點、調整順序，比用 word 更方便，而且不會亂掉。          更詳細的操作說明 (例如取消或修改編號設定)，請參考文件：「[設計重點 (SOP)](http://p.fms.tw/media/94)」。      13.  11.          設計檢核清單          標準作業流程，如何確保執行時不會遺漏？檢核清單最有效！          在工具下拉選單，選擇「新增檢核清單」即可建立。          特別提醒:          文件的檢核清單是「範本」用途，提供專案管理建立工作時複製使用，更完整的說明，請參考專案的「[建立檢核清單](http://p.fms.tw/media/349)」。      14.  討論與收集 FAQ      15.  12.          建立 FAQ          用 km+ 收集很簡單，直接在媒體 (例如實驗 SOP) 下方新增「FAQ」，看完 SOP 後就可以看到前輩遇到的相關問題以及解決方法，這些就是珍貴的經驗！可以減少重蹈覆轍。          關於 FAQ 收集的策略，可以參考影片：「 [FAQ 教戰守則](https://learning.xms.tw/media/1714)」。          小技巧：          在資料夾的 FAQ 專區，可以透過「匯入」的方式，重新分類、整理放在各媒體下的 FAQ，提供統一的入口。      16.  13.          討論          文件看不懂又不知道要問誰？          可以在頁面下方「發表討論」，系統就會 e-mail 通知資料夾管理者 & 媒體發表人，回應後，不僅解決問題，也能留下重要的紀錄，成為整理 FAQ 的重要來源。          附註:          用 LINE or 口頭很方便，但 LINE 不好整理，口頭很容易問過就忘，重要經驗就不容易被紀錄與傳承。      17.  14.          統計報表          系統管理者 or 知識庫管理者，從「知識庫 / 知識庫管理 / 統計報表」就可以查閱相關報表，例如：媒體瀏覽次數、媒體數量、人員閱讀紀錄、... 等。      18.  當知識與經驗逐步累積後，          接下來，就可以將這些知識設計成線上課程，明確的規劃要在什麼時間點前完成，並透過測驗，逐項確認一些容易誤解、遺漏的地方，避開過去看文件但沒抓到重點的問題。          更詳細的說明，請參考線上手冊：「[\[開課者\] 設計課程，10 分鐘快速入門！](http://p.fms.tw/media/170)」       檢核清單  評語  5  共 1 則評分  4  3  2  1  請登入後才可以評分  位置  資料夾名稱  [tms+ 教育訓練](https://learning.xms.tw/km/1849)  上傳者  簡鴻至  單位  台灣數位訓練課程  建立  2023-03-06 17:49:44  最近修訂  2023-03-27 13:52:37  長度  12:06

[7] [什麼是檢索增強生成(RAG) 技術？ - Google Cloud](https://cloud.google.com/use-cases/retrieval-augmented-generation?hl=zh-TW)
   > 什麼是檢索增強生成 (RAG) 技術？ | Google Cloud*   [主題](https://cloud.google.com/discover/) *   RAG  # 什麼是檢索增強生成 (RAG) 技術？  RAG 是「檢索增強生成」的簡稱，這是一種 AI 架構，結合傳統資訊檢索系統 (如搜尋和資料庫) 的優勢，以及生成式[大型語言模型 (LLM)](https://cloud.google.com/ai/llms) 的功能。如果將您的資料和世界知識與 LLM 語言技術加以結合，**根據基準生成的內容**就會較為準確，資訊也會是最新的，而且更切合您的特定需求。歡迎參閱這本電子書，瞭解如何讓「[企業真相](https://cloud.google.com/resources/grounding-generative-ai-in-enterprise-truth)」發揮價值。  免費試用  利用 Gemini Enterprise Agent Platform 的 Agent Search 和 DIY RAG 建立 Gemini 基準  ## 檢索增強生成 (RAG) 技術如何運作？  RAG 會採取幾個主要步驟，提升生成式 AI 輸出內容的品質：  *   **檢索及預先處理：**RAG 會運用強大的搜尋演算法來查詢外部資料，例如網頁、知識庫和資料庫。完成擷取作業後，系統就會開始預先處理相關資訊，包括斷詞、分析詞幹，以及移除非檢索用字。 *   **根據基準生成內容：**接著，經過預先處理的檢索資訊便能順暢整合至預先訓練的 LLM。這項整合流程可增強 LLM 的脈絡理解能力，更全面地瞭解主題。一旦脈絡理解能力提升，LLM 就能生成更精確、實用且引人入勝的回覆。

[8] [企業推動KM知識管理的四步驟 - 聯聖企管顧問](https://rcsa-consultant.com/index.php/view/management/article165)
   > 企業推動KM知識管理的四步驟                          Search      ## 企業推動KM知識管理的四步驟  陳致瑋  26 八月 2019  建立: 26 八月 2019  點擊數: 29579  Soclai Share：  # 如何落實KM知識管理?  **KM知識管理是什麼?**  KM是組織中建構一個量化與質化的知識系統，讓組織中的資訊與知識，透過獲得、創造、分享、整合、記錄、存取、更新、創新等過程，不斷的回饋到知識系統內，有助於公司流程進行、決策執行等各種管理。  **企業要推動KM（Knowledge Management；知識管理），簡單來說，可以分成以下四個步驟：**  **第一步：**建立SOP（標準作業流程），將最好的經驗與方法歸納成標準化的模組，然後將之複製、傳承給更多的人。  **第二步：**建立公司內部的OST（On Site Training；在位訓練）機制，將方法、資訊、經驗轉換成學習者的個人經驗。  **第三步：**將各種營業的情報與資訊公開化，透過分享平台，讓大家都能快速且透明地取得各種情資，善用這些情資進行創意重組或創造的工作。  **第四步：**透過資訊的分享，逐步推展成為PKM（Personal Knowledge Management）。PKM是一種整合組織及資訊成為個人知識的一種概念性架構，除了有效管理個人具備的知識之外，還能學習各種管道和不同領域的事物及其方法，吸取他人的經驗知識，並內化為個人的知識，進而提升個人的價值。  以上四個步驟，前三項是逐一執行的次第步驟，第四項是可以延伸到個人層面的項次。公司要真的落實與推動KM，不可能跳過第一步直接進入第三步。前三項的次序是逐步執行的過程，有著延後的聯繫關係，不可以跳躍執行。  ## **推動KM的三個關鍵人物**  KM的建立不是單靠資訊系統就可完成，過程必須有人負責建立資料、審核資料、發布資料，發布之後還需要有人願意去用它。  整個作業的機轉必須透過人來執行！如果人不落實執行，光是花錢買KM系統只是徒耗費用，不會得到任何效果。因此，KM的推動又分成推動者、貢獻者、使用者三方。  **推動者：**是部門的主管，他必須重視且認知KM傳承對團隊訓練的重要性與幫助性，他願意花時間督導團隊去分享、重組、傳承各項資訊與經驗。  **貢獻者：**是執行過的任何人，他們必須放開心胸，大方地與人分享他做過的最佳實務。這與當事人的意願、認知有關，願意分享的人才會對KM的推動有幫助。  **使用者：**懂得運用公司的KM平台去找他們要的答案。他們會主動發問問題，貢獻者回答問題，使一個KM系統變成一個完整的FAQ問答集！  透過三方相互分享與落實，便能將KM發揮出最高效益!  ### 留下評論  ### 歡迎加入課程會員  獲得第一手課程消息  [Join us](https://shop.rcsa-consultant.com/login)最完善的課程規劃，全方位學習機制  ### 精采課程不錯過  ### 文章投稿  除了由聯聖企管編輯採訪撰稿、專欄作者傳授經驗外，我們也期盼邀請各行各業有成就的企業學員、有想法的工作者，可以一起分享管理、營運、經營、行銷、組織運作的心法，共同造福不斷追求新的思維同溫層。  ### 課程學習  最實務的培訓課程，職場進修首選  [前往報名](https://shop.rcsa-consultant.com/goods)  ### 服務項目  企業上的各種需求， 我們提供專業客製化的諮詢輔導服務  [前往了解](https://rcsa-consultant.com/index.php/services)  ### 經營管理｜精選書籍  企業採購可來電洽詢 (02)-2717-0666  105台北市松山區南京東路五段225號5樓 (京鷹商務大樓) 業務洽詢：02-2717-0666 　 信箱：Email住址會使用灌水程式保護機制。你需要啟動Javascript才能觀看它 客服專線：02-2717-0666　 服務時間：週一到週五9:00~12:00；13:30~18:00  加入LINE好友 輕鬆看經營管理知識  [︿](https://rcsa-consultant.com/index.php/view/management/article165#)

[9] [新一代生成式AI知識管理系統AI Search for KM介紹說明(影片) - 意藍](https://www.eland.com.tw/%E6%96%B0%E4%B8%80%E4%BB%A3%E7%94%9F%E6%88%90%E5%BC%8Fai%E7%9F%A5%E8%AD%98%E7%AE%A1%E7%90%86%E7%B3%BB%E7%B5%B1%E4%BB%8B%E7%B4%B9%E8%AA%AA%E6%98%8E/)
   > 本次我們便以影片形式來為大家介紹，AI Search for KM如何協助各企業或機關單位快速檢索和應用組織內部的重要知識，解決傳統知識管理中的痛點，提升工作效率和資料安全性。

[10] [RAG and Generative AI - Azure AI Search - Microsoft Learn](https://learn.microsoft.com/en-us/azure/search/retrieval-augmented-generation-overview)
   > Retrieval-augmented generation (RAG) is a pattern that extends LLM capabilities by grounding responses in your proprietary content.

[11] [AI KM - RAG 知識管理系統| MaiAgent 思邁智能](https://maiagent.ai/ai-km)
   > AI KM 把企業知識變成AI 的大腦. 採用Agentic RAG 技術， 結合智能推理、多步驟規劃與動態驗證，達成高準確率。 支援多種文件格式，提供來源溯源引用，讓企業知識真正被 ...

[12] [知識管理系統KM - 超融合學習平台](https://km.sopdom.com/books/km)
   > 這是一套很好用的線上學習系統, 在編輯手冊內容非常簡單可隨時優化手冊, 非常適合用來培訓員工的教育訓練手冊, 本超融合學習平台也是使用這套系統架設, 這是一套開源軟體有 ...

[13] [Cara Setting dan Menggunakan Ollama dengan Open WebUI](https://www.jagoanhosting.com/tutorial/tips/cara-setting-dan-menggunakan-ollama-dengan-open-webui)
   > Install Ollama dan Open WebUI di VPS · STEP 1: Update Sistem · STEP 2: Install Docker dan Docker Compose · STEP 3: Buat Direktori Projek · STEP 4: ...

[14] [Build a RAG-Powered LLM Service with Ollama & Open WebUI](https://medium.com/@hassan.tbt1989/build-a-rag-powered-llm-service-with-ollama-open-webui-a-step-by-step-guide-a688ec58ac97)
   > In this tutorial, we will use Ollama as the LLM backend, integrating it with Open WebUI to create an interactive RAG system.

[15] [10 分鐘設定好open web-ui 跟ollama - imuslab](https://imuslab.com/wordpress/2024/07/13/open-web-ui-with-ollama/)
   > 如果你的ollama 是部署在另一台伺服器上面的，你可以把這裡改成另一台伺服器的ip 地址或domain name。 使用open web-ui. 要使用的話只要回到New Chat，選擇 ...

[16] [Ollama with Open WebUI | DigitalOcean Documentation](https://docs.digitalocean.com/products/marketplace/catalog/ollama-with-open-webui/)
   > Open-WebUI is integrated with Ollama to enhance your workflow and make it easier to experiment with different models. 1. Accessing Open WebUI.

[17] [知識管理(KM)系統- 百加資通股份有限公司](https://www.hundredplus.com/portal/tw/product/enhanced_service_solution/%E7%9F%A5%E8%AD%98%E7%AE%A1%E7%90%86km%E7%B3%BB%E7%B5%B1/)
   > 知識管理解決方案整合Web化管理介面，不須跨系統作業或額外安裝多系統，節省企業安裝系統流程的時間。 統計圖表. 透過內建的統計圖表，管理者可以查看同仁瀏覽資訊狀況 ...

[18] [RAG是什麼？AI關鍵RAG技術及RAG應用原理完整說明](https://www.systexdc.com/2025/11/12/rag-technology/)
   > RAG模型的核心架構，主要可拆解為5個步驟，分別是理解、檢索、重組、累積及整合，透過這些步驟的合力運作，才能顯著提升AI回應的準確度與可驗證性。 RAG架構 ...

[19] [使用Ollama與Open WebUI在本地端部署Llama3大語言模型](https://www.uuu.com.tw/Public/content/article/24/20240701.htm)
   > 本文介紹如何在本地端安裝Ollama與Open WebUI，並使用Ollama運行Meta Llama 3:8b模型。 首先至Ollama官網(https://ollama.com)下載對應版本的ollama執行檔， ...

[20] [Configure Authentication Method for Active Directory Integration](https://techdocs.broadcom.com/us/en/ca-enterprise-software/layer7-api-management/api-gateway/10-1/learning-center/configure-the-gateway-for-kerberos-token-based-authentication/Configure-Authentication-Method-for-Active-Directory-Integration.html)
   > This topic describes how to integrate the authentication method of the and Microsoft Active Directory. You will learn how to retrieve and validate User ...

[21] [What is Active Directory Integration? A Guide - Securden](https://www.securden.com/educational/active-directory-integration.html)
   > Active Directory Integration links your systems, applications, and resources to one central directory, creating a unified way to manage your users and their ...

[22] [Active directory authentication and authorization for an application](https://serverfault.com/questions/721048/active-directory-authentication-and-authorization-for-an-application)
   > This requires you to create the objects accounts (users, systems and computers), set the permissions through groups, implement the web seal ...

[23] [open-webui/open-webui: User-friendly AI Interface (Supports Ollama ...](https://github.com/open-webui/open-webui)
   > Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline. It supports various LLM runners ...

[24] [LDAP/AD - LibreChat](https://www.librechat.ai/docs/configuration/authentication/ldap)
   > Learn how to configure LibreChat to use LDAP for user authentication. You can use a Lightweight Directory Access Protocol (LDAP) authentication server to ...

[25] [Guide for Active Directory (AD) Authentication protocols - miniOrange](https://www.miniorange.com/active-directory-authentication)
   > AD supports multiple protocols through which authentication of the organization's users can be done. The two main of these are Kerberos and LDAP.

[26] [Ad Hoc 管理式檔案傳輸](https://www.progress.com/tw/moveit/ad-hoc)
   > MOVEit Ad Hoc 傳輸使企業能夠管理人與人檔案傳輸交互，並主動應用透明的端到端FIPS 驗證加密、附件卸載、安全訊息傳遞、訪問控制和單個登錄身份驗證。它還提供被動管理技術 ...

[27] [使用Ollama 和Open-WebUI 部署Gemma](https://docs.cloud.google.com/distributed-cloud/sandbox/latest/tutorials/gemma?hl=zh-cn)
   > 在配备GPU 的AI 优化型GDC 沙盒上部署使用Gemma 模型的Ollama。 通过Open-WebUI 界面在Ollama 服务的专用端点向该服务发送提示。 准备工作. GDC Sandbox ...

[28] [Spring AI 第七講：進階RAG——提升檢索精準度](https://www.meta-intelligence.tech/insight-spring-ai-lesson7-advanced-rag)
   > 從基礎RAG 升級到進階RAG。掌握Metadata Filtering 精準篩選、Query Rewriting 改寫模糊查詢、Re-ranking 二次排序，以及三者的組合管線。

[29] [Ollama - Open WebUI](https://docs.openwebui.com/getting-started/quick-start/connect-a-provider/starting-with-ollama/)
   > Load Balancing: You can add multiple Ollama instances. Open WebUI will distribute requests between them using a random selection strategy, providing basic load ...

[30] [有人把完整的agentic RAG 框架開源了。](https://www.threads.com/@krumjahn/post/DZSRtFZDUK5/video-%E6%9C%89%E4%BA%BA%E6%8A%8A%E5%AE%8C%E6%95%B4%E7%9A%84-agentic-rag-%E6%A1%86%E6%9E%B6%E9%96%8B%E6%BA%90%E4%BA%86google-research-%E5%92%8C-google-cloud-%E5%90%88%E5%87%BA%E4%BE%86%E7%9A%84%E4%B8%8D%E6%98%AF%E5%96%AE%E4%B8%80-agent%E6%98%AF-multi-age/)
   > 有人把完整的agentic RAG 框架開源了。 · Google Research 和Google Cloud 合出來的——不是單一agent，是multi-agent workflow。 · 複雜查詢自動拆解，context ...

[31] [A Complete Guide to Active Directory Authentication - JumpCloud](https://jumpcloud.com/blog/active-directory-authentication)
   > Learn about Active Directory Authentication, how it works, and how to obtain more controlled security in heterogeneous IT environments.

[32] [How do you integrate Active Directory with third-party authentication ...](https://backup.education/showthread.php?tid=2144)
   > ADFS allows your Active Directory users to authenticate against various applications without needing a separate set of credentials. I recommend ...

[33] [Authentication vs. authorization - Microsoft identity platform](https://learn.microsoft.com/en-us/entra/identity-platform/authentication-vs-authorization)
   > This article defines authentication and authorization. It also briefly covers multifactor authentication and how you can use the Microsoft ...

[34] [How do we Authenticate Spiceworks with our Local Active Directory?](https://community.spiceworks.com/t/how-do-we-authenticate-spiceworks-with-our-local-active-directory/952849)
   > Me and my team have been struggling getting Spiceworks and our Active Directory for the user portal for our staff to sign in with their AD Accounts and create ...

[35] [Configure Active Directory authentication - Sophos Firewall](https://docs.sophos.com/nsg/sophos-firewall/22.0/Help/en-us/webhelp/onlinehelp/AdministratorHelp/Authentication/Servers/AD/AuthenticationConfigureActiveDirectory/)
   > Import Active Directory groups · Go to Authentication > Servers and click Import · In the Import group wizard, click Start. · Select the base DN ...

[36] [在本地用Ollama 搭配Open WebUI 做一個聊天界面吧！ - iT 邦幫忙](https://ithelp.ithome.com.tw/articles/10357750)
   > 安裝方式很簡單，直接用 ollama pull [模型在Ollama library 的名字] 就行，這邊下載8b 參數大小的。 ollama pull llama3. 下載完可以直接試用看看 ollama run llama3. image ...

[37] [Authentication | Ad Manager SOAP API - Google for Developers](https://developers.google.com/ad-manager/api/authentication?hl=zh-cn)
   > 生成OAuth2 凭据 · 1. 确定身份验证类型 · 2. 创建OAuth2 凭据 · 3. 配置您的Ad Manager 广告资源网 · 4. 配置和使用客户端库.

[38] [OAuth 2.0 authorization with Microsoft Entra ID](https://learn.microsoft.com/en-us/entra/architecture/auth-oauth2)
   > Microsoft Entra ID supports all OAuth 2.0 flows. Use for: Rich client and modern app scenarios and RESTful web API access.

[39] [Active Directory (AD) 技術整合– Splashtop On-Prem - 支援中心](https://support-splashtoponprem.splashtop.com/hc/zh-tw/articles/360039154374-Active-Directory-AD-%E6%8A%80%E8%A1%93%E6%95%B4%E5%90%88)
   > 首先，您需要將本機AD 伺服器綁定到Splashtop Gateway。新增後，您可以從Gateway 網路控制台輕鬆新增AD 使用者或AD 群組。 請以團隊擁有者身分 ...

[40] [为Oauth 和现代身份验证配置Azure AD - Tableau Help](https://help.tableau.com/current/server/zh-cn/config_oauth_azure_ad.htm)
   > 为Oauth 和现代身份验证配置Azure AD · 步骤1：为Azure 注册OAuth 客户端 · 步骤2：针对Azure 配置Tableau Server · 为站点配置自定义OAuth · 用于OAuth 身份验证的转发代理.

[41] [OAuth2 vs OpenID Connect vs SAML 整合認證比較 - HackMD](https://hackmd.io/@jeff377/oauth2-vs-oidc-vs-saml)
   > 6. 整合認證流程 · OAuth2 流程：Client → Authorization Server → Resource Server · OpenID Connect 流程：Client ← ID Token → User Info ...

[42] [標頭— AD-Service-Token | Adobe Pass](https://experienceleague.adobe.com/zh-hant/docs/pass/authentication/integration-guide-programmers/rest-apis/rest-api-v2/rest-api-v2-appendix/rest-api-v2-appendix-headers/rest-api-v2-appendix-headers-ad-service-token)
   > 概觀. AD-Service-Token要求標頭包含不重複的使用者識別碼，此識別碼是從Adobe Pass驗證系統外部執行的身分服務所取得的 JWS 。 此標頭是專為使用服務 ...

[43] [ABP Web專案整合Azure Active Directory 驗證教學 - 叡揚資訊](https://www.gss.com.tw/blog/abp-use-azure-active-directory-auth)
   > 本篇詳細介紹如何在ABP 專案中整合Azure Active Directory 實現單一登入（SSO），並涵蓋OpenID Connect 設定、程式碼實作、安全性建議與常見錯誤處理。

[44] [23ai 新特性之Azure AD OAuth2 集成实战 - handsup](http://www.821121.com/?p=2183)
   > 所有集成的前提是：在Azure AD 中注册应用，获取Client ID、Tenant ID 等核心参数。 1. 登录Azure 门户并进入Azure AD. 登录Azure 门户，切换到目标Azure AD ...

[45] [整合AD用於ISE GUI和CLI登入- Cisco](https://www.cisco.com/c/zh_tw/support/docs/security/identity-services-engine/217351-ad-integration-for-cisco-ise-gui-and-cli.html)
   > 設定 ; 啟用AD的管理訪問 · Administration > System > Admin Access > Authentication · 從選項 Authentication Method 卡中選擇該選 Password Based 項。



## 相關問題

- Authentik 如何與現有 AD 同步使用者群組？
- Open WebUI 的知識庫如何對應 AD 群組權限？
- Keycloak 設定 LDAP 橋接時需注意哪些配置？
- RAG 系統中向量資料庫如何實現多租戶隔離？
- BookStack 與 Open WebUI 的知識庫如何同步？

