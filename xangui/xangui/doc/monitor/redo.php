<?php

if (isset($_GET['sha1'])) {
        $searchTerms = trim($_GET['sha1']);
        $searchTerms = strip_tags($searchTerms); // remove any html/javascript.

        if (strlen($searchTerms) < 3) {
                $error[] = "Search terms must be longer than 3 characters.";
        }else {
                $searchTermDB = mysql_real_escape_string($searchTerms); // prevent sql injection.
        }
}

echo $searchTermDB . ' being reprocessed';

$TotalRedo="/opt/malwareader/bin/reprocess.sh $searchTermDB";
exec ($TotalRedo); 


?>
