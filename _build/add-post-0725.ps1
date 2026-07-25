# 2026-07-25 포스기 구매/임대/렌탈 가이드 글을 목록 맨 앞에 추가 + 사이트맵. 라이브 형식 보존.
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$enc=New-Object System.Text.UTF8Encoding($false)

$card=@'
<a class="post-card" href="blog/2026-07-25-pos-rental-vs-purchase-guide.html">
      <img src="photos/pos-install-08.jpg" alt="포스기·카드단말기 구매 임대 렌탈 차이와 위약금 주의 - H포스" loading="lazy" decoding="async">
      <div class="pc-body">
        <div class="pc-date">2026.07.25 · 포스기 가이드</div>
        <h2>포스기 설치 임대·렌탈과 구매 차이점? 위약금 주의사항까지 총정리</h2>
        <p>오픈 사장님이 가장 많이 묻는 포스기·카드단말기 구매·임대·렌탈 차이와 위약금 함정, 업종별 추천 구성까지. 유선·무선·이동식·휴대용 카드단말기 고르는 법도 정리했습니다.</p>
      </div>
    </a>
'@
$card=$card.Trim()

# 현재 blog.html 을 템플릿으로
$tpl=Get-Content (Join-Path $repo 'blog.html') -Raw -Encoding UTF8
$curTp=[regex]::Match($tpl,'설치 후기 \(1/(\d+)\)').Groups[1].Value
$curTotal=[regex]::Match($tpl,'전체 (\d+)건').Groups[1].Value
$tpl=[regex]::Replace($tpl,'(?s)<nav class="pager">.*?</nav>','{{PAGER}}')
$tpl=[regex]::Replace($tpl,'(?s)(<div class="posts">\r?\n).*?(\r?\n  </div>)','${1}{{CARDS}}${2}')
$tpl=$tpl.Replace("설치 후기 (1/$curTp)",'설치 후기 ({{N}}/{{TP}})')
$tpl=$tpl.Replace("전체 $curTotal건 · 1/$curTp 페이지",'전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지')
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
$rel='blog/2026-07-25-pos-rental-vs-purchase-guide.html'
if($sc -notmatch [regex]::Escape($rel)){
  $line='  <url><loc>https://hpos.co.kr/'+$rel+'</loc><lastmod>2026-07-25</lastmod><changefreq>monthly</changefreq><priority>0.8</priority></url>'
  $sc=$sc.Replace('</urlset>',$line+"`n"+'</urlset>')
  [System.IO.File]::WriteAllText($sp,$sc,$enc)
}
Write-Output ("완료 - 총 "+$total+"편 / "+$tp+"페이지, 포스기 가이드 맨 앞 추가 + sitemap")
