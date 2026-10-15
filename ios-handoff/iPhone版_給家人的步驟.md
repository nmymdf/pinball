# 鐵道劫案 iPhone 版:操作步驟

寫給在 Mac 上用 Claude 做 iPhone 版的家人(Jay)。程式交給 Claude 寫,你負責:準備環境、回答 Claude 的問題、在 Xcode 和 iPhone 上按它說的按鈕、試用。技術細節在 `ios-handoff/IOS_PORT.md`,那是給 Claude 讀的。

## 一、準備
Mac、Xcode、Apple 開發者帳號、GitHub 帳號、Claude Code、iPhone 與傳輸線,都和做「卡溜趴」時一樣,已經有就不用再裝。沒有的話,步驟照卡溜趴的 `docs/iPhone版_給家人的步驟.md` 第一到三節。

## 二、取得程式
把爸爸的專案 fork 到自己帳號(GitHub 網頁打開 nmymdf/pinball → Fork),然後在終端機:
```
cd ~/Documents
git clone https://github.com/jaykuo0619/pinball.git
cd pinball
git checkout -b ios
claude
```
之後每次繼續做:
```
cd ~/Documents/pinball
claude
```

## 三、第一次跟 Claude 說的話
複製貼上:
```
請先讀 CLAUDE.md 和 ios-handoff/IOS_PORT.md、ios-handoff/IOS_TODO.md。
我們要做鐵道劫案的 iPhone 版,目標是上架 App Store。
請在 ios 分支工作,程式放 ios/ 資料夾,不要改遊戲本體。
做每一步之前先用一兩句話跟我說要做什麼,需要我在 Xcode 或 iPhone 上操作時告訴我點哪裡。
先做 IOS_PORT.md 第 6 節的第 1、2 階段,做之前先跟我說計畫。
```

## 四、做的時候會遇到的事
- Claude 會先問再做:要執行指令或改檔案時會問「可以嗎?」。看一下,沒問題就允許;看不懂就問它。
- 裝到自己的 iPhone:接線 → 手機按「信任這部電腦」→ 設定 → 隱私權與安全性 → 開發者模式(會重開機)→ Xcode 上方選你的 iPhone 按 ▶︎ → 第一次在手機上到 設定 → 一般 → VPN 與裝置管理 信任開發者帳號。
- 要上傳 GitHub 時輸入 `gh auth login`,密碼只在瀏覽器輸入,**不要打在對話裡**。
- 每做完一個階段:跟 Claude 說「幫我 commit 並 push 到 ios 分支」。
- 隔天再做:打開 `claude`,說「我們在做鐵道劫案 iPhone 版,請看 ios-handoff/IOS_TODO.md 和 git log,告訴我做到哪了,接著做下一步」。

## 五、一定要記得
- **App 裡、截圖裡、商店文字裡,不能出現其他手機平台的字。** 送審前叫 Claude 跑 `bash ios-handoff/check-store-words.sh …`(指令寫在 IOS_PORT.md 第 0 節),看到「OK」才送。
- 遊戲本身有問題(字被切、按鈕被遮),不要自己改,寫進 `IOS_TODO.md` 的 D 區,告訴爸爸。

## 六、爸爸要做的
1. 把 Jay 的 GitHub 帳號 `jaykuo0619` 加進 nmymdf/pinball(Settings → Collaborators),或讓他用 fork。
2. 隱私網址:GitHub 專案 Settings → Pages → 來源選 `main`、資料夾選 `/docs`(啟用後 `docs/privacy.html` 就有網址)。
3. 每次改遊戲後,轉告 Jay 固定這一句:
   「nmymdf/pinball 有更新,請合併後讀 CLAUDE.md 和 ios-handoff/IOS_TODO.md,照清單處理 iPhone 版。」
