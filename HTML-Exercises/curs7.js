window.onload = myMain;

function myMain() {
	document.getElementById("citire").onsubmit = suma;
	document.getElementById("quiz").onsubmit = totalQuiz;
	document.getElementById("tta").onchange = function ()
	{
		alert(document.getElementById("tta").value);
	}
}

function suma() {
	var x = document.getElementById("nr").value;
	var s = 0; 
	for (var i=1; i<= parseInt(x) ; i++) 
		s=s+i;
	alert('Suma este ' +  s); 
}

function totalQuiz() { 
	var fe = document.getElementById("quiz").elements; 
	var q1 = fe[0].elements; 
	var q2 = fe[4].elements; 
	var x=0;
	for (var i = 0; i<q1.length; i++) if (q1[i].checked) x = x + parseInt(q1[i].value); 
	for (var i = 0; i<q2.length; i++) if (q2[i].checked) x = x + parseInt(q2[i].value); 
	alert(fe.length + " " + q1.length + " " + q2.length + " " + x);
}

