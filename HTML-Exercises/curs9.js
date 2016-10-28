window.onload = myMain;

function myMain()
{
	//alert(screen.availWidth + " " + screen.availHeight);
	//var newPage = open("http://www.google.com");

	//newPage.alert("Fereastra copil");
	//newPage.opener.alert("Fereastra parinte");
	//setTimeout( function(){newPage.close();}, 3000);

	var hello;
	var end = 20000;
	setTimeout(stopHello,end);
	setTimeout(sayHelloMany, 5000);
}

function sayHello()
{
	alert("hello");
}
function sayHelloMany()
{
	hello = setInterval(sayHello, 3000);
}
function stopHello()
{
	clearInterval(hello);
}