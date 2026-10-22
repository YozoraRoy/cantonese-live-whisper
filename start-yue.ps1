#Requires -Version 5.1
<#
    粵語即時字幕：一鍵啟動 WebUI
    用法：雙擊本檔，或在 PowerShell 執行 .\start-yue.ps1
#>

$ErrorActionPreference = "Stop"
$SCRIPT_DIR = if ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $PWD.Path
}

Write-Host ""
Write-Host "  粵語即時字幕（Cantonese → 繁體中文）" -ForegroundColor Cyan
Write-Host "  啟動後請在瀏覽器選擇：模式 = 粵語轉錄 / 粵轉繁中字幕" -ForegroundColor Gray
Write-Host ""

& (Join-Path $SCRIPT_DIR "start.ps1") --webui
