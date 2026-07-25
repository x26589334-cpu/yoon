# 모든 목록 페이지의 카운트 문구를 페이지별로 바로잡기 (구분자 문자 무관하게 정규식)
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$total=148; $tp=15
$pat='전체\s*\d+\s*건\s+\S{1,3}\s+\d+/\d+\s*페이지'
for($i=1;$i -le $tp;$i++){
  $rel = if($i -eq 1){'blog.html'}else{"blog-$i.html"}
  $full=Join-Path $repo $rel
  $b=[System.IO.File]::ReadAllBytes($full)
  $bom=($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF)
  $t=[System.Text.Encoding]::UTF8.GetString($b); if($bom){$t=$t.TrimStart([char]0xFEFF)}
  $rep="전체 $total건 · $i/$tp 페이지"
  $t=[regex]::Replace($t,$pat,$rep)
  [System.IO.File]::WriteAllText($full,$t,(New-Object System.Text.UTF8Encoding($bom)))
}
Write-Output "카운트 $tp개 페이지 수정 완료 (전체 $total건)"
