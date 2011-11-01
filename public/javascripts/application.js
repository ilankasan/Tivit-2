// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* This function is for showing dropdown list in main navigation */
function showlayer(layer){
	
	var myLayer = document.getElementById(layer);
	if (myLayer.style.display=="none" || myLayer.style.display=="")
	{
		myLayer.style.display="block";
	} 
	else
	{ 
		myLayer.style.display="none";
	}
}
function setFocus(field)
{
     document.getElementById(field).focus();
}

function changeBackground() {
	
	if (document.getElementsByTagName("BODY")[0].style.background == "#333333")
	{
		document.getElementsByTagName("BODY")[0].style.background = "white";
	}
	
	alert ("change background js called");
  	var body = document.body(layer);
	if (myLayer.style.background=="white")
	{
		myLayer.style.background="red";
	} 
	
   
}

