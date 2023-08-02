<div class="grid_4"><h1>Total <?php echo number_format($count, 0); ?> Files</h1></div>

<div class="grid_8">
    <div style="text-align:right;">
        <?php echo $pagination == '' ? '<p>&nbsp;</p>' : $pagination; ?>
    </div>
</div>

<div class="grid_12">
<table id="list">
<thead>
<th width="1%">No.</th>
<th>Name</th>
<th>MD5</th>
<th>Date</th>
<th>Time</th>
<th>Score</th>
<th>Size</th>
<th>Extension</th>
<th>Virustotal</th>
</thead>
<?php
    $i = $start;
    foreach ( $malware_set as $malware )
    {
        $class = $i % 2 == 0 ? 'odd' : 'even';
        echo "<tr>";
        echo "<td class='$class'>$i</td>";
        echo "<td class='$class'>" . $malware->name() . "</td>";
        echo "<td class='$class'>"
            . HTML::anchor("/malware/view/$malware->md5", $malware->md5) 
            . "</td>";
        echo "<td class='$class'>$malware->cdate</td>";
        echo "<td class='$class'>$malware->ctime</td>";
        echo "<td class='$class'>$malware->score</td>";
        echo "<td class='$class'>$malware->filesize</td>";
        echo "<td class='$class'>" . $malware->fileextension->name . "</td>";
        echo "<td class='$class'>" . $malware->scaninfo->count_all() . "</td>";
        echo "</tr>";
        $i++;
    }
?>
</table>
</div>
