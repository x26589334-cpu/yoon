# 김해 포스기 / 평택 카드단말기 / 김포 자판기 3편만 표시날짜·스키마·사이트맵을 07-29 -> 08-02 (URL 슬러그 유지). 다른 07-29 글은 건드리지 않음.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
function EditKeep([string]$rel,[hashtable]$repls){
  $full=Join-Path $repo $rel
  if(-not (Test-Path $full)){ return }
  $b=[System.IO.File]::ReadAllBytes($full)
  $bom=($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)
  $t=[System.Text.Encoding]::UTF8.GetString($b); if($bom){$t=$t.TrimStart([char]0xFEFF)}
  foreach($k in $repls.Keys){ $t=$t.Replace($k,$repls[$k]) }
  [System.IO.File]::WriteAllText($full,$t,(New-Object System.Text.UTF8Encoding($bom)))
}

# 1) 개별 글 3편 (표시날짜 + 스키마). URL/canonical/og:url/mainEntityOfPage 은 건드리지 않음
$posts=@('blog/2026-07-29-gimhae-pos.html','blog/2026-07-29-pyeongtaek-card.html','blog/2026-07-29-gimpo-vending.html')
foreach($p in $posts){
  EditKeep $p @{
    '2026.07.29' = '2026.08.02'
    '"datePublished":"2026-07-29"' = '"datePublished":"2026-08-02"'
    '"dateModified":"2026-07-29"' = '"dateModified":"2026-08-02"'
  }
}

# 2) 목록 카드 pc-date (고유 라벨로 3개만 정확히)
$lists=@('blog.html'); $n=2
while(Test-Path (Join-Path $repo "blog-$n.html")){ $lists+="blog-$n.html"; $n++ }
foreach($l in $lists){
  EditKeep $l @{
    '2026.07.29 · 김해 포스기'     = '2026.08.02 · 김해 포스기'
    '2026.07.29 · 평택 카드단말기' = '2026.08.02 · 평택 카드단말기'
    '2026.07.29 · 김포 자판기'     = '2026.08.02 · 김포 자판기'
  }
}

# 3) 사이트맵 lastmod (해당 URL 라인만)
EditKeep 'sitemap.xml' @{
  '2026-07-29-gimhae-pos.html</loc><lastmod>2026-07-29</lastmod>'     = '2026-07-29-gimhae-pos.html</loc><lastmod>2026-08-02</lastmod>'
  '2026-07-29-pyeongtaek-card.html</loc><lastmod>2026-07-29</lastmod>' = '2026-07-29-pyeongtaek-card.html</loc><lastmod>2026-08-02</lastmod>'
  '2026-07-29-gimpo-vending.html</loc><lastmod>2026-07-29</lastmod>'   = '2026-07-29-gimpo-vending.html</loc><lastmod>2026-08-02</lastmod>'
}

Write-Output '3편 날짜 07-29 -> 08-02 정정 완료 (URL 유지, 다른 글 미변경)'
