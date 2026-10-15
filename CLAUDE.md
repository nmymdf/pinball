# 鐵道劫案 RAILROAD ROBBERY(pinball)— 給 Claude 的專案說明

**先讀 https://github.com/nmymdf/READFIRST(家族所有 App 共用的分工與規則)**,再讀這份。這份只寫這個 App 自己的事。

## 這是什麼
復古美式投幣彈珠檯(火車劫案主題),一份單一 HTML 檔的遊戲,完全離線、不連網、不收集任何資料。爸爸自用、給家人玩。

## 分工
- Android 與電腦版:爸爸與他的 Claude,本 repo `main` 分支。遊戲本體是 `app/src/main/assets/index.html`(這份是唯一的來源)。
- **iPhone / iPad 版:需要**。由 Jay 在 `jaykuo0619/pinball` 的 `ios` 分支、`ios/` 資料夾做原生 iOS 外殼,載入同一份遊戲,走 TestFlight / App Store 上架。
- Android 這邊的 Claude 不改 `ios/`;Jay 那邊的 Claude 不改 `app/`、`pinball-desktop.html`、遊戲本體。遊戲需要為 iPhone 修改時,Jay 寫進 `ios-handoff/IOS_TODO.md` 的 D 區,由爸爸這邊改。

## 文件地圖
| 檔案 | 內容 |
|---|---|
| `ios-handoff/IOS_PORT.md` | 給 Jay 的 Claude:iPhone 版交接規格 |
| `ios-handoff/IOS_TODO.md` | iPhone 版待辦(含合併指令),每次改版更新 |
| `ios-handoff/iPhone版_給家人的步驟.md` | Jay 的操作步驟 |
| `ios-handoff/store/` | App Store 名稱、說明、關鍵字、審核備註、年齡分級答案 |
| `ios-handoff/assets/icon-1024.png` | App Store 圖示(1024、無透明) |
| `ios-handoff/check-store-words.sh` | 送審前檢查:放進 iPhone 版的檔案不得出現其他手機平台的字 |
| `docs/privacy.html` | 隱私權說明頁(App Store 要填網址) |
| `docs/` 其他檔案 | 舊的網頁版(只能用 Safari 加到主畫面),**不是上架用的,不要拿來上架** |

## 一定要遵守(這個 App 特有)
- **放進 iPhone 版的任何東西(遊戲本體、說明、截圖、商店文字、隱私頁)都不能出現其他手機平台的字**(包含「安卓」、品牌名、安裝檔、商店名稱)。上次就因為一個字被退件。每次改遊戲、每次給 Jay 前,跑:
  `bash ios-handoff/check-store-words.sh app/src/main/assets/index.html docs/privacy.html ios-handoff/store`
  有任何一行輸出就要先修。
- 每個設計畫面要顯示「作者：ArchieKUO」(斜體金色)與版本。
- 新的遊戲版本:檔名帶版本(`pinball-vX_Y_Z.html`),不覆蓋舊檔;`app/src/main/assets/index.html` 放最新版。
- 爸爸說「先討論」「先回答」「不動手」:只說明、提建議,不改檔案;等他說「好」才動手。
- 小字讀不到:遊戲內不要靠小字,用燈號。
- 只有一張檯面。不要用 Shift 當擋板鍵。
- 簽章金鑰、`.p12`、描述檔、App Store Connect 金鑰、密碼不 commit(iPhone 用 Xcode 自動簽章)。不要開 PR;commit 訊息不放模型名稱。

## 常用指令
```
bash v2/build.sh   # (爸爸這邊 Claude 的工作區)把原始碼合成單一 HTML
bash ios-handoff/check-store-words.sh app/src/main/assets/index.html
```
Android 打包:推上 `main`,GitHub Actions 自動打包,版本號改 `app/build.gradle.kts`(詳見 READFIRST 的打包說明)。

## 目前狀態(每次改版更新)
- 遊戲 v3.10.3;Android v3.10.3;iPhone:尚未開始(交接文件已備妥)
- 已決定:App Store 英文名稱用 Railroad Robbery;iPhone 與 iPad 都支援(通用 App)
