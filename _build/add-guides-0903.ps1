# 2026-09-03 가이드 2편 목록 반영 + 페이지 재정리 + sitemap 갱신
# 글 본문(blog\*.html)은 이미 작성되어 있고, 이 스크립트는 목록/사이트맵만 손봅니다.
# BOM 포함 UTF-8로 저장해야 실행됨
$ErrorActionPreference='Stop'
$repo = Split-Path -Parent $PSScriptRoot
$enc  = New-Object System.Text.UTF8Encoding($false)
$dateDot='2026.09.03'; $dateIso='2026-09-03'

# 맨 앞이 최신. 위에서부터 목록 상단에 붙습니다.
$posts=@(
 @{ slug='2026-09-03-vending-profit-electricity-guide'; img='post-0903-vend1.jpg'; cat='무인자판기 가이드';
    title='무인자판기 수익 계산 — 전기세·원가 다 빼면 한 대당 얼마 남을까';
    alt='무인자판기 수익 계산 — 전기요금·원가 빼고 남는 돈';
    sum='자리별 월 매출 범위, 기종별 전기요금, 매출 100만원 자판기의 비용 계산, 장소 제공형 수수료 구조, 부업으로 할 때 현실적인 손익까지.' },
 @{ slug='2026-09-03-card-terminal-documents-guide'; img='post-0903-card1.jpg'; cat='카드단말기 가이드';
    title='신용카드단말기 신청 필요서류 총정리 — 개인·법인·업종별 준비물';
    alt='신용카드단말기 신청 필요서류 — 개인·법인·업종별 준비물';
    sum='개인사업자 기본 3종, 법인 추가 서류, 업종별 신고증·허가증, 간이과세자·신규창업 무실적 가맹, 접수부터 설치까지 걸리는 기간.' }
)

$pageTpl=@'
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" href="favicon.svg" type="image/svg+xml" />
<link rel="canonical" href="https://hpos.co.kr/{{CANON}}" />
<meta name="robots" content="index, follow, max-image-preview:large" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="H포스" />
<meta property="og:title" content="설치 후기 ({{N}}/{{TP}}) — H포스 전국 카드단말기·포스기 설치" />
<meta property="og:description" content="H포스의 실제 설치 현장 후기. 전국 카드단말기·포스기·키오스크·무인자판기 설치 사례를 기록합니다." />
<meta property="og:image" content="https://hpos.co.kr/og-image.png" />
<meta property="og:url" content="https://hpos.co.kr/{{CANON}}" />
<meta name="twitter:card" content="summary_large_image" />
<title>설치 후기 ({{N}}/{{TP}}) — H포스 전국 카드단말기·포스기 설치</title>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin />
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable-dynamic-subset.min.css" />
<link rel="stylesheet" href="blog.css" />
</head>
<body>
<header class="bnav"><div class="bnav-inner"><a href="index.html" class="logo">H포스</a><a href="index.html" class="home">← 홈으로</a></div></header>
<div class="bwrap">
  <div class="bhead">
    <h1>설치 후기</h1>
    <p>H포스가 직접 설치한 전국 카드단말기·포스기·키오스크·무인자판기 현장 기록입니다. (전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지)</p>
  </div>
  <div class="posts">
{{CARDS}}
  </div>
  {{PAGER}}
</div>
<div class="bfoot"><a href="regions.html" style="color:#16C784;font-weight:700">전국 설치 지역</a> · © 2026 H포스 · 전국 카드단말기·포스기·키오스크·무인자판기 설치 · 📞 010-6832-1994</div>
</body>
</html>
'@

function Get-File($i){ if($i -eq 1){'blog.html'}else{"blog-$i.html"} }
function Build-Pager($i,$tp){
  $s='<nav class="pager">'
  if($i -eq 1){ $s+='<span class="dis">← 이전</span>' } else { $s+='<a href="'+(Get-File ($i-1))+'">← 이전</a>' }
  for($j=1;$j -le $tp;$j++){ if($j -eq $i){ $s+='<span class="cur">'+$j+'</span>' } else { $s+='<a href="'+(Get-File $j)+'">'+$j+'</a>' } }
  if($i -eq $tp){ $s+='<span class="dis">다음 →</span>' } else { $s+='<a href="'+(Get-File ($i+1))+'">다음 →</a>' }
  $s+='</nav>'; return $s
}

# 1) 새 카드 만들기 (본문 파일이 실제로 있는지 확인)
$newCards=@()
foreach($p in $posts){
  $f=Join-Path $repo ('blog\'+$p.slug+'.html')
  if(-not (Test-Path $f)){ throw ('본문 파일이 없습니다: '+$f) }
  $c='<a class="post-card" href="blog/'+$p.slug+'.html">'+"`n"
  $c+='      <img src="photos/'+$p.img+'" alt="'+$p.alt+'" loading="lazy" decoding="async">'+"`n"
  $c+='      <div class="pc-body">'+"`n"
  $c+='        <div class="pc-date">'+$dateDot+' · '+$p.cat+'</div>'+"`n"
  $c+='        <h2>'+$p.title+'</h2>'+"`n"
  $c+='        <p>'+$p.sum+'</p>'+"`n"
  $c+='      </div>'+"`n"
  $c+='    </a>'
  $newCards+=$c
}

# 2) 기존 카드 추출 (목록 페이지 자동 탐색, 최신순 유지)
$existing=@()
$pglist=@('blog.html'); $pn=2
while(Test-Path (Join-Path $repo "blog-$pn.html")){ $pglist+="blog-$pn.html"; $pn++ }
foreach($pg in $pglist){
  $t=Get-Content (Join-Path $repo $pg) -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($t,'(?s)<a class="post-card".*?</a>')){ $existing+=$m.Value }
}

# 이미 목록에 있으면 중복 추가 방지 (스크립트 재실행 대비)
foreach($p in $posts){
  if($existing -match [regex]::Escape('blog/'+$p.slug+'.html')){ throw ('이미 목록에 있는 글입니다: '+$p.slug) }
}

$all=@($newCards)+@($existing)
$per=10; $total=$all.Count; $tp=[math]::Ceiling($total/$per)

# 3) 목록 페이지 재작성 (예전보다 페이지 수가 줄면 남는 파일 삭제)
for($i=1;$i -le $tp;$i++){
  $start=($i-1)*$per; $end=[math]::Min($i*$per,$total)-1
  $chunk=$all[$start..$end]
  $cardsHtml=($chunk | ForEach-Object { '    '+$_ }) -join "`n`n"
  $canon=Get-File $i
  $pager=Build-Pager $i $tp
  $page=$pageTpl.Replace('{{CANON}}',$canon).Replace('{{N}}',"$i").Replace('{{TP}}',"$tp").Replace('{{TOTAL}}',"$total").Replace('{{CARDS}}',$cardsHtml).Replace('{{PAGER}}',$pager)
  [System.IO.File]::WriteAllText((Join-Path $repo $canon),$page,$enc)
}
$k=$tp+1
while(Test-Path (Join-Path $repo "blog-$k.html")){ Remove-Item (Join-Path $repo "blog-$k.html"); $k++ }

# 4) sitemap 갱신 — 새 글 추가 + 목록 페이지 lastmod 갱신
$sp=Join-Path $repo 'sitemap.xml'
$sc=Get-Content $sp -Raw -Encoding UTF8
$slines=foreach($p in $posts){ '  <url><loc>https://hpos.co.kr/blog/'+$p.slug+'.html</loc><lastmod>'+$dateIso+'</lastmod><changefreq>monthly</changefreq><priority>0.8</priority></url>' }
$sc=$sc.Replace('</urlset>',(($slines -join "`n")+"`n"+'</urlset>'))
$sc=[regex]::Replace($sc,'(<loc>https://hpos\.co\.kr/blog(-\d+)?\.html</loc><lastmod>)\d{4}-\d{2}-\d{2}(</lastmod>)',('${1}'+$dateIso+'${3}'))
[System.IO.File]::WriteAllText($sp,$sc,$enc)

Write-Output ("새 글 목록 반영: "+$posts.Count+"편")
Write-Output ("총 후기: "+$total+"편 / 목록 페이지: "+$tp+"개")
