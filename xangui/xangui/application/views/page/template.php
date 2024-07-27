<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">
<head profile="http://gmpg.org/xfn/11">
<title><?php echo $title ?></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<link rel="icon" href="favicon.ico">

<?php foreach ($styles as $file => $type) echo HTML::style($file, array('media' => $type)), "\n" ?>
<?php foreach ($scripts as $file) echo HTML::script($file), "\n" ?>

</head>

<body>
<div class="container_12">

<?php echo $header; ?>
<?php echo $content; ?>
<?php echo $footer; ?>

</div>
</body>

</html>
