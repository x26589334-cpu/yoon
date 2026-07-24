# 2026-07-24 신규 후기 4편(포스기2·자판기2)을 목록 맨 앞에 추가 + 사이트맵 갱신. 라이브 목록 형식 보존.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$enc=New-Object System.Text.UTF8Encoding($false)

# 신규 카드 정의 (목록에 표시될 순서: 맨 위부터)
$new=@(
 @{f='blog/2026-07-24-hwaseong-vending.html'; img='photos/vend-hwaseong.jpg'; alt='화성 동탄 무인 아이스크림 매장 냉동자판기 설치 - H포스'; label='화성 자판기'; h='화성 무인자판기 설치 완료 — 동탄 무인 아이스크림 매장 냉동자판기'; p='경기 화성 동탄 무인 아이스크림 매장에 냉동자판기를 설치했습니다. 아이스크림·냉동식품·밀키트 자판기와 셀프 결제까지 24시간 무인점포로 세팅.'}
 @{f='blog/2026-07-24-wonju-vending.html'; img='photos/vend-wonju.jpg'; alt='원주 아파트 단지 상가 무인자판기 설치 - H포스'; label='원주 자판기'; h='원주 무인자판기 설치 완료 — 아파트 단지 무인점포 자판기'; p='강원 원주 아파트 단지 상가에 음료·스넥·냉동 무인자판기를 설치했습니다. 셀프 결제·앱 원격관리로 24시간 무인 운영, 야간·주말 수요가 확실한 자리.'}
 @{f='blog/2026-07-24-cheonan-pos.html'; img='photos/pos-install-32.jpg'; alt='천안 불당동 고깃집 포스기·카드단말기 설치 - H포스'; label='천안 포스기'; h='천안 포스기(POS) 설치 완료 — 불당동 고깃집 결제 구축'; p='충남 천안 불당동 고깃집에 포스기와 카드단말기를 설치했습니다. 홀 회전이 빠른 매장에 포스+무선 단말기, 간편결제·QR·분할결제까지 구축.'}
 @{f='blog/2026-07-24-anyang-pos.html'; img='photos/pos-install-31.jpg'; alt='안양 평촌 카페 포스기·카드단말기 설치 - H포스'; label='안양 포스기'; h='안양 포스기·카드단말기 설치 완료 — 평촌 카페에 포스+단말기 세팅'; p='경기 안양 평촌 카페에 포스기와 카드단말기를 한 번에 설치했습니다. 메뉴·옵션을 포스에 등록하고 카드·간편결제·QR까지 연동해 계산 실수를 줄였습니다.'}
)
$newCards=@()
foreach($n in $new){
  $newCards += @"
<a class="post-card" href="$($n.f)">
      <img src="$($n.img)" alt="$($n.alt)" loading="lazy" decoding="async">
      <div class="pc-body">
        <div class="pc-date">2026.07.24 · $($n.label)</div>
        <h2>$($n.h)</h2>
        <p>$($n.p)</p>
      </div>
    </a>
"@
}

# 라이브 blog.html 을 템플릿으로 (푸터 등 그대로 보존)
$tpl=Get-Content (Join-Path $repo 'blog.html') -Raw -Encoding UTF8
$tpl=[regex]::Replace($tpl,'(?s)<nav class="pager">.*?</nav>','{{PAGER}}')
$tpl=[regex]::Replace($tpl,'(?s)(<div class="posts">\r?\n).*?(\r?\n  </div>)','${1}{{CARDS}}${2}')
$tpl=$tpl.Replace('설치 후기 (1/15)','설치 후기 ({{N}}/{{TP}})')
$tpl=$tpl.Replace('전체 143건 · 1/15 페이지','전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지')
$tpl=$tpl.Replace('https://hpos.co.kr/blog.html','https://hpos.co.kr/{{CANON}}')

# 기존 카드 전부 추출 (모든 목록 페이지, 순서 유지)
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

# 목록 페이지 재작성
for($i=1;$i -le $tp;$i++){
  $start=($i-1)*$per; $end=[math]::Min($i*$per,$total)-1
  $chunk=$all[$start..$end]
  $cardsHtml=($chunk | ForEach-Object { '    '+$_ }) -join "`n`n"
  $canon=Get-File $i
  $page=$tpl.Replace('{{CANON}}',$canon).Replace('{{N}}',"$i").Replace('{{TP}}',"$tp").Replace('{{TOTAL}}',"$total").Replace('{{CARDS}}',$cardsHtml).Replace('{{PAGER}}',(Build-Pager $i $tp))
  [System.IO.File]::WriteAllText((Join-Path $repo $canon),$page,$enc)
}

# 남는 목록 페이지 파일이 있으면(총 페이지 줄었을때) 정리 — 여기선 동일하지만 안전차원
for($k=$tp+1;$k -le 30;$k++){ $extra=Join-Path $repo "blog-$k.html"; if(Test-Path $extra){ Remove-Item $extra } }

# 사이트맵 추가
$sp=Join-Path $repo 'sitemap.xml'
$sc=Get-Content $sp -Raw -Encoding UTF8
foreach($n in $new){
  $url='https://hpos.co.kr/'+$n.f
  if($sc -notmatch [regex]::Escape($n.f)){
    $line='  <url><loc>'+$url+'</loc><lastmod>2026-07-24</lastmod><changefreq>monthly</changefreq><priority>0.7</priority></url>'
    $sc=$sc.Replace('</urlset>',$line+"`n"+'</urlset>')
  }
}
[System.IO.File]::WriteAllText($sp,$sc,$enc)

Write-Output ("완료 - 총 "+$total+"편 / "+$tp+"페이지, 신규 4편 맨 앞 추가 + sitemap 갱신")
