/* 동 파라미터: ?dong=OO동 이면 페이지 키워드를 해당 동 이름으로 치환 + 그 동 인근 지하철역 표시 */
(function(){
  var q=new URLSearchParams(location.search), d=q.get("dong");
  if(!d) return;
  var D=document.body.getAttribute("data-d");
  var slug=document.body.getAttribute("data-slug");
  if(!D) return;
  var rep=function(t){ return t.split(D).join(d); };
  document.querySelectorAll(".chips a").forEach(function(a){ a.textContent=rep(a.textContent); });
  var h1=document.querySelector(".rhero h1"); if(h1) h1.innerHTML=rep(h1.innerHTML);
  var sb=document.querySelector(".rhero .sub"); if(sb) sb.textContent=rep(sb.textContent);
  var lc=document.querySelector(".loc"); if(lc) lc.textContent=lc.textContent+" · "+d;
  var cb=document.querySelector(".crumb2 b"); if(cb) cb.textContent=cb.textContent+" "+d;
  var h2=document.querySelector(".rcontent h2"); if(h2) h2.textContent=rep(h2.textContent);
  document.title=d+" "+document.title;

  /* 인근 지하철역: 동 데이터 우선, 없으면 지역(구) 데이터 */
  var sec=document.getElementById("subway");
  var list=document.getElementById("subwayList");
  var kwEl=document.getElementById("subwayKw");
  var raw=(window.SUBWAY_DONG&&window.SUBWAY_DONG[d])||(window.SUBWAY_GU&&slug&&window.SUBWAY_GU[slug])||"";
  if(!raw) return;
  var st=raw.split("|").filter(Boolean);
  if(sec) sec.textContent=rep(sec.textContent);
  if(list) list.innerHTML='🚇 <b>'+st.join(" · ")+'</b>';
  if(kwEl){
    var suffix=" 자판기";
    var t=kwEl.textContent||"";
    if(t.indexOf("테이블오더")>-1) suffix=" 테이블오더";
    else if(t.indexOf("포스기")>-1) suffix=" 포스기 설치";
    kwEl.textContent=st.map(function(s){return s+suffix;}).join(" · ");
  }
})();