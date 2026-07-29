# 07-25로 잘못 표기된 가이드 3편의 표시날짜/스키마/사이트맵 lastmod 를 07-29로 정정 (URL 슬러그는 유지)
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
function EditKeep([string]$rel,[hashtable]$repls){
  $full=Join-Path $repo $rel
  $b=[System.IO.File]::ReadAllBytes($full)
  $bom=($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)
  $t=[System.Text.Encoding]::UTF8.GetString($b); if($bom){$t=$t.TrimStart([char]0xFEFF)}
  foreach($k in $repls.Keys){ $t=$t.Replace($k,$repls[$k]) }
  [System.IO.File]::WriteAllText($full,$t,(New-Object System.Text.UTF8Encoding($bom)))
}

# 1) 개별 글 3편: 표시날짜 + 스키마 datePublished/dateModified (URL·canonical·og:url·mainEntityOfPage 은 건드리지 않음)
$posts=@(
 'blog/2026-07-25-bluetooth-vs-mobile-card-terminal.html',
 'blog/2026-07-25-card-terminal-internet-vs-phone-line.html',
 'blog/2026-07-25-pos-rental-vs-purchase-guide.html')
foreach($p in $posts){
  EditKeep $p @{
    '2026.07.25' = '2026.07.29'
    '"datePublished":"2026-07-25"' = '"datePublished":"2026-07-29"'
    '"dateModified":"2026-07-25"' = '"dateModified":"2026-07-29"'
  }
}

# 2) 목록 페이지 카드 표시날짜 (07-25는 이 3개 카드에만 존재 → 안전)
$lists=@('blog.html'); $n=2
while(Test-Path (Join-Path $repo "blog-$n.html")){ $lists+="blog-$n.html"; $n++ }
foreach($l in $lists){ EditKeep $l @{ '2026.07.25' = '2026.07.29' } }

# 3) 사이트맵 lastmod (loc 의 슬러그 날짜는 유지)
EditKeep 'sitemap.xml' @{ '<lastmod>2026-07-25</lastmod>' = '<lastmod>2026-07-29</lastmod>' }

Write-Output '날짜 정정 완료 (07-25 -> 07-29, URL 유지)'
