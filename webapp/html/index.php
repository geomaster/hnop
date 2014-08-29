<? 
if ($argv[1] === 'debug') define('DEBUG', true);
else define('DEBUG', false);
?>
<!DOCTYPE html>
<html lang="en" data-framework="emberjs">
<head>
<meta charset="utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="css/hnop.css" />
<title>HNOP Working Version</title>
</head>
<body>
<? foreach ([ "handlebars", "jquery", "ember" ] as $lib) { ?>
<script type="text/javascript" src="js/libs/<?=$lib?>.js"></script>
<? } ?>

<? 
if (DEBUG) {
    $files = [ "handlebars/templates", "utils", "bootstrap", "router", "application" ];
} else {
    $files = [ "app.min" ];
}

foreach ($files as $file) { ?>
<script type="text/javascript" src="js/<?=$file?>.js"></script>
<? } ?>
</body>
</html>

