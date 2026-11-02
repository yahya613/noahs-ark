# Puts the newest app code into the copy already on this PC, for when the normal update can't be built yet.
# It puts the old one back if the new one won't open.
& {
  $version = '0.16.0'
  $sha = 'ba8d2551e924c10e39cd749809e94149af83145cc1600405977dd74e8db347ca'
  $site = 'https://noahs-ark.starktech.workers.dev'
  $dest = if ($env:QUICK_UPDATE_DEST) { $env:QUICK_UPDATE_DEST } else { "$env:LOCALAPPDATA\Programs\Arc" }
  $exe = Join-Path $dest 'Arc.exe'
  $asar = Join-Path $dest 'resources\app.asar'
  if (-not (Test-Path $exe) -or -not (Test-Path $asar)) {
    Write-Host "Noah's Ark isn't installed on this PC, so there's nothing to update."
    return
  }
  Write-Host "Updating to $version"

  [Net.ServicePointManager]::SecurityProtocol = 'Tls12'
  $file = Join-Path $env:TEMP "noahs-ark-update-$PID.asar"
  try {
    Write-Host 'Downloading...'
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -UseBasicParsing -Uri "$site/quick-update/app.asar" -OutFile $file
  } catch {
    Write-Host 'The download failed, and nothing has changed. Check your internet and run this again.'
    return
  }
  if ((Get-FileHash $file -Algorithm SHA256).Hash.ToLower() -ne $sha) {
    Remove-Item $file -Force -ErrorAction SilentlyContinue
    Write-Host 'The download came through wrong, and nothing has changed. Run this again.'
    return
  }

  # Closed properly first, so your tabs are saved.
  $running = { Get-Process Arc -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe } }
  if (& $running) {
    Write-Host 'Closing it...'
    & $running | ForEach-Object { $null = $_.CloseMainWindow() }
    for ($try = 0; $try -lt 40 -and (& $running); $try++) { Start-Sleep -Milliseconds 500 }
    & $running | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
  }

  # Its helper processes can hold the file for a moment after the app itself has gone.
  $old = "$asar.old"
  Remove-Item $old -Force -ErrorAction SilentlyContinue
  $moved = $false
  for ($try = 0; $try -lt 40 -and -not $moved; $try++) {
    try {
      Move-Item $asar $old -ErrorAction Stop
      $moved = $true
    } catch {
      Start-Sleep -Milliseconds 500
    }
  }
  if (-not $moved) {
    Remove-Item $file -Force -ErrorAction SilentlyContinue
    Write-Host 'Something is still holding it open, and nothing has changed. Restart your PC and run this again.'
    return
  }
  Move-Item $file $asar

  Start-Process $exe
  Start-Sleep -Seconds 6
  if (-not (& $running)) {
    Remove-Item $asar -Force -ErrorAction SilentlyContinue
    Move-Item $old $asar
    Start-Process $exe
    Write-Host "The new version wouldn't open, so your old one is back and nothing has changed."
    return
  }
  Remove-Item $old -Force -ErrorAction SilentlyContinue
  Write-Host "Done. It's now version $version."
}
