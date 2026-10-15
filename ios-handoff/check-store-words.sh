#!/bin/bash
# 送審前檢查:放進 iPhone App 的檔案與 App Store 文字裡,不能出現其他手機平台的字。
# 用法: bash ios-handoff/check-store-words.sh <檔案或資料夾> [更多...]
# 例:   bash ios-handoff/check-store-words.sh ios/鐵道劫案/Resources ios-handoff/store docs/privacy.html
# 看到任何一行輸出就是有問題,要先請爸爸那邊把遊戲改乾淨,不要自己在 iOS 端硬刪。
python3 -I - "$@" <<'PY'
import re,sys,os
BAD=r"android|安卓|安桌|apk\b|google ?play|play ?store|谷歌|samsung|三星|webview|加入主畫面|add to home screen|\bpwa\b|chrome"
hits=0
def scan(p):
    global hits
    try: s=open(p,encoding='utf8').read()
    except Exception: return
    s=re.sub(r"data:[a-zA-Z/+\-]+;base64,[A-Za-z0-9+/=]+","DATA",s)
    for m in re.finditer(BAD,s,re.I):
        hits+=1
        print("%s: ...%s..."%(p,s[max(0,m.start()-30):m.end()+30].replace("\n"," ")))
for a in sys.argv[1:]:
    if os.path.isdir(a):
        for r,_,fs in os.walk(a):
            for f in fs:
                if f.lower().endswith(('.html','.js','.css','.json','.md','.txt','.plist','.strings','.swift','.webmanifest','.xml')): scan(os.path.join(r,f))
    else: scan(a)
print("找到 %d 處問題"%hits if hits else "OK:沒有其他平台的字")
sys.exit(1 if hits else 0)
PY
