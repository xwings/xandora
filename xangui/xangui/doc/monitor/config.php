<?php
$servername='localhost';     // Your MySql Server Name or IP address here
$dbusername='autoportal';                // Login user id here
$dbpassword='Xutoportal789';                // Login password here
$dbname='xandora';     // Your database name here

connecttodb($servername,$dbname,$dbusername,$dbpassword);
function connecttodb($servername,$dbname,$dbuser,$dbpassword)
{
global $link;
$link=mysql_connect ("$servername","$dbuser","$dbpassword");
if(!$link){die("Could not connect to MySQL");}
mysql_select_db("$dbname",$link) or die ("could not open db".mysql_error());
}


?>
