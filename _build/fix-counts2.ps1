# 카운트 "전체  · N/15 페이지" -> "전체 148건 · N/15 페이지" (N/TP는 그대로 보존)
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$pat='전체\s+\S{1,3}\s+(\d+)/(\d+)\s+페이지'
$rep='전체 148건 · $1/$2 페이지'
for($i=1;$i -le 15;$i++){
  $rel = if($i -eq 1){'blog.html'}else{"blog-$i.html"}
  $full=Join-Path $repo $rel
  $b=[System.IO.File]::ReadAllBytes($full)
  $bom=($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)
  $t=[System.Text.Encoding]::UTF8.GetString($b); if($bom){$t=$t.TrimStart([char]0xFEFF)}
  $t=[regex]::Replace($t,$pat,$rep)
  [System.IO.File]::WriteAllText($full,$t,(New-Object System.Text.UTF8Encoding($bom)))
}
Write-Output ("done")
