# 블로그갱신.ps1 — 새 글 카드를 목록 맨 앞에 넣고 blog.html / blog-2.html … 을 다시 페이지 나누기 + sitemap 등록
#   (예전엔 날짜마다 add-posts-MMDD.ps1 을 새로 만들었음. 이제 이 파일 하나를 재사용한다.)
#   사용: powershell -NoProfile -ExecutionPolicy Bypass -File _build\블로그갱신.ps1 -New _build\new-posts.json
#   new-posts.json 형식(배열, UTF-8):
#   [ { "f": "blog/2026-09-15-suwon-vending.html", "img": "photos/vendreal-6.jpg", "alt": "…", "label": "수원 자판기",
#       "h": "수원 무인자판기 설치 완료 — 공장 휴게실", "p": "요약 두 문장", "date": "2026-09-15" } ]
#   ※ UTF-8 BOM 으로 저장 (PowerShell 5.1)
param([Parameter(Mandatory = $true)][string]$New, [int]$PerPage = 10)
$ErrorActionPreference = 'Stop'
$repo = Split-Path $PSScriptRoot -Parent
$enc  = New-Object System.Text.UTF8Encoding($false)
function Esc($s) { return ("$s" -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;' -replace '"', '&quot;') }

# PowerShell 5.1: 파이프로 ConvertFrom-Json 을 쓰면 배열이 한 덩어리로 넘어와 필드가 비는 버그가 있어 함수 호출형으로 읽는다
$parsed = ConvertFrom-Json ([IO.File]::ReadAllText((Resolve-Path $New), [Text.Encoding]::UTF8))
$posts = @($parsed)
if (-not $posts.Count) { throw '새 글이 없습니다.' }
foreach ($n in $posts) { if (-not (Test-Path (Join-Path $repo $n.f))) { throw "글 파일이 없습니다: $($n.f)" } }
$d = if ($posts[0].date) { [string]$posts[0].date } else { Get-Date -Format 'yyyy-MM-dd' }
$dDot = $d -replace '-', '.'

$newCards = @()
foreach ($n in $posts) {
  $nd = if ($n.date) { ([string]$n.date) -replace '-', '.' } else { $dDot }
  $newCards += @"
<a class="post-card" href="$($n.f)">
      <img src="$($n.img)" alt="$(Esc $n.alt)" loading="lazy" decoding="async">
      <div class="pc-body">
        <div class="pc-date">$nd · $(Esc $n.label)</div>
        <h2>$(Esc $n.h)</h2>
        <p>$(Esc $n.p)</p>
      </div>
    </a>
"@
}

$tpl = Get-Content (Join-Path $repo 'blog.html') -Raw -Encoding UTF8
$tpl = [regex]::Replace($tpl, '(?s)<nav class="pager">.*?</nav>', '{{PAGER}}')
$tpl = [regex]::Replace($tpl, '(?s)(<div class="posts">\r?\n).*?(\r?\n  </div>)', '${1}{{CARDS}}${2}')
$tpl = [regex]::Replace($tpl, '설치 후기 \(\d+/\d+\)', '설치 후기 ({{N}}/{{TP}})')
$tpl = [regex]::Replace($tpl, '전체\s*\d+\s*건\s+\S{1,3}\s+\d+/\d+\s*페이지', '전체 {{TOTAL}}건 · {{N}}/{{TP}} 페이지')
$tpl = $tpl.Replace('https://hpos.co.kr/blog.html', 'https://hpos.co.kr/{{CANON}}')

$existing = @()
$pglist = @('blog.html'); $pn = 2
while (Test-Path (Join-Path $repo "blog-$pn.html")) { $pglist += "blog-$pn.html"; $pn++ }
foreach ($pg in $pglist) {
  $t = Get-Content (Join-Path $repo $pg) -Raw -Encoding UTF8
  foreach ($m in [regex]::Matches($t, '(?s)<a class="post-card".*?</a>')) { $existing += $m.Value }
}
# 같은 글이 이미 목록에 있으면 옛 카드 제거(재실행 안전)
$newFiles = @($posts | ForEach-Object { $_.f })
$existing = @($existing | Where-Object { $card = $_; -not ($newFiles | Where-Object { $card.Contains('href="' + $_ + '"') }) })
$all = @($newCards) + @($existing)
$total = $all.Count; $tp = [math]::Ceiling($total / $PerPage)

function Get-File($i) { if ($i -eq 1) { 'blog.html' } else { "blog-$i.html" } }
function Build-Pager($i, $tp) {
  $s = '<nav class="pager">'
  if ($i -eq 1) { $s += '<span class="dis">← 이전</span>' } else { $s += '<a href="' + (Get-File ($i - 1)) + '">← 이전</a>' }
  for ($j = 1; $j -le $tp; $j++) { if ($j -eq $i) { $s += '<span class="cur">' + $j + '</span>' } else { $s += '<a href="' + (Get-File $j) + '">' + $j + '</a>' } }
  if ($i -eq $tp) { $s += '<span class="dis">다음 →</span>' } else { $s += '<a href="' + (Get-File ($i + 1)) + '">다음 →</a>' }
  $s += '</nav>'; return $s
}
for ($i = 1; $i -le $tp; $i++) {
  $start = ($i - 1) * $PerPage; $end = [math]::Min($i * $PerPage, $total) - 1
  $chunk = $all[$start..$end]
  $cardsHtml = ($chunk | ForEach-Object { '    ' + $_ }) -join "`n`n"
  $canon = Get-File $i
  $page = $tpl.Replace('{{CANON}}', $canon).Replace('{{N}}', "$i").Replace('{{TP}}', "$tp").Replace('{{TOTAL}}', "$total").Replace('{{CARDS}}', $cardsHtml).Replace('{{PAGER}}', (Build-Pager $i $tp))
  [System.IO.File]::WriteAllText((Join-Path $repo $canon), $page, $enc)
}
for ($k = $tp + 1; $k -le 80; $k++) { $extra = Join-Path $repo "blog-$k.html"; if (Test-Path $extra) { Remove-Item $extra } }

$sp = Join-Path $repo 'sitemap.xml'
$sc = Get-Content $sp -Raw -Encoding UTF8
foreach ($n in $posts) {
  if ($sc -notmatch [regex]::Escape($n.f)) {
    $nd = if ($n.date) { [string]$n.date } else { $d }
    $line = '  <url><loc>https://hpos.co.kr/' + $n.f + '</loc><lastmod>' + $nd + '</lastmod><changefreq>monthly</changefreq><priority>0.7</priority></url>'
    $sc = $sc.Replace('</urlset>', $line + "`n" + '</urlset>')
  }
}
[System.IO.File]::WriteAllText($sp, $sc, $enc)
Write-Output ("완료 - 총 " + $total + "편 / " + $tp + "페이지, 신규 " + $posts.Count + "편 추가 + sitemap")
