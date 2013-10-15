function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) preparePage();
}
function prepareNavbar(mm, sm) {
  if (mm) {
    document.images["nb_"+mm].src = "/pcf_green/graphics/navbar/"+mm+"_s.gif";
//  MM_nbGroup('init','group1','nb_'+mm,'/pcf_aqua/graphics/navbar/'+mm+'_n.gif',0);
//	if (sm) {
//    document.images["nb_"+sm].src = "/pcf_aqua/graphics/navbar/"+sm+"_s.gif";
//	}
  }
}
function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}


function preparePage() {
  prepareNavbar('calc', 'c_qual');
}
function doCalc() {
  return doCalcOnForm(MM_findObj("qualForm"));
}
function calculator1() {
        var x = format_Number(MM_findObj("qualForm").txtFinancing1.value, 2);
        if (Number(x) > 1000) { command("calc", x); } else { alert("Please check the data"); }
}
function calculator2() {
        var x = format_Number(MM_findObj("qualForm").txtFinancing2.value, 2);
        if (Number(x) > 1000) { command("calc", x); } else { alert("Please check the data"); }
}
function calculator3() {
        var x = format_Number(MM_findObj("qualForm").txtFinancing3.value, 2);
        if (Number(x) > 1000) { command("calc", x); } else { alert("Please check the data"); }
}
function command(cmd, key) { 
    var fm=MM_findObj("qualForm"); 
    if (cmd) { fm.cmd.value = cmd; } 
    if (key) { fm.key.value = key; } 
    fm.submit(); 
}
