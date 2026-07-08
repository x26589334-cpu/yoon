# 설치 후기(블로그) 발행 + 목록 재정리 + sitemap 갱신
# BOM 포함 UTF-8로 저장해야 실행됨
$ErrorActionPreference='Stop'
$repo="$env:USERPROFILE\Desktop\yoon"
$enc=New-Object System.Text.UTF8Encoding($false)
$dateDot='2026.07.06'; $dateIso='2026-07-06'

$posts=@(
 @{slug='2026-07-06-gangseo';   city='강서';   region='서울 강서구'; tail='마곡·화곡 상권 결제 구축'; img='pos-install-16.jpg'; sang='마곡 첨단단지 상권과 화곡·등촌 생활권'; dongs='화곡동, 등촌동, 가양동, 마곡동, 염창동'},
 @{slug='2026-07-06-gwanak';    city='관악';   region='서울 관악구'; tail='신림·봉천 상권 결제 세팅'; img='pos-install-18.jpg'; sang='서울대입구 상권과 신림·봉천 생활권'; dongs='봉천동, 신림동, 남현동, 서원동, 청룡동'},
 @{slug='2026-07-06-guro';      city='구로';   region='서울 구로구'; tail='신도림·구로디지털 상권 결제 구축'; img='pos-install-20.jpg'; sang='신도림 상권과 구로디지털단지 생활권'; dongs='구로동, 신도림동, 개봉동, 고척동, 오류동'},
 @{slug='2026-07-06-dongjak';   city='동작';   region='서울 동작구'; tail='사당·노량진 상권 결제 세팅'; img='pos-install-23.jpg'; sang='노량진 상권과 사당·상도 생활권'; dongs='노량진동, 상도동, 사당동, 대방동, 흑석동'},
 @{slug='2026-07-06-seongdong'; city='성동';   region='서울 성동구'; tail='성수·왕십리 상권 결제 구축'; img='pos-install-26.jpg'; sang='성수동 카페 상권과 왕십리 생활권'; dongs='성수동, 왕십리동, 행당동, 금호동, 옥수동'}
)

$postTpl=@'
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link rel="icon" href="../favicon.svg" type="image/svg+xml" />
<link rel="canonical" href="https://hpos.co.kr/blog/{{SLUG}}.html" />
<meta name="robots" content="index, follow, max-image-preview:large" />
<meta property="og:type" content="article" />
<meta property="og:site_name" content="H포스" />
<meta property="og:title" content="{{TITLE}}" />
<meta property="og:description" content="{{OGDESC}}" />
<meta property="og:image" content="https://hpos.co.kr/photos/{{IMG}}" />
<meta property="og:url" content="https://hpos.co.kr/blog/{{SLUG}}.html" />
<meta name="twitter:card" content="summary_large_image" />
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BlogPosting","headline":"{{TITLE}}","image":"https://hpos.co.kr/photos/{{IMG}}","datePublished":"{{DATEISO}}","dateModified":"{{DATEISO}}","author":{"@type":"Organization","name":"H포스"},"publisher":{"@type":"Organization","name":"H포스","logo":{"@type":"ImageObject","url":"https://hpos.co.kr/og-image.png"}},"mainEntityOfPage":"https://hpos.co.kr/blog/{{SLUG}}.html","description":"{{OGDESC}}"}
</script>
<title>{{CITY}} 카드단말기·포스기 설치 후기 — H포스</title>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin />
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="../blog.css" />
</head>
<body>
<header class="bnav"><div class="bnav-inner"><a href="../index.html" class="logo">H포스</a><a href="../blog.html" class="home">← 목록</a></div></header>
<div class="bwrap">
  <article class="post">
    <div class="pc-date">{{DATEDOT}} · {{REGION}}</div>
    <h1>{{TITLE}}</h1>
    <img src="../photos/{{IMG}}" alt="{{ALT}}" />
    <p>오늘은 {{REGION}}의 한 매장에 카드단말기를 설치했습니다. {{SANG}} 등 매장이 밀집한 지역이라 안정적인 결제 환경이 중요합니다. 이번 매장도 모든 카드와 간편결제를 한 대로 받도록 구성했습니다.</p>
    <p>H포스는 매장 환경에 맞춰 <b>무선 카드단말기, 유선 카드단말기, 블루투스 카드단말기, 카드결제기, 포스기(POS)</b>를 골라 설치하고 관리해 드립니다. 고정 카운터에는 유선 단말기, 이동이 잦은 매장에는 무선·휴대 단말기, 태블릿·포스 연동에는 블루투스 단말기까지 모두 지원합니다.</p>
    <p><b>{{CITY}} 서비스 지역</b> — {{DONGS}}까지 {{CITY}} 전역 동 단위로 방문 설치합니다.</p>
    <p><b>카드단말기·포스기가 필요한 업종</b> — ① 음식점·식당 ② 카페·디저트 ③ 편의점·마트 ④ 미용실·네일샵 ⑤ 학원·교습소 ⑥ 병원·약국 ⑦ 헬스장·필라테스 ⑧ 노래방·PC방 ⑨ 무인매장·키오스크 창업 ⑩ 펜션·숙박 등 결제가 발생하는 모든 업종에 업종별 맞춤으로 설치해 드립니다.</p>
    <p>H포스는 {{CITY}} 지역을 비롯한 <b>전국</b>에 <b>설치비 무료, 평균 4일 이내 방문 설치</b>로 진행합니다. 신규 창업 매장은 물론 기존 단말기 교체, 모든 카드사 일괄 가맹까지 한 번에 도와드립니다.</p>
    <p>{{CITY}} 카드단말기·포스기 설치가 필요하시면 편하게 전화 주세요. 매장 업종과 규모에 맞는 구성을 무료로 상담해 드립니다.</p>
    <a class="cta" href="tel:01068321994">📞 설치 상담 010-6832-1994</a>
  </article>
</div>
<div class="bfoot">© 2026 H포스 · 전국 카드단말기·포스기·키오스크 설치</div>
</body>
</html>
'@

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
<meta property="og:description" content="H포스의 실제 설치 현장 후기. 전국 카드단말기·포스기·키오스크 설치 사례를 기록합니다." />
<meta property="og:image" content="https://hpos.co.kr/og-image.png" />
<meta property="og:url" content="https://hpos.co.kr/{{CANON}}" />
<meta name="twitter:card" content="summary_large_image" />
<title>설치 후기 ({{N}}/{{TP}}) — H포스 전국 카드단말기·포스기 설치</title>
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin />
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
<link rel="stylesheet" href="blog.css" />
</head>
<body>
<header class="bnav"><div class="bnav-inner"><a href="index.html" class="logo">H포스</a><a href="index.html" class="home">← 홈으로</a></div></header>
<div class="bwrap">
  <div class="bhead">
    <h1>설치 후기</h1>
    <p>H포스가 직접 설치한 전국 카드단말기·포스기·키오스크 현장 기록입니다. (전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지)</p>
  </div>
  <div class="posts">
{{CARDS}}
  </div>
  {{PAGER}}
</div>
<div class="bfoot">© 2026 H포스 · 전국 카드단말기·포스기·키오스크 설치 · 📞 010-6832-1994</div>
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

# 1) 새 후기 글 5편 생성
foreach($p in $posts){
  $title=$p.city+' 카드단말기 설치 완료 — '+$p.tail
  $ogdesc=$p.region+' 카드단말기·포스기 설치 현장 후기. 무선·유선·블루투스 카드결제기까지 설치비 무료, 평균 4일 이내 방문 설치.'
  $alt=$p.city+' 카드단말기·포스기 설치 현장 - H포스'
  $out=$postTpl.Replace('{{SLUG}}',$p.slug).Replace('{{TITLE}}',$title).Replace('{{OGDESC}}',$ogdesc).Replace('{{IMG}}',$p.img).Replace('{{DATEDOT}}',$dateDot).Replace('{{DATEISO}}',$dateIso).Replace('{{REGION}}',$p.region).Replace('{{CITY}}',$p.city).Replace('{{SANG}}',$p.sang).Replace('{{DONGS}}',$p.dongs).Replace('{{ALT}}',$alt)
  [System.IO.File]::WriteAllText((Join-Path $repo ('blog\'+$p.slug+'.html')),$out,$enc)
}

# 2) 새 카드 5개 만들기 (맨 앞 = 최신)
$newCards=@()
foreach($p in $posts){
  $title=$p.city+' 카드단말기 설치 완료 — '+$p.tail
  $summary=$p.region+' 매장에 설치 완료. 무선·유선·블루투스 카드결제기까지, 설치비 무료·평균 4일 이내 방문 설치.'
  $c='<a class="post-card" href="blog/'+$p.slug+'.html">'+"`n"
  $c+='      <img src="photos/'+$p.img+'" alt="'+$title+'" loading="lazy">'+"`n"
  $c+='      <div class="pc-body">'+"`n"
  $c+='        <div class="pc-date">'+$dateDot+' · '+$p.region+'</div>'+"`n"
  $c+='        <h2>'+$title+'</h2>'+"`n"
  $c+='        <p>'+$summary+'</p>'+"`n"
  $c+='      </div>'+"`n"
  $c+='    </a>'
  $newCards+=$c
}

# 3) 기존 카드 그대로 추출 (모든 목록 페이지 자동 탐색, 최신순)
$existing=@()
$pglist=@('blog.html'); $pn=2
while(Test-Path (Join-Path $repo "blog-$pn.html")){ $pglist+="blog-$pn.html"; $pn++ }
foreach($pg in $pglist){
  $t=Get-Content (Join-Path $repo $pg) -Raw -Encoding UTF8
  foreach($m in [regex]::Matches($t,'(?s)<a class="post-card".*?</a>')){ $existing+=$m.Value }
}

$all=@($newCards)+@($existing)
$per=10; $total=$all.Count; $tp=[math]::Ceiling($total/$per)

# 4) 목록 페이지 재작성
for($i=1;$i -le $tp;$i++){
  $start=($i-1)*$per; $end=[math]::Min($i*$per,$total)-1
  $chunk=$all[$start..$end]
  $cardsHtml=($chunk | ForEach-Object { '    '+$_ }) -join "`n`n"
  $canon=Get-File $i
  $pager=Build-Pager $i $tp
  $page=$pageTpl.Replace('{{CANON}}',$canon).Replace('{{N}}',"$i").Replace('{{TP}}',"$tp").Replace('{{TOTAL}}',"$total").Replace('{{CARDS}}',$cardsHtml).Replace('{{PAGER}}',$pager)
  [System.IO.File]::WriteAllText((Join-Path $repo $canon),$page,$enc)
}

# 5) sitemap 갱신
$sp=Join-Path $repo 'sitemap.xml'
$sc=Get-Content $sp -Raw -Encoding UTF8
$slines=foreach($p in $posts){ '  <url><loc>https://hpos.co.kr/blog/'+$p.slug+'.html</loc><lastmod>'+$dateIso+'</lastmod><changefreq>monthly</changefreq><priority>0.7</priority></url>' }
$sc=$sc.Replace('</urlset>',(($slines -join "`n")+"`n"+'</urlset>'))
[System.IO.File]::WriteAllText($sp,$sc,$enc)

Write-Output ("새 후기 발행: "+$posts.Count+"편")
Write-Output ("총 후기: "+$total+"편 / 목록 페이지: "+$tp+"개")
Write-Output ("sitemap에 추가: "+$posts.Count+"개 URL")
