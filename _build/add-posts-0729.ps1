# 2026-07-29 후기 3편(김해 포스기·평택 카드단말기·김포 자판기)을 목록 맨 앞에 추가 + 사이트맵. 라이브 형식 보존, 카운트 정규식.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$enc=New-Object System.Text.UTF8Encoding($false)

$new=@(
 @{f='blog/2026-07-29-gimpo-vending.html'; img='photos/vend-songdo.jpg'; alt='김포 사무실 건물 직원용 무인자판기 설치 - H포스'; label='김포 자판기'; h='김포 무인자판기 설치 완료 — 사무실 건물 직원용 자판기'; p='경기 김포 사무실 건물 로비에 음료·스넥·간식 무인자판기를 설치했습니다. 셀프 결제·앱 원격관리로 24시간 무인 운영, 상주 인원 많은 건물이라 고정 수요가 확실한 자리.'}
 @{f='blog/2026-07-29-pyeongtaek-card.html'; img='photos/pos-install-10.jpg'; alt='평택 비전동 미용실 카드단말기 설치 - H포스'; label='평택 카드단말기'; h='평택 카드단말기 설치 완료 — 비전동 미용실 결제 세팅'; p='경기 평택 비전동 미용실에 유선 카드단말기를 새로 설치했습니다. 기존 가맹 그대로 이어받아 번호 유지, 삼성페이·카카오페이·QR까지 다시 세팅. 오래된 단말기 교체도 설치비 무료.'}
 @{f='blog/2026-07-29-gimhae-pos.html'; img='photos/pos-install-35.jpg'; alt='김해 장유 음식점 포스기·카드단말기 설치 - H포스'; label='김해 포스기'; h='김해 포스기·카드단말기 설치 완료 — 장유 음식점 결제 구축'; p='경남 김해 장유 음식점에 포스기와 카드단말기를 한 번에 설치했습니다. 메뉴·테이블을 포스에 등록하고 카드·간편결제·QR까지 연동해 계산 실수를 줄였습니다.'}
)
$newCards=@()
foreach($n in $new){
  $newCards += @"
<a class="post-card" href="$($n.f)">
      <img src="$($n.img)" alt="$($n.alt)" loading="lazy" decoding="async">
      <div class="pc-body">
        <div class="pc-date">2026.07.29 · $($n.label)</div>
        <h2>$($n.h)</h2>
        <p>$($n.p)</p>
      </div>
    </a>
"@
}

$tpl=Get-Content (Join-Path $repo 'blog.html') -Raw -Encoding UTF8
$tpl=[regex]::Replace($tpl,'(?s)<nav class="pager">.*?</nav>','{{PAGER}}')
$tpl=[regex]::Replace($tpl,'(?s)(<div class="posts">\r?\n).*?(\r?\n  </div>)','${1}{{CARDS}}${2}')
$tpl=[regex]::Replace($tpl,'설치 후기 \(\d+/\d+\)','설치 후기 ({{N}}/{{TP}})')
$tpl=[regex]::Replace($tpl,'전체\s*\d+\s*건\s+\S{1,3}\s+\d+/\d+\s*페이지','전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지')
$tpl=$tpl.Replace('https://hpos.co.kr/blog.html','https://hpos.co.kr/{{CANON}}')

$existing=@()
$pglist=@('blog.html'); $pn=2
while(Test-Path (Join-Path $repo "blog-$pn.html")){ $pglist+="blog-$pn.html"; $pn++ }
foreach($pg in $pglist){
  $t=Get-Content (Join-Path $repo $pg) -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($t,'(?s)<a class="post-card".*?</a>')){ $existing+=$m.Value }
}
$all=@($newCards)+@($existing)
$per=10; $total=$all.Count; $tp=[math]::Ceiling($total/$per)

function Get-File($i){ if($i -eq 1){'blog.html'}else{"blog-$i.html"} }
function Build-Pager($i,$tp){
  $s='<nav class="pager">'
  if($i -eq 1){ $s+='<span class="dis">← 이전</span>' } else { $s+='<a href="'+(Get-File ($i-1))+'">← 이전</a>' }
  for($j=1;$j -le $tp;$j++){ if($j -eq $i){ $s+='<span class="cur">'+$j+'</span>' } else { $s+='<a href="'+(Get-File $j)+'">'+$j+'</a>' } }
  if($i -eq $tp){ $s+='<span class="dis">다음 →</span>' } else { $s+='<a href="'+(Get-File ($i+1))+'">다음 →</a>' }
  $s+='</nav>'; return $s
}

for($i=1;$i -le $tp;$i++){
  $start=($i-1)*$per; $end=[math]::Min($i*$per,$total)-1
  $chunk=$all[$start..$end]
  $cardsHtml=($chunk | ForEach-Object { '    '+$_ }) -join "`n`n"
  $canon=Get-File $i
  $page=$tpl.Replace('{{CANON}}',$canon).Replace('{{N}}',"$i").Replace('{{TP}}',"$tp").Replace('{{TOTAL}}',"$total").Replace('{{CARDS}}',$cardsHtml).Replace('{{PAGER}}',(Build-Pager $i $tp))
  [System.IO.File]::WriteAllText((Join-Path $repo $canon),$page,$enc)
}
for($k=$tp+1;$k -le 40;$k++){ $extra=Join-Path $repo "blog-$k.html"; if(Test-Path $extra){ Remove-Item $extra } }

$sp=Join-Path $repo 'sitemap.xml'
$sc=Get-Content $sp -Raw -Encoding UTF8
foreach($n in $new){
  if($sc -notmatch [regex]::Escape($n.f)){
    $line='  <url><loc>https://hpos.co.kr/'+$n.f+'</loc><lastmod>2026-07-29</lastmod><changefreq>monthly</changefreq><priority>0.7</priority></url>'
    $sc=$sc.Replace('</urlset>',$line+"`n"+'</urlset>')
  }
}
[System.IO.File]::WriteAllText($sp,$sc,$enc)

Write-Output ("완료 - 총 "+$total+"편 / "+$tp+"페이지, 신규 3편 추가 + sitemap")
