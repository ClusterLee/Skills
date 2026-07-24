/* whiteprint · deck 运行时
   键盘翻页（← → ↑ ↓ Space PgUp PgDn Home End）、hash 深链 #/N、
   按窗口 scale 适配固定设计画布、页码角标。渲染脚本靠 #/N 逐页截图。 */
(function(){
  var deck=document.querySelector('.deck');
  var slides=[].slice.call(document.querySelectorAll('.slide'));
  if(!deck||!slides.length)return;
  var cur=0;

  function fit(){
    var w=parseFloat(getComputedStyle(deck).getPropertyValue('--slide-w'));
    var h=parseFloat(getComputedStyle(deck).getPropertyValue('--slide-h'));
    if(!w||!h)return;
    var s=Math.min(window.innerWidth/w,window.innerHeight/h)*0.96;
    deck.style.transform='translate(-50%,-50%) scale('+s+')';
  }
  function show(i){
    cur=Math.max(0,Math.min(slides.length-1,i));
    slides.forEach(function(s,j){s.classList.toggle('is-active',j===cur);});
    var n=document.querySelector('.page-num');
    if(n)n.textContent=(cur+1)+' / '+slides.length;
    if(history.replaceState)history.replaceState(null,'','#/'+(cur+1));
  }
  // hash 深链（render.sh 用 #/N 逐页截图）
  var m=location.hash.match(/#\/(\d+)/);
  if(m)cur=parseInt(m[1],10)-1;
  show(cur);fit();

  document.addEventListener('keydown',function(e){
    if(['ArrowRight','ArrowDown','PageDown',' '].indexOf(e.key)>-1){e.preventDefault();show(cur+1);}
    else if(['ArrowLeft','ArrowUp','PageUp'].indexOf(e.key)>-1){e.preventDefault();show(cur-1);}
    else if(e.key==='Home'){show(0);}
    else if(e.key==='End'){show(slides.length-1);}
  });
  window.addEventListener('resize',fit);
})();
