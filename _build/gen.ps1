# 지역별 테이블오더/무인자판기 페이지 생성기 (이동식 - 어느 컴퓨터에서도 작동)
# 사용법(PowerShell): powershell -ExecutionPolicy Bypass -File _build\gen.ps1
# (이 파일은 BOM 포함 UTF-8로 저장해야 한글이 안 깨집니다)
$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot -Parent
$root=Join-Path $repo 'region'
$tplT=Get-Content (Join-Path $PSScriptRoot 'tpl-tableorder.html') -Raw -Encoding UTF8
$tplV=Get-Content (Join-Path $PSScriptRoot 'tpl-vending.html') -Raw -Encoding UTF8
$enc=New-Object System.Text.UTF8Encoding($false)
$files=Get-ChildItem "$root\*.html" | Where-Object { $_.Name -notlike '*-tableorder.html' -and $_.Name -notlike '*-vending.html' }
$ct=0; $cv=0; $cc=0; $skip=@()
foreach($f in $files){
  $slug=$f.BaseName
  $html=Get-Content $f.FullName -Raw -Encoding UTF8
  if($html -notmatch '<div class="crumb2">홈 › 지역 안내 › (.+?) › <b>(.+?)</b></div>'){ $skip+=$slug; continue }
  $province=$Matches[1].Trim()
  $district=$Matches[2].Trim()
  $dongsHtml=''
  if($html -match '(?s)<div class="dongs">(.*?)</div>'){
    $inner=$Matches[1]
    $dm=[regex]::Matches($inner,'>([^<]+)</a>')
    foreach($m in $dm){
      $d=$m.Groups[1].Value.Trim()
      if($d){ $dongsHtml+=('<a href="tel:01068321994" title="'+$district+' '+$d+' 설치">'+$d+'</a>') }
    }
  }
  $outT=$tplT.Replace('{{PROVINCE}}',$province).Replace('{{DISTRICT}}',$district).Replace('{{SLUG}}',$slug).Replace('{{DONGS}}',$dongsHtml)
  [System.IO.File]::WriteAllText((Join-Path $root ($slug+'-tableorder.html')),$outT,$enc); $ct++
  $outV=$tplV.Replace('{{PROVINCE}}',$province).Replace('{{DISTRICT}}',$district).Replace('{{SLUG}}',$slug).Replace('{{DONGS}}',$dongsHtml)
  [System.IO.File]::WriteAllText((Join-Path $root ($slug+'-vending.html')),$outV,$enc); $cv++
  if($html -notmatch '다른 설치 서비스'){
    $block='<div class="rwrap"><div class="rcontent"><h2>'+$district+' 다른 설치 서비스</h2><p><a href="'+$slug+'-tableorder.html">🍽️ '+$district+' 테이블오더 설치 →</a><br><a href="'+$slug+'-vending.html">🥤 '+$district+' 무인자판기 설치 →</a></p></div></div>'+"`n"
    if($html.Contains('<div class="rband">')){
      $html=$html.Replace('<div class="rband">',$block+'<div class="rband">')
      [System.IO.File]::WriteAllText($f.FullName,$html,$enc); $cc++
    }
  }
}
Write-Output ("테이블오더 생성: "+$ct+"개")
Write-Output ("무인자판기 생성: "+$cv+"개")
Write-Output ("카드단말기 링크 삽입: "+$cc+"개")
if($skip.Count -gt 0){ Write-Output ("건너뜀("+$skip.Count+"): "+($skip -join ', ')) } else { Write-Output "건너뛴 파일 없음" }
