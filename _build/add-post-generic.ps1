# 새 글 카드 1개를 목록 맨 앞에 추가 + 사이트맵. 카운트/제목은 정규식으로 견고하게 토큰화.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$enc=New-Object System.Text.UTF8Encoding($false)

# ==== 이 글에 맞게 지정 ====
$rel='blog/2026-07-25-bluetooth-vs-mobile-card-terminal.html'
$img='photos/pos-install-50.jpg'
$alt='블루투스 카드단말기와 무선 이동식 카드단말기 차이 - H포스'
$label='카드단말기 가이드'
$h='블루투스 카드단말기와 무선 이동식 카드단말기 차이점?'
$summary='같은 무선이라도 블루투스 카드단말기는 스마트폰·태블릿에 붙여 쓰고, 무선 이동식(휴대용) 카드단말기는 통신이 내장돼 폰 없이 단독 결제됩니다. 어떤 상황에 어떤 걸 신청해야 하는지 정리했습니다.'
$lastmod='2026-07-25'
# =========================

$card=@"
<a class="post-card" href="$rel">
      <img src="$img" alt="$alt" loading="lazy" decoding="async">
      <div class="pc-body">
        <div class="pc-date">2026.07.25 · $label</div>
        <h2>$h</h2>
        <p>$summary</p>
      </div>
    </a>
"@
$card=$card.Trim()

# 템플릿(현재 blog.html) 토큰화
$tpl=Get-Content (Join-Path $repo 'blog.html') -Raw -Encoding UTF8
$tpl=[regex]::Replace($tpl,'(?s)<nav class="pager">.*?</nav>','{{PAGER}}')
$tpl=[regex]::Replace($tpl,'(?s)(<div class="posts">\r?\n).*?(\r?\n  </div>)','${1}{{CARDS}}${2}')
$tpl=[regex]::Replace($tpl,'설치 후기 \(\d+/\d+\)','설치 후기 ({{N}}/{{TP}})')
$tpl=[regex]::Replace($tpl,'전체\s*\d+\s*건\s+\S{1,3}\s+\d+/\d+\s*페이지','전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지')
$tpl=$tpl.Replace('https://hpos.co.kr/blog.html','https://hpos.co.kr/{{CANON}}')

# 기존 카드 추출
$existing=@()
$pglist=@('blog.html'); $pn=2
while(Test-Path (Join-Path $repo "blog-$pn.html")){ $pglist+="blog-$pn.html"; $pn++ }
foreach($pg in $pglist){
  $t=Get-Content (Join-Path $repo $pg) -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($t,'(?s)<a class="post-card".*?</a>')){ $existing+=$m.Value }
}
$all=@($card)+@($existing)
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

# 사이트맵
$sp=Join-Path $repo 'sitemap.xml'
$sc=Get-Content $sp -Raw -Encoding UTF8
if($sc -notmatch [regex]::Escape($rel)){
  $line='  <url><loc>https://hpos.co.kr/'+$rel+'</loc><lastmod>'+$lastmod+'</lastmod><changefreq>monthly</changefreq><priority>0.8</priority></url>'
  $sc=$sc.Replace('</urlset>',$line+"`n"+'</urlset>')
  [System.IO.File]::WriteAllText($sp,$sc,$enc)
}
Write-Output ("완료 - 총 "+$total+"편 / "+$tp+"페이지 (전체 카운트 정규식 처리)")
