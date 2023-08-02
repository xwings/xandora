<?
//****************************************************************************
////////////////////////Downloaded from  www.plus2net.com   //////////////////////////////////////////
///////////////////////  Visit www.plus2net.com for more such script and codes.
////////                    Read the readme file before using             /////////////////////
//////////////////////// You can distribute this code with the link to www.plus2net.com ///
/////////////////////////  Please don't  remove the link to www.plus2net.com ///
//////////////////////////
//*****************************************************************************
if (isset($_GET['search'])) {
        $searchTerms = trim($_GET['search']);
        $searchTerms = strip_tags($searchTerms); // remove any html/javascript.

        if (strlen($searchTerms) < 3) {
                $error[] = "Search terms must be longer than 3 characters.";
        }else {
                $searchTermDB = mysql_real_escape_string($searchTerms); // prevent sql injection.
        }
}


?>
<!doctype html public "-//w3c//dtd html 3.2//en">

<html>

<head>
<title>Xandora Status Board</title>
<meta name="GENERATOR" content="Arachnophilia 4.0">
<meta name="FORMATTER" content="Arachnophilia 4.0">
</head>

<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#800080" alink="#ff0000">

<center>
<b>Xanora Status Board</b>
<br>
<br>
<form method="GET" action="<?php echo $_SERVER['PHP_SELF'];?>" name="searchForm">
	Search <input type="text" name="search" value="<?php echo isset($searchTerms)?htmlspecialchars($searchTerms):''; ?>" />
	<input type="submit" name="submit" value="search" />
</form>
</center>

<?
require "config.php";           // All database details will be included here 
$page_name="urlsearch.php"; //  If you use this code with a different page ( or file ) name then change this 

$start=$_GET['start'];								// To take care global variable if OFF
if(!($start > 0)) {                         // This variable is set to zero for the first page
$start = 0;
}

$eu = ($start -0);                
$limit = 15;                                 // No of records to be shown per page.
$this1 = $eu + $limit; 
$back = $eu - $limit; 
$next = $eu + $limit; 


/////////////// WE have to find out the number of records in our table. We will use this to break the pages///////
$query2="select url,hashsha1 from TrafficWWW ORDER BY id DESC";
$result2=mysql_query($query2);
echo mysql_error();
$nume=mysql_num_rows($result2);
/////// The variable nume above will store the total number of records in the table////

/////////// Now let us print the table headers ////////////////
$bgcolor="#f1f1f1";
echo "<TABLE width=90% align=center  cellpadding=0 cellspacing=0> <tr>";
echo "<td  bgcolor='dfdfdf' >&nbsp;<font face='arial,verdana,helvetica' color='#000000' size='4'>Date</font></td>";
echo "<td  bgcolor='dfdfdf' >&nbsp;<font face='arial,verdana,helvetica' color='#000000' size='4'>Time</font></td>";
echo "<td  bgcolor='dfdfdf' >&nbsp;<font face='arial,verdana,helvetica' color='#000000' size='4'>Hash</font></td>";
echo "<td  bgcolor='dfdfdf' >&nbsp;<font face='arial,verdana,helvetica' color='#000000' size='4'><font>Url</font></td>";

////////////// Now let us start executing the query with variables $eu and $limit  set at the top of the page///////////
$query="select url,hashsha1 from TrafficWWW ORDER BY id DESC LIMIT $eu, $limit";
$result=mysql_query($query);
echo mysql_error();

//////////////// Now we will display the returned records in side the rows of the table/////////
while($noticia = mysql_fetch_array($result))
{
if($bgcolor=='#f1f1f1'){$bgcolor='#ffffff';}
else{$bgcolor='#f1f1f1';}

echo "<tr >";
echo "<td align=left bgcolor=$bgcolor id='title'>&nbsp;<font face='Verdana' size='2'>$noticia[date]</font></td>"; 
echo "<td align=left bgcolor=$bgcolor id='title'>&nbsp;<font face='Verdana' size='2'>$noticia[time]</font></td>"; 
echo "<td align=left bgcolor=$bgcolor id='title'>&nbsp;<font face='Verdana' size='2'><a href=download.php?f=$noticia[hashsha1]>$noticia[hashsha1]</a></font></td>"; 
echo "<td align=left bgcolor=$bgcolor id='title'>&nbsp;<font face='Verdana' size='2'>$noticia[url]</font></td>"; 

echo "</tr>";
}
echo "</table>";
////////////////////////////// End of displaying the table with records ////////////////////////

///// Variables set for advance paging///////////
$p_limit=15; // This should be more than $limit and set to a value for whick links to be breaked

$p_f=$_GET['p_f'];								// To take care global variable if OFF
if(!($p_f > 0)) {                         // This variable is set to zero for the first page
$p_f = 0;
}



$p_fwd=$p_f+$p_limit;
$p_back=$p_f-$p_limit;
//////////// End of variables for advance paging ///////////////
/////////////// Start the buttom links with Prev and next link with page numbers /////////////////
echo "<table align = 'center' width='50%'><tr><td  align='left' width='20%'>";
if($p_f<>0){print "<a href='$page_name?start=$p_back&p_f=$p_back'><font face='Verdana' size='2'>PREV $p_limit</font></a>"; }
echo "</td><td  align='left' width='10%'>";
//// if our variable $back is equal to 0 or more then only we will display the link to move back ////////
if($back >=0 and ($back >=$p_f)) { 
print "<a href='$page_name?start=$back&p_f=$p_f'><font face='Verdana' size='2'>PREV</font></a>"; 
} 
//////////////// Let us display the page links at  center. We will not display the current page as a link ///////////
echo "</td><td align=center width='30%'>";
for($i=$p_f;$i < $nume and $i<($p_f+$p_limit);$i=$i+$limit){
if($i <> $eu){
$i2=$i+$p_f;
echo " <a href='$page_name?start=$i&p_f=$p_f'><font face='Verdana' size='2'>$i</font></a> ";
}
else { echo "<font face='Verdana' size='4' color=red>$i</font>";}        /// Current page is not displayed as link and given font color red

}


echo "</td><td  align='right' width='10%'>";
///////////// If we are not in the last page then Next link will be displayed. Here we check that /////
if($this1 < $nume and $this1 <($p_f+$p_limit)) { 
print "<a href='$page_name?start=$next&p_f=$p_f'><font face='Verdana' size='2'>NEXT</font></a>";} 
echo "</td><td  align='right' width='20%'>";
if($p_fwd < $nume){
print "<a href='$page_name?start=$p_fwd&p_f=$p_fwd'><font face='Verdana' size='2'>NEXT $p_limit</font></a>"; 
}
echo "</td></tr></table>";

?>
</body>

</html>
