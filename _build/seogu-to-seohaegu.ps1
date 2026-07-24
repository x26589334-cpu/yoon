# 인천 서구 -> 인천 서해구 (텍스트만, URL/파일명은 유지). 각 파일 원래 인코딩 보존.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"

function Edit-Keep([string]$path,[scriptblock]$fn){
  $full=Join-Path $repo $path
  $bytes=[System.IO.File]::ReadAllBytes($full)
  $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
  $text=[System.Text.Encoding]::UTF8.GetString($bytes)
  if($hasBom){ $text=$text.TrimStart([char]0xFEFF) }
  $new=& $fn $text
  $enc=New-Object System.Text.UTF8Encoding($hasBom)
  [System.IO.File]::WriteAllText($full,$new,$enc)
  $cnt=([regex]::Matches($new,'서해구')).Count
  Write-Output ("{0}  (BOM={1}, 서해구 {2}곳)" -f $path,$hasBom,$cnt)
}

# 1) 인천 서구 페이지 3개: 전면 치환
foreach($p in 'region/incheon-seogu.html','region/incheon-seogu-tableorder.html','region/incheon-seogu-vending.html'){
  Edit-Keep $p { param($t) $t.Replace('인천 서구','인천 서해구') }
}

# 2) regions.html: 인천 링크 3개만 (다른 도시 서구는 유지)
Edit-Keep 'regions.html' { param($t)
  $t = $t.Replace('incheon-seogu.html">서구 포스기·카드단말기','incheon-seogu.html">서해구 포스기·카드단말기')
  $t = $t.Replace('incheon-seogu-tableorder.html">서구 테이블오더','incheon-seogu-tableorder.html">서해구 테이블오더')
  $t = $t.Replace('incheon-seogu-vending.html">서구 무인자판기','incheon-seogu-vending.html">서해구 무인자판기')
  return $t
}

# 3) 블로그 글 + 목록 카드
foreach($p in 'blog/2026-07-05-geomdan.html','blog-8.html'){
  Edit-Keep $p { param($t) $t.Replace('인천 서구','인천 서해구') }
}

Write-Output '완료'
