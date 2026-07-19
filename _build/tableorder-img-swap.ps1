# 테이블오더 지역페이지: 히어로 이미지를 고화질 torder-intro로 교체 + 아래 중복 이미지 제거. BOM 필요.
$ErrorActionPreference='Stop'
$root="$env:USERPROFILE\Desktop\yoon\region"
$enc=New-Object System.Text.UTF8Encoding($false)
$n=0
foreach($f in Get-ChildItem "$root\*-tableorder.html"){
  $h=Get-Content $f.FullName -Raw -Encoding UTF8
  $orig=$h
  # 1) 히어로(위) 이미지를 고화질로 교체
  $h=$h.Replace('class="himg" src="../photos/table-order.jpg"','class="himg" src="../photos/torder-intro.jpg?v=0715"')
  # 2) 본문 아래 중복 이미지 블록 제거
  $h=$h.Replace('    <div class="tgrid"><img src="../photos/torder-intro.jpg?v=0715" alt="테이블오더 태블릿 - 자리에서 주문·결제 - H포스" loading="lazy" decoding="async" /></div>' + "`n",'')
  $h=$h.Replace('<div class="tgrid"><img src="../photos/torder-intro.jpg?v=0715" alt="테이블오더 태블릿 - 자리에서 주문·결제 - H포스" loading="lazy" decoding="async" /></div>','')
  if($h -ne $orig){ [System.IO.File]::WriteAllText($f.FullName,$h,$enc); $n++ }
}
Write-Output ("히어로 교체 + 중복 제거: "+$n+"개")
