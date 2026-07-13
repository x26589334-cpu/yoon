/* 동 파라미터: ?dong=OO동 이면 페이지 키워드를 해당 동 이름으로 치환 */
(function(){
  var q=new URLSearchParams(location.search), d=q.get("dong");
  if(!d) return;
  var D=document.body.getAttribute("data-d");
  if(!D) return;
  var rep=function(t){ return t.split(D).join(d); };
  document.querySelectorAll(".chips a").forEach(function(a){ a.textContent=rep(a.textContent); });
  var h1=document.querySelector(".rhero h1"); if(h1) h1.innerHTML=rep(h1.innerHTML);
  var sb=document.querySelector(".rhero .sub"); if(sb) sb.textContent=rep(sb.textContent);
  var lc=document.querySelector(".loc"); if(lc) lc.textContent=lc.textContent+" · "+d;
  var cb=document.querySelector(".crumb2 b"); if(cb) cb.textContent=cb.textContent+" "+d;
  var h2=document.querySelector(".rcontent h2"); if(h2) h2.textContent=rep(h2.textContent);
  document.title=d+" "+document.title;
})();