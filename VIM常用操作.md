# vim 常用操作 有哪些

Vim 的常用操作主要分為四大核心模式與對應的快捷指令：進入一般模式後，所有鍵盤輸入都會被視為編輯指令。 [1, 2] 
您可以參考 [Vim Cheat Sheet](https://vim.rtorr.com/lang/zh_tw) 進行互動式查詢，以下整理最常用的核心操作： [3] 
## 1. 核心模式切換

* i：在游標前方進入插入模式（Insert Mode）
* a：在游標後方進入插入模式
* o：在當前行下方插入新行並進入插入模式
* Esc：從任何模式返回一般模式（Normal Mode） [4, 5] 

## 2. 移動游標

* h、j、k、l：左、下、上、右移動游標
* w / b：向後 / 向前移動一個單詞（Word）
* 0 / $：移動到行首 / 行尾
* gg / G：移動到檔案最上方 / 最下方 [6] 

## 3. 編輯與修改

* x：刪除游標所在的單個字元
* dd：刪除（剪下）整行
* yy：複製整行
* p：貼上於游標下方或後方
* u：復原（Undo）上一步操作
* Ctrl + r：重做（Redo） [4] 

## 4. 搜尋與存檔離開

* /：輸入關鍵字向下搜尋（按 n 找下一個，N 找上一個）
* :w：儲存檔案
* :q：離開（未修改時）
* :wq 或 :x：儲存並離開
* :q!：強制離開且不儲存修改
* 深入查閱更完整的快速鍵對照，可參考 [Vim 常用按鍵整理](https://hackmd.io/@lunzaizai/BJX4hlPKY)。
* 了解基礎觀念與安裝細節可參考 [Vim 基礎常用指令](https://5xcampus.com/posts/vim-commands)。 [1, 4, 5, 6, 7, 8] 

如果您想針對特定需求練習，請問您需要了解：

* 巨集（Macro）與進階取代（Substitute）的用法？
* 如何設定 .vimrc 顯示行號與色彩？


[1] [https://bingdoal.github.io](https://bingdoal.github.io/dev-tools/2021/07/vim-usual-operation/)
[2] [https://youngwanjin.github.io](https://youngwanjin.github.io/wiki/vim/)
[3] [https://vim.rtorr.com](https://vim.rtorr.com/lang/zh_tw)
[4] [https://blog.csdn.net](https://blog.csdn.net/qq_41483419/article/details/133920397)
[5] [https://5xcampus.com](https://5xcampus.com/posts/vim-commands)
[6] [https://blog.csdn.net](https://blog.csdn.net/sinat_35773915/article/details/132201079)
[7] [https://www.vixual.net](http://www.vixual.net/blog/archives/234)
[8] [https://hackmd.io](https://hackmd.io/@lunzaizai/BJX4hlPKY)

## 更多 Vim 快速移動與翻頁的實用快捷鍵

以下為您整理 Vim 中最經典且高效的快速移動與翻頁快捷鍵。掌握這些按鍵後，您的雙手就不需要離開主鍵盤區，編輯速度會大幅提升！
## 1. 基礎與進階翻頁（代替 Page Up / Down）
當你需要閱讀長檔案時，這組快捷鍵比 Page Up / Down 更順手：

* Ctrl + f：向下翻一整頁（Forward）。
* Ctrl + b：向上翻一整頁（Backward）。
* Ctrl + d：向下翻半頁（Down，大範圍瀏覽時極度推薦）。
* Ctrl + u：向上翻半頁（Up）。

## 2. 螢幕視角與游標定位
不需要捲動檔案，直接將游標跳躍到目前螢幕畫面的特定位置：

* H：跳到目前螢幕的最上方（High）。
* M：跳到目前螢幕的中間（Middle）。
* L：跳到目前螢幕的最下方（Low）。
* z + z：把目前游標所在行捲動到螢幕正中央（非常實用！）。

## 3. 以「單字」為單位的水平移動
比用左右方向鍵一格一格按快上數倍：

* w：跳到下一個單字的字首（word）。
* b：跳回前一個單字的字首（back）。
* e：跳到下一個單字的字尾（end）。
* 提示：使用大寫的 W、B、E 可以忽略標點符號，直接以空白鍵區隔的單字進行大跳躍。

## 4. 行內快速橫移（代替 Home / End）

* 0（數字零）：跳到該行的絕對開頭。
* ^：跳到該行第一個「非空白」字元（程式碼縮排開頭）。
* $：跳到該行的結尾。
* f + 任意字元：向後搜尋該字元，游標會直接停在上面（例如 fa 跳到下一個字母 a）。

## 5. 跨行與全檔案的大範圍垂直跳躍

* G：直接跳到檔案的最後一行。
* g + g：直接跳到檔案的第一行。
* 數字 + G：直接跳到指定行號（例如 10G 跳到第 10 行）。
* }：跳到下一個段落（下一個空白行）。
* {：跳回前一個段落。

如果您想更進一步，我可以和您分享：

* 如何結合這些移動鍵與「刪除/複製」指令來快速修改程式碼
* 如何在 Vim 裡顯示行號或搜尋特定關鍵字進行跳躍


## 請再介紹一下 vim find , grep, regex find 與 進階取代

Vim 的搜尋與取代功能非常強大，主要分為單一檔案搜尋（Find）、多檔案搜尋（Grep）、正規表示式（Regex）與進階取代（Substitute）四大核心。
------------------------------
## 1. 單一檔案搜尋 (Find)
在一般模式（Normal Mode）下，最直覺的搜尋方式：

* /關鍵字：向下搜尋關鍵字。
* ?關鍵字：向上搜尋關鍵字。
* n：跳到下一個符合的位置。
* N：跳到上一個符合的位置。
* *：將游標停在某個單字上按 *，可以直接向下搜尋該單字。
* #：將游標停在某個單字上按 #，可以直接向上搜尋該單字。

------------------------------
## 2. 進階取代 (Substitute)
Vim 的取代語法結構為 :[範圍]s/[尋找字串]/[替換字串]/[參數]。

* :s/old/new/：只取代目前這一行的第一個 "old"。
* :s/old/new/g：取代目前這一行所有的 "old"（g 代表 global）。
* :%s/old/new/g：取代整個檔案中所有的 "old"（% 代表全檔案）。
* :%s/old/new/gc：取代整個檔案的 "old"，但每次替換前都跳出提示確認（c 代表 confirm）。
* :10,20s/old/new/g：僅取代第 10 行到第 20 行之間的 "old"。

------------------------------
## 3. 正規表示式搜尋 (Regex Find)
Vim 的正規表示式（Regex）預設需要對某些特殊符號進行反斜線 \ 轉義。若想使用類似 Python 或 JavaScript 的 Regex，可以在圖樣開頭加上 \v（Very Magic 模式）。

* /\v<cat>：精確比對 "cat" 這個單字（< 和 > 代表單字邊界）。
* /\v\d+：搜尋連續的數字（\d 為數字，+ 為一次以上）。
* /\v(test)+：搜尋重複出現的 "test" 字串。
* /\v^$：搜尋空白行（^ 為行首，$ 為行尾）。

## 💡 進階取代技巧（使用 Regex 暫存器 \1, \2）
如果你想調換文字順序，例如將 LastName, FirstName 變成 FirstName LastName：

:%s/\v(\w+),\s*(\w+)/\2 \1/g


* (\w+) 會被暫存到 \1，第二個 (\w+) 會被暫存到 \2，後方直接用 \2 \1 來重組。

------------------------------
## 4. 多檔案搜尋 (Grep)
當你需要跨檔案搜尋多個原始碼時，可以使用內建的 :grep（預設會調用系統的 grep 指令）。

* :grep "關鍵字" src/**/*.py：在 src 資料夾底下的所有 Python 檔案中搜尋該關鍵字。
* :copen：打開 Quickfix 視窗，裡面會列出所有搜尋到的檔案與行數。
* :cnext (或 :cn)：跳到下一個搜尋結果。
* :cprev (或 :cp)：跳到上一個搜尋結果。
* :cclose：關閉 Quickfix 視窗。

小技巧：現代的 Vim/Neovim 使用者通常會在 .vimrc 中將 grep 工具修改為更快速的 rg (Ripgrep) 或 ag (The Silver Searcher)，體驗會更好。

您目前是否有特定的文字格式需要批次處理？我可以為您撰寫專屬的取代指令，或者您可以選擇了解：

* 如何將搜尋結果套用巨集（Macro）批次修改
* 如何在外掛（如 fzf.vim 或 Telescope）中進行全域搜尋



