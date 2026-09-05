# "카드계산기", "결제용카드기" 키워드 추가
# 기존 동의어 나열("… 신용카드체크기, 사업자단말기") 뒤에 두 단어를 덧붙입니다.
# 지역 페이지는 각 항목에 지역명이 앞에 붙는 형태라, 그 접두어를 그대로 따라갑니다.
# BOM 포함 UTF-8로 저장해야 실행됨
$ErrorActionPreference='Stop'
$repo = Split-Path -Parent $PSScriptRoot
$enc  = New-Object System.Text.UTF8Encoding($false)

$pattern = '신용카드체크기, ([^,]*?)사업자단말기'
$replace = '신용카드체크기, ${1}사업자단말기, ${1}카드계산기, ${1}결제용카드기'

$files = @()
$files += Get-ChildItem (Join-Path $repo 'index.html')
$files += Get-ChildItem (Join-Path $repo 'product\card-terminal.html')
$files += Get-ChildItem (Join-Path $repo 'region\*.html')

$changed = 0
foreach($f in $files){
  $t = [System.IO.File]::ReadAllText($f.FullName)
  if($t -notmatch $pattern){ continue }
  if($t -match '카드계산기'){ continue }   # 이미 들어간 파일은 건너뜀 (재실행 대비)
  $n = [regex]::Replace($t, $pattern, $replace)
  if($n -ne $t){ [System.IO.File]::WriteAllText($f.FullName, $n, $enc); $changed++ }
}

Write-Output ("동의어 나열에 추가한 파일: " + $changed + "개")
