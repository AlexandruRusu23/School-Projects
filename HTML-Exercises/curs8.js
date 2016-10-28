window.onload = myMain;

function myMain()
{
	var a = document.getElementById("buton");
	//a.onclick = function(){alert("salut!");}
	a.addEventListener("click", function(){alert("hello!");}, false);

	window.addEventListener('mousemove', pozMouse, false);

	window.addEventListener('keydown', keyboardInput);

	var apd = document.getElementById("nu");
	apd.addEventListener("click", linkFMI); 
}

function linkFMI(event)
{
	event.preventDefault(); 
	alert("nou");
}

function pozMouse(event) 
{
	document.getElementById('cx').value = event.pageX;
	document.getElementById('cy').value = event.pageY;
}

function keyboardInput(event)
{
	document.getElementById('key').value = event.key;
	document.getElementById('which').value = event.which;
	document.getElementById('code').value = event.keyCode;
}