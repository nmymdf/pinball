# iPhone 版待辦

> 給 Jay 和他的 Claude。每次爸爸那邊改版,iPhone 要跟著做的事加在這裡。規格在 `IOS_PORT.md`。
>
> 最後更新:2026-10-15(遊戲 v3.10.3;iPhone 版尚未開始)

## 怎麼把爸爸的改動拿到 ios 分支

在 Jay 的 repo(`jaykuo0619/pinball`):

```
git remote add upstream https://github.com/nmymdf/pinball.git   # 第一次才需要
git fetch upstream main
git checkout ios
git merge upstream/main
```

第一次要先建立 `ios` 分支:`git checkout -b ios`,iPhone 程式只放 `ios/`,合併不會衝突。

合併後最新的遊戲在 `app/src/main/assets/index.html`,重新複製進 App 資源,再跑:
`bash ios-handoff/check-store-words.sh <App資源資料夾> ios-handoff/store docs/privacy.html`

---

## A. 第一次做(照 IOS_PORT.md 第 6 節)

- [ ] 1. 建立 Xcode 專案、載入遊戲(IOS_PORT 第 2 節)
- [ ] 2. 安全區、方向、手勢、螢幕常亮、聲音、背景切換
- [ ] 3. 實機驗證 IOS_PORT 第 3 節的 8 條
- [ ] 4. 圖示(`assets/icon-1024.png`)、啟動畫面、名稱、版本
- [ ] 5. 檢查工具輸出「OK」
- [ ] 6. TestFlight 內部測試
- [ ] 7. 商店文字、截圖、隱私網址(需要爸爸啟用 Pages 或改用別的網址)
- [ ] 8. 送審

## B. 要跟著爸爸改版的項目

| 遊戲版本 | 項目 | iPhone 要做的事 |
|---|---|---|
| v3.10.3 | 遊戲內全部英文(選 English 後整個遊戲都是英文) | 實機驗證:切英文後所有畫面字沒被切、按鈕字不爆版;檢查工具跑過 |

(之後每版加一行。)

## C. 只有爸爸那邊、iPhone 不用做

- 電腦版 `pinball-desktop.html`、手機外殼 `app/`。

## D. 需要爸爸那邊改遊戲的事(Jay 填寫)

- 例:`[ ] 現象 / 機型與 iOS 版本 / 截圖`
