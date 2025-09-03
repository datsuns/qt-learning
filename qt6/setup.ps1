param(
    [string]$QtVersion = "6.5.2",
    [string]$Compiler = "msvc2019_64",
    [string]$InstallPath = "C:\Qt\qt6"
)

$qtBase = Join-Path $InstallPath "$QtVersion\$Compiler"

if (-not (Test-Path $qtBase)) {
    Write-Host "Qt $QtVersion ($Compiler) が $qtBase に見つかりません。" -ForegroundColor Yellow
    Write-Host "Qtのオンラインインストーラをダウンロードして起動します。セットアップ完了後に再度このスクリプトを実行してください。"
    $installer = Join-Path $env:TEMP "qt-online-installer.exe"
    Invoke-WebRequest -Uri "https://download.qt.io/official_releases/online_installers/qt-unified-windows-x64-online.exe" -OutFile $installer
    Start-Process -FilePath $installer -Wait
}

if (Test-Path $qtBase) {
    [Environment]::SetEnvironmentVariable("Qt6_DIR", $qtBase, "User")
    [Environment]::SetEnvironmentVariable("QTDIR", $qtBase, "User")
    $path = [Environment]::GetEnvironmentVariable("PATH", "User")
    if ($path -notlike "*$qtBase\bin*") {
        [Environment]::SetEnvironmentVariable("PATH", "$qtBase\bin;$path", "User")
    }
    Write-Host "Qt 6 の環境変数を設定しました。"
} else {
    Write-Host "Qt 6 がまだインストールされていません。" -ForegroundColor Red
}
