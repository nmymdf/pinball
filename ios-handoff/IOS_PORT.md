# 鐵道劫案 iPhone 版:移植交接文件

> 給在 Mac 上做 iPhone 版的 Claude Code 讀。人看的步驟在 `iPhone版_給家人的步驟.md`。
> 與使用者溝通一律使用**繁體中文**;程式碼與註解可用英文。

## 0. 先讀這裡

- **目標**:做出一個**可以上 App Store 的原生 iOS App**(SwiftUI/UIKit 外殼 + `WKWebView` 載入同一份遊戲)。不是網頁版(PWA)。repo 的 `docs/` 裡舊的網頁版只能用 Safari 加到主畫面,**不能拿來上架,不要用**。
- **遊戲本體不要改、不要在 iOS 端複製出另一份修改版**。唯一來源是 `app/src/main/assets/index.html`(目前 v3.10.3,單一檔案、所有圖片聲音都內嵌、不連網)。做 App 時用建置腳本把它複製進 App 的資源(Run Script 或手動複製都行),每次爸爸改版後合併、重新複製即可。
- 遊戲需要為 iPhone 改動時(例如安全區、字被切):**不要自己改遊戲**,寫進 `IOS_TODO.md` 的 D 區,請爸爸那邊的 Claude 改。
- **程式放 `ios/`**(Xcode 專案)。不要改 `app/`、`pinball-desktop.html`、`docs/`(除非爸爸要你)。
- **repo 是公開的**:不可 commit 憑證、`.p12`、描述檔、App Store Connect 金鑰、密碼。簽章用 Xcode 自動簽章。不要叫使用者把密碼貼進對話。
- commit 訊息不放模型名稱;沒被要求不開 PR。
- 每個階段(第 6 節)做完要能編譯、在模擬器跑、再 commit。
- 使用者是第一次上架:每步先說做什麼,需要他按 Xcode 或手機時寫清楚點哪裡。

### 最重要的一條:不能出現其他手機平台的字
上次這個家族的 App 因為**一個字**被 App Review 退件。放進 iPhone 版的任何東西——遊戲、啟動畫面、說明、截圖、App Store 文字、隱私頁、審核備註——都不能出現其他手機平台的名稱、品牌、安裝檔、商店名稱,也不能出現「加到主畫面」「PWA」這類網頁字眼。
- 送審前、每次更新遊戲後都跑:
  `bash ios-handoff/check-store-words.sh ios/<App資源資料夾> ios-handoff/store docs/privacy.html`
- 有輸出就是有問題:停下來、寫進 `IOS_TODO.md` D 區,等爸爸那邊修好遊戲再合併。**不要在 iOS 端用取代字串硬刪。**
- 截圖也要看:不要截到電腦版的操作說明或其他平台字樣。

## 1. App 是什麼

復古美式投幣彈珠檯,火車劫案主題。一台完整檯面:五顆彩色彈跳器、擋板、任務、金庫副畫面(劫火車車廂)、多球、結算。有首頁(開始遊戲/玩法說明/繁體中文·English)。
- 語言:繁體中文與 English 兩種,首頁可切換,依系統語言自動選(`localStorage` 鍵 `pinball_lang`)。
- 存檔:只有最高分(`pinball_train_hi`)與語言(`pinball_lang`),都在 `localStorage`。
- 完全離線:沒有任何網路請求(已檢查,原始碼沒有網址)。
- 手機模式:遊戲自己偵測(高度 > 寬度 × 1.1 且寬度 < 900)就切成手機版面:上方分數列、中間檯面、下方「左擋板/右擋板/發射/搖機/暫停」大按鈕,觸控即可玩,不需要鍵盤。

## 2. 技術做法(建議)

| 項目 | 建議 |
|---|---|
| 外殼 | SwiftUI App + `UIViewRepresentable` 包 `WKWebView`;最低 iOS 16 或 17 |
| 載入方式 | 打包 `game.html` 進 App;用 `loadFileURL(_:allowingReadAccessTo:)` 載入。**驗證:關掉 App 再開,最高分和語言還在**。若會消失,改用自訂網址協定(`WKURLSchemeHandler`)提供同一份檔案,讓 `localStorage` 有穩定的來源 |
| 版面 | 讓 WebView 放在**安全區內**(上方狀態列/動態島、下方橫條),背景色 `#080503`(與遊戲同色),`contentInsetAdjustmentBehavior = .never`。這樣遊戲不用改 |
| 裝置 | **iPhone 與 iPad 都支援(通用 App,爸爸決定)**。爸爸有 iPad 可以測 |
| 方向 | iPhone 只允許直式;iPad 先做直式(遊戲在直式有手機版面,iPad 直式寬度 < 900 也會用),橫式先鎖掉,之後視實測再決定 |
| 手勢 | 關掉:縮放、雙擊放大、長按選字/放大鏡、橡皮筋回彈(`scrollView.bounces=false`、`isScrollEnabled=false`);CSS 已有 `touch-action:none`,仍要實機確認 |
| 多點觸控 | 一定要開(`isMultipleTouchEnabled = true`):左右擋板可能同時按。實機驗證同時按兩邊 |
| 螢幕 | 玩的時候不自動關螢幕:`UIApplication.shared.isIdleTimerDisabled = true`;隱藏狀態列;`prefersHomeIndicatorAutoHidden = true` |
| 聲音 | 遊戲用 WebAudio,第一次點一下畫面才會響(已處理)。建議 `AVAudioSession` 設 `.ambient`(會跟著靜音開關,不打斷使用者的音樂)。實機驗證:靜音開關、插耳機、來電後回來聲音還在 |
| 背景切換 | 回到桌面再回來,遊戲要暫停或繼續正常(遊戲有處理 `visibilitychange`)。驗證接電話、切 App 後按鍵不會卡住 |
| 圖示 | `assets/icon-1024.png`(1024×1024、無透明、無圓角,Xcode 會自己切圓角),放進 `AppIcon` |
| 啟動畫面 | 用原生 Launch Screen:深色底 `#080503` + 中央圖示,避免閃白。**要有**,審核比較看得出是用心做的 App |
| 名稱 | 中文「鐵道劫案」;英文「Railroad Robbery」(爸爸已決定)。Bundle ID 建議 `com.archiekuo.pinball`(與家族另一個 App `com.archiekuo.travelledger` 同風格,Jay 可改) |
| 版本 | 顯示版本沿用遊戲內字樣(v3.10.3);`CFBundleShortVersionString` 寫 `3.10.3`,Build 從 1 開始每次上傳 +1 |

## 3. 要驗證的事(實機,不是只有模擬器)

1. 直式滿版,上下沒有被瀏海或橫條遮到按鈕(特別是底部的大按鈕列)。
2. 同時按住左、右擋板,兩邊都動。按「發射」蓄力與放開正常。
3. 聲音:第一次點「開始遊戲」後有音效;靜音開關;切到別的 App 再回來。
4. 最高分:玩一局得分後完全關掉 App(從多工畫面往上滑掉)再開,最高分還在;語言選擇還在。
5. 切英文後,遊戲裡所有字都是英文(爸爸已做完整英文);切回中文正常。
6. 全程沒有網路也能玩(開飛航模式測)。
7. 連續玩 15 分鐘不發燙、不掉格;沒有記憶體警告。
8. 送審前跑檢查工具(見第 0 節),輸出必須是「OK」。

## 4. App Store 上架所需(文字都在 `store/`)

- `store/app-store-text.md`:名稱、副標題、描述(中英)、關鍵字、分類、版權、網址、審核備註、年齡分級答案、隱私問卷答案。
- 隱私網址:`docs/privacy.html`。網頁要先發布才有網址:GitHub repo → Settings → Pages → 來源選 `main` 的 `/docs`(爸爸那邊尚未啟用,需要他設定;或 Jay 改用自己的網站)。
- 截圖:iPhone 6.9 吋(1320×2868)至少 3 張,實機或模擬器截;iPad 13 吋(2064×2752)也要至少 3 張(因為支援 iPad)。可以請爸爸這邊的 Claude 用同一份遊戲產生標準尺寸的截圖。截圖不可含其他平台字樣、不可含電腦鍵盤說明。
- 審核備註用 `store/app-store-text.md` 裡寫好的那段:說明無需登入、離線、無內購。

## 5. 審核風險與對策

| 風險 | 對策 |
|---|---|
| 只是網頁包起來(指南 4.2) | 離線完整遊戲、原生啟動畫面、原生圖示、安全區與觸控調校、音效與生命週期處理;審核備註說明 |
| 出現其他平台字樣(指南 2.3.10) | 檢查工具 + 截圖檢查,見第 0 節 |
| 模擬賭博 | 遊戲的「投幣/CREDIT」只是街機機台的虛擬局數,沒有金錢、沒有下注、沒有內購;問卷「模擬賭博」答「無」 |
| 暴力 | 火車劫案卡通風格,擊落搶匪是動畫;問卷「卡通或幻想暴力」答「偶爾/輕微」,年齡分級照問卷自動算 |
| 崩潰 | 實機測 + TestFlight 先讓家人用幾天 |

## 6. 開發順序

1. 建立 Xcode 專案(`ios/`),載入 `game.html`,模擬器上能玩。
2. 安全區、方向、手勢、螢幕常亮、聲音、背景切換;實機逐條驗證第 3 節。
3. 圖示、啟動畫面、名稱、版本;跑檢查工具。
4. TestFlight 內部測試(Jay、爸爸的 iPad、家人)。
5. 截圖、商店文字、隱私網址;送審。
6. 之後每次爸爸改版:合併 → 重新複製遊戲 → 跑檢查 → 實機點一輪 → 上傳新 Build。

## 7. 與爸爸這邊的約定

- 爸爸的 Claude 改遊戲後會更新 `IOS_TODO.md`(寫版本、改了什麼、iPhone 要不要重驗)。
- Jay 需要遊戲改動時,寫進 `IOS_TODO.md` D 區,並標明:現象、機型/iOS 版本、截圖。
- 檔案格式:遊戲只有 `localStorage` 兩個鍵,兩邊都不要改鍵名。
