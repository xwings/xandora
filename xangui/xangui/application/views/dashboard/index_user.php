<?php 
    if ( $message ) 
    {
        echo "<div class='grid_12'>";
        echo "<div id='message'>$message</div>"; 
        echo "</div>";
        echo "<div class='grid_12'>&nbsp;</div>";
    }
?>



<div class="grid_4">
    <?php echo Html::css_button('/file/upload/', '+ Upload File'); ?>
</div>


<div class="grid_8">
    <div style="text-align:right;">
        <?php echo $pagination == '' ? '<p>&nbsp;</p>' : $pagination; ?>
    </div>
</div>


<div class="grid_2">
<div class="stat_box">
<?php echo (number_format($uprocessed, 0)); ?>
<br />
<span style="font-size: 8pt;">Processed</span>
</div>
</div>

<div class="grid_2">
<div class="stat_box">
<?php echo (number_format($uqueued, 0)); ?>
<br />
<span style="font-size: 8pt;">Queued</span>
</div>
</div>

<div class="grid_2">
<div class="stat_box">
<?php echo (number_format($uprocess, 0)); ?>
<br />
<span style="font-size: 8pt;">Processing</span>
</div>
</div>

<div class="grid_2">
<div class="stat_box">
<?php echo (number_format($uprocessed_today, 0)); ?>
<br />
<span style="font-size: 8pt;">Analyzed today</span>
</div>
</div>

<div class="grid_2">
<div class="stat_box">
<?php echo (number_format($uprocessed_this_week, 0)); ?>
<br />
<span style="font-size: 8pt;">Analyzed This Week</span>
</div>
</div>

<div class="grid_2">
<div class="stat_box">
<?php echo (number_format($uprocessed_this_month, 0)); ?>
<br />
<span style="font-size: 8pt;">Analyzed This Month</span>
</div>
</div>

<div class="grid_12">&nbsp;</div>

<div class="grid_4">&nbsp;</div>



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
<th>VT</th>
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
        echo "<td class='$class'>" . $malware->scaninfo->count_all() . "</td>";
        echo "</tr>";
        $i++;
    }
?>
</table>
</div>
