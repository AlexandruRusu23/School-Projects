//window.onload =  myMain;

window.onload = function ()
{
    d = document.getElementById("aux");   
    d.insertAdjacentHTML("beforeend","<p> Alandala </p>");  
    p = d.lastChild; 
    alert(p.nodeName); 
    t = p.firstChild;
    alert(t.nodeName);
    alert(t.nodeType);
    alert(t.nodeValue);   
}


function myMain() 
{
	document.getElementById("sum").onclick = suma;
	document.getElementById("buton").onclick = schimbaStil;
}

function schimbaStil()
{
	document.getElementById("schimb").style.color = "blue";
	document.getElementById("schimb").style.backgroundColor = "yellow";
}

function suma() 
{
	var x = prompt("Introduceti nr =");
	if (isNaN(x)) 
	{
		alert("input gresit")
	}
	else 
	{
  		var s = 0; 
  		for (var i=1; i<= x ; i++) 
  			s=s+i;
  		alert('Suma este ' +  s); 
	}
}
