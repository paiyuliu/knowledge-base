$configPath = "C:\Users\u09889\.config\kilo\kilo.jsonc"

if (-not (Test-Path -LiteralPath $configPath)) {
  throw "Kilo config not found: $configPath"
}

$env:KILO_CONFIG_CONTENT = Get-Content -Raw -LiteralPath $configPath
kilocode @args
