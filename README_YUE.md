# 粵語即時字幕（Cantonese → 繁體中文）

> 這是 [YozoraRoy/cantonese-live-whisper](https://github.com/YozoraRoy/cantonese-live-whisper) 的個人 fork，**不是 Jason Cheng 的官方版本**。原專案的功能、安裝方式與最新支援，請以 [jasoncheng7115/jt-live-whisper](https://github.com/jasoncheng7115/jt-live-whisper) 為準。

這個版本基於 [jasoncheng7115/jt-live-whisper](https://github.com/jasoncheng7115/jt-live-whisper)（Apache-2.0），加了兩個粵語模式：

| 模式 | 輸入 | 輸出 | 需要 LLM？ |
|---|---|---|---|
| `yue` | 粵語語音 | 繁體中文**口語原文**（保留「冇、嘅、咗」） | 不需要 |
| `yue2zh` | 粵語語音 | 繁體中文**書面語**（冇→沒有、佢哋→他們） | 需要（Ollama 或 OpenAI 相容伺服器） |

## 我為什麼做這個 fork？

不是因為我想重做一套語音工具，而是因為**工作上的線上會議大多說粵語**，我聽不懂會議內容，也無法即時跟上討論。

剛好看到 Jason Cheng 的 [jt-live-whisper](https://github.com/jasoncheng7115/jt-live-whisper)，它已經具備完整的即時辨識、翻譯、WebUI、系統音訊擷取與地端 AI 能力。原作者最初是為了補足英文技術課程的聽力而打造這個工具，後來功能才越來越完整；我的需求則很單純：**在原本的架構上，補上粵語轉繁體中文的能力。**

因此這個 fork 的重點不是重新實作，而是：

- 新增粵語口語轉錄模式
- 新增粵語轉繁體書面語模式
- 讓 WebUI 與命令列都能直接選用粵語模型
- 補上 Teams / Zoom 等系統音訊的實用說明
- 修正實測時遇到的粵語幻覺與重疊字幕問題

原專案的地端執行、隱私、零月租、系統音訊層擷取、講者辨識、AI 摘要與一鍵安裝等完整介紹，請直接看[原專案](https://github.com/jasoncheng7115/jt-live-whisper)與[官方網站](https://jasoncheng7115.github.io/jt-live-whisper/)。

## 與原專案的差異

| 項目 | 原專案 | 本 fork |
|---|---|---|
| 粵語辨識 | 以英、中、日、韓等模式為主 | 新增 `yue`、`yue2zh` 兩個粵語模式 |
| 辨識模型 | 原專案既有 Whisper 模型 | 新增 `yue-whisper-turbo`，對應 `JackyHoCL/whisper-large-v3-turbo-cantonese-yue-english-ct2` |
| 辨識方式 | 依原專案設定 | 粵語固定使用本機 faster-whisper、`language="yue"`，不走 whisper.cpp 或遠端 ASR |
| 輸出內容 | 依原模式翻譯 | `yue` 保留粵語口語（冇、嘅、咗）；`yue2zh` 轉成台灣繁體書面語 |
| 混用語言 | 單一語言模型從頭跑到尾 | 自動偵測錄音中的華語段落，改用 `large-v3-turbo` 補正；華語段落標成 `[中]` |
| 翻譯流程 | 原專案翻譯引擎 | `yue2zh` 使用 Ollama `qwen2.5:7b-instruct`，加入粵語詞彙、台灣用語與繁簡校正規則 |
| WebUI | 原專案模式選單 | 新增粵語模式、自動鎖定粵語模型、限制不相容的翻譯引擎 |
| 即時字幕 | 原專案滑動視窗 | 新增粵語重疊字幕裁切、零時長幻覺過濾、標點邊界裁切，避免把「計劃」切成「劃」 |
| 使用文件 | 原專案 README | 新增 `README_YUE.md`、`start-yue.ps1`、Teams / Loopback 操作說明 |
| 實測 | 原專案測試 | 15 秒粵語 TTS 離線測試、系統音訊 Loopback 即時測試、WebUI 模式與模型驗證 |

> 本 fork 沒有改動原專案的核心架構與既有模式；主要變更集中在粵語 ASR 路由、`yue2zh` 翻譯提示、WebUI 選項與相關修正。

## 實測狀況

- 離線 `yue`：可正確輸出粵語口語繁體字，保留「哋、嘅、冇」。
- 離線 `yue2zh`：可輸出繁體書面語，並避免簡體字與英文動詞殘留。
- 混合語言：以 21 分鐘 Teams 錄影實測，前段華語與後段粵語可自動分流；
  華語段落不再被硬轉成錯誤的粵語內容。
- 即時 `yue`：已用系統音訊 Loopback 播放粵語 TTS 模擬 Teams 對方聲音，可即時產生字幕。
- 即時 `yue` 華語段落：已用系統音訊 Loopback 播放華語音檔，會自動載入
  `large-v3-turbo` 補正，輸出華語內容而不是粵語幻覺。
- 即時 `yue2zh`：同一路徑可即時轉成繁體書面語。
- WebUI：確認粵語模式、粵語模型自動選取與 LLM 設定正常。
- 測試環境：Windows 11、RTX 4060 Laptop 8 GB、Ollama `qwen2.5:7b-instruct`。

## 已知限制

- 即時 `yue2zh` 採滑動音訊視窗，偶爾仍會保留一點上一句的尾巴；要求最乾淨的書面語，建議先錄音再用 `--input` 離線處理。
- 目前只用 TTS 與 Teams 錄影模擬，尚未加入真實 Teams 會議與實際麥克風長時間測試。
- 8 GB VRAM 同時跑 Whisper turbo 與 7B LLM 實測可運作；若遇到 VRAM 不足，可改用 `qwen2.5:3b-instruct`。
- 低音量錄音會自動增益，但現在會依完整檔案的峰值保留 1 dB headroom，不再把後段削峰；若錄音本身爆音，仍無法還原。
- 語言分流是根據辨識結果的詞形（華語詞 vs. 粵語助詞）判斷；若一句話很短、
  又沒有明顯特徵，可能仍由粵語模型處理。

## 用哪個模型？

`yue-whisper-turbo` 會自動對應到：

- Hugging Face：`JackyHoCL/whisper-large-v3-turbo-cantonese-yue-english-ct2`
- Whisper large-v3-turbo 的粵語／英語微調版（MIT 授權，CTranslate2 格式）
- 第一次使用時 faster-whisper 會自動下載（約 1.6 GB）到 Hugging Face 快取
- 只在本機執行（不送到 GPU 伺服器），因為只有 faster-whisper 能載入這個格式

## 粵語／華語混用

實際會議常常不是全程粵語：可能同一個人簡報時說華語，討論時轉回粵語，
或不同與會者使用不同語言。粵語微調模型如果硬套在華語上，會產生
「Mongkok TV」「城市馬來」這類完全偏離原意的內容。

本 fork 會在辨識後檢查每個段落：

- 明顯是華語（出現「這個、我們、然後、已經」等華語詞形，且粵語助詞很少）
  → 自動改用一般 `large-v3-turbo` 重新辨識該段。
- 純粵語（「嘅、咗、喺、佢、哋、唔」等助詞密度高）→ 維持 `yue-whisper-turbo`，
  保留口語。
- `yue` 模式會把華語段落標成 `[中]`，粵語段落標成 `[粵]`。
- `yue2zh` 的華語段落同樣標成 `[中]`，並直接保留繁體中文，不再送 LLM 改寫；
  粵語段落則是 `[粵]` → `[中]` 的書面語翻譯。這樣可以避免模型把華語
  硬翻成粵語或插入英文。

第一次遇到華語段落時會自動下載 `large-v3-turbo`（約 1.6 GB，若尚未快取），
之後就不會再下載。這個補正只在偵測到華語時才啟動，純粵語錄音不會多載模型。

## 快速開始（WebUI，最簡單）

1. 雙擊 `start-yue.ps1`，或在 PowerShell 執行：

   ```powershell
   .\start.ps1 --webui
   ```

2. 瀏覽器打開後：
   - **模式**選「粵語轉錄」或「粵轉繁中字幕」
   - **系統音訊（Loopback）**選「自動偵測」（Teams / Zoom / YouTube 都適用）
   - 按「開始」

第一次載入模型會慢一點，之後會快很多。

### Microsoft Teams / Zoom / Google Meet

程式**不會加入會議**，而是擷取電腦正在播放的聲音（WASAPI Loopback），
所以 Teams 裡其他人講的粵語會直接變成字幕：

1. Teams 的喇叭輸出維持在**預設裝置**（喇叭或耳機都可以，Loopback 抓的是數位音訊）。
2. WebUI 的「系統音訊（Loopback）」選「自動偵測」或你的喇叭。
3. 按「開始」，再讓 Teams 播放會議聲音即可。
4. 要同時收自己的聲音，勾選「轉錄麥克風」並選你的麥克風。

注意：

- `yue2zh` 模式只有**系統音訊（對方）**會翻成書面語；勾選麥克風時，
  自己的聲音只會顯示粵語原文（避免兩路同時翻書面語互相干擾）。
- 如果 Teams 使用「獨佔模式」或某些藍牙耳機的免手持裝置，Loopback 可能抓不到；
  把 Teams 輸出改成一般喇叭／耳機再試。
- 不需要安裝虛擬音效卡；Windows 的 WASAPI Loopback 是內建功能。

命令列等價作法（`-100` 是 Windows 系統音訊的保留編號）：

```powershell
# 只聽對方（Teams 播放出來的聲音）
.\start.ps1 --mode yue -d -100
.\start.ps1 --mode yue2zh -d -100 -e llm --llm-model qwen2.5:7b-instruct

# 系統音訊 + 自己的麥克風（麥克風只顯示粵語原文）
.\start.ps1 --mode yue -d -100 --mic
.\start.ps1 --mode yue2zh -d -100 --mic -e llm --llm-model qwen2.5:7b-instruct
```

## 命令列（Cmd / PowerShell）

先看音訊裝置編號：

```powershell
.\start.ps1 --list-devices
```

用麥克風即時轉錄粵語口語：

```powershell
.\start.ps1 --mode yue -d 3
```

用麥克風即時輸出書面語（需要 Ollama）：

```powershell
.\start.ps1 --mode yue2zh -d 3 -e llm --llm-model qwen2.5:7b-instruct
```

離線處理音檔：

```powershell
.\start.ps1 --input .\recordings\test.mp3 --mode yue
.\start.ps1 --input .\recordings\test.mp3 --mode yue2zh -e llm --llm-model qwen2.5:7b-instruct
```

> `-d` 是裝置編號；`--mode yue` 不指定 `-d` 時會自動選系統音訊（Loopback），
> 所以要轉麥克風請務必加 `-d <麥克風編號>`。
>
> 即時模式預設用 `training` 場景（8 秒緩衝、3 秒步進）。`yue2zh` 因為
> 滑動視窗的關係，偶爾會重複上一句的尾巴；要求最完整、最乾淨的書面語，
> 建議先錄音再用 `--input` 離線處理。

## LLM 設定（yue2zh 用）

本機 Ollama：

```powershell
ollama serve
ollama pull qwen2.5:7b-instruct
```

`config.json` 已預設：

```json
{
  "llm_host": "127.0.0.1",
  "llm_port": 11434,
  "ollama_model": "qwen2.5:7b-instruct"
}
```

> 目前程式內建的摘要預設模型不是 `qwen2.5:7b-instruct`。若要用 `--summarize`
> 產生會議摘要，請明確指定：
>
> ```powershell
> .\start.ps1 --summarize .\logs\粵語_逐字稿_xxxx.txt --summary-model qwen2.5:7b-instruct
> ```

8 GB VRAM 的筆電（例如 RTX 4060 Laptop）同時跑 Whisper turbo + 7B 可能會吃緊；
若出現 VRAM 不足或很慢，可改用：

```powershell
ollama pull qwen2.5:3b-instruct
.\start.ps1 --mode yue2zh -d 3 -e llm --llm-model qwen2.5:3b-instruct
```

## 輸出用語

預設是**台灣繁體用語**（軟體、記憶體、程式、伺服器）。
如果要香港用語（軟件、記憶體、程式／項目），改 `translate_meeting.py` 裡
`_build_prompt_yue2zh()` 的規則 4，或把該行刪掉即可。

## 常見問題

**Q：輸出變成書面華語，沒有「冇、嘅、咗」？**
- 確認模式是 `yue`，而且模型是 `yue-whisper-turbo`（不是 `large-v3-turbo`）。
- `yue2zh` 本來就會改寫成書面語；要口語原文請用 `yue`。

**Q：出現 `Language 'yue' is not supported`？**
- 更新 faster-whisper / ctranslate2：

  ```powershell
  .\venv\Scripts\python.exe -m pip install -U faster-whisper ctranslate2
  ```

- `yue` 語言 token 只有 large-v3 系列模型支援，不能用 small / medium。

**Q：麥克風沒有聲音？**
- 用 `.\start.ps1 --list-devices` 確認編號，並用 `-d <編號>` 指定麥克風。
- Windows 設定 → 隱私權 → 麥克風，允許桌面應用程式存取。

**Q：第一次啟動很久？**
- 正在下載粵語模型（約 1.6 GB）與初始化 CUDA，只有第一次會這樣。
- 若會議中出現華語段落，第一次還會下載一般 `large-v3-turbo`（約 1.6 GB）
  用來補正；之後會直接使用快取。

## 授權與致謝

- 本 fork 基於 [jasoncheng7115/jt-live-whisper](https://github.com/jasoncheng7115/jt-live-whisper)，沿用原專案的 **Apache-2.0** 授權；原始授權條款請看 [`LICENSE`](LICENSE)，修改說明請看 [`NOTICE`](NOTICE)。
- 粵語微調模型 [`JackyHoCL/whisper-large-v3-turbo-cantonese-yue-english-ct2`](https://huggingface.co/JackyHoCL/whisper-large-v3-turbo-cantonese-yue-english-ct2) 為 **MIT** 授權。
- 原專案作者：**Jason Cheng（Jason Tools）**。
- 本 repo 是個人 fork，非原作者官方版本，也不代表原作者背書。
