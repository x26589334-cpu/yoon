# 냉동자판기 가이드 글을 블로그 목록 맨 앞에 추가 + 사이트맵 갱신 (현재 라이브 목록 형식 보존). BOM 필요.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$enc=New-Object System.Text.UTF8Encoding($false)

# 1) 현재 라이브 blog.html 을 템플릿으로 (푸터 등 그대로 보존)
$tpl=Get-Content (Join-Path $repo 'blog.html') -Raw -Encoding UTF8
$tpl=[regex]::Replace($tpl,'(?s)<nav class="pager">.*?</nav>','{{PAGER}}')
$tpl=[regex]::Replace($tpl,'(?s)(<div class="posts">\r?\n).*?(\r?\n  </div>)','${1}{{CARDS}}${2}')
$tpl=$tpl.Replace('설치 후기 (1/14)','설치 후기 ({{N}}/{{TP}})')
$tpl=$tpl.Replace('전체 139건 · 1/14 페이지','전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지')
$tpl=$tpl.Replace('https://hpos.co.kr/blog.html','https://hpos.co.kr/{{CANON}}')

# 2) 가이드 카드
$guideCard=@'
<a class="post-card" href="blog/2026-07-19-frozen-vending-cafe-guide.html">
      <img src="photos/frozen-vending-1.png" alt="무인카페·무인 아이스크림 매장 창업 준비 방법 — 냉동자판기 완전정리" loading="lazy" decoding="async">
      <div class="pc-body">
        <div class="pc-date">2026.07.19 · 무인창업 가이드</div>
        <h2>무인카페·무인 아이스크림 매장 창업 준비 방법 — 냉동자판기 완전정리</h2>
        <p>무인카페·무인 아이스크림 매장 창업 준비 방법을 냉동자판기 사진으로 정리했습니다. 아이스크림·밀키트·냉동식품 자판기 종류와 고르는 법, 입지·결제·운영·구매/임대/렌탈까지.</p>
      </div>
    </a>
'@
$guideCard=$guideCard.Trim()

# 3) 기존 카드 전부 추출 (모든 목록 페이지, 최신순)
$existing=@()
$pglist=@('blog.html'); $pn=2
while(Test-Path (Join-Path $repo "blog-$pn.html")){ $pglist+="blog-$pn.html"; $pn++ }
foreach($pg in $pglist){
  $t=Get-Content (Join-Path $repo $pg) -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($t,'(?s)<a class="post-card".*?</a>')){ $existing+=$m.Value }
}
$all=@($guideCard)+@($existing)
$per=10; $total=$all.Count; $tp=[math]::Ceiling($total/$per)

function Get-File($i){ if($i -eq 1){'blog.html'}else{"blog-$i.html"} }
function Build-Pager($i,$tp){
  $s='<nav class="pager">'
  if($i -eq 1){ $s+='<span class="dis">← 이전</span>' } else { $s+='<a href="'+(Get-File ($i-1))+'">← 이전</a>' }
  for($j=1;$j -le $tp;$j++){ if($j -eq $i){ $s+='<span class="cur">'+$j+'</span>' } else { $s+='<a href="'+(Get-File $j)+'">'+$j+'</a>' } }
  if($i -eq $tp){ $s+='<span class="dis">다음 →</span>' } else { $s+='<a href="'+(Get-File ($i+1))+'">다음 →</a>' }
  $s+='</nav>'; return $s
}

# 4) 목록 페이지 재작성
for($i=1;$i -le $tp;$i++){
  $start=($i-1)*$per; $end=[math]::Min($i*$per,$total)-1
  $chunk=$all[$start..$end]
  $cardsHtml=($chunk | ForEach-Object { '    '+$_ }) -join "`n`n"
  $canon=Get-File $i
  $page=$tpl.Replace('{{CANON}}',$canon).Replace('{{N}}',"$i").Replace('{{TP}}',"$tp").Replace('{{TOTAL}}',"$total").Replace('{{CARDS}}',$cardsHtml).Replace('{{PAGER}}',(Build-Pager $i $tp))
  [System.IO.File]::WriteAllText((Join-Path $repo $canon),$page,$enc)
}

# 5) 사이트맵 추가
$sp=Join-Path $repo 'sitemap.xml'
$sc=Get-Content $sp -Raw -Encoding UTF8
if($sc -notmatch 'frozen-vending-cafe-guide'){
  $line='  <url><loc>https://hpos.co.kr/blog/2026-07-19-frozen-vending-cafe-guide.html</loc><lastmod>2026-07-19</lastmod><changefreq>monthly</changefreq><priority>0.8</priority></url>'
  $sc=$sc.Replace('</urlset>',$line+"`n"+'</urlset>')
  [System.IO.File]::WriteAllText($sp,$sc,$enc)
}
Write-Output ("완료 - 총 "+$total+"편 / "+$tp+"페이지, 가이드 글 맨 앞 추가 + sitemap 갱신")
