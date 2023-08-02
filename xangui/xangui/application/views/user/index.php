<?php 
    if ( $message ) 
    {
        echo "<div class='grid_12'>";
        echo "<div id='message'>$message</div>"; 
        echo "</div>";
        echo "<div class='grid_12'>&nbsp;</div>";
    }
?>

<div class="grid_6">
    <?php echo Html::css_button('/user/add/', '+ Add New User'); ?>
</div>

<div class="grid_6">
    <div style="text-align:right;">
        <?php echo $pagination == '' ? '<p>&nbsp;</p>' : $pagination; ?>
    </div>
</div>

<div class="grid_12">
<table id="list">
<thead>
<th width="1%">No.</th>
<th>Username</th>
<th>Email</th>
<th>Role(s)</th>
<th>Total Login</th>
<th>Last Login</th>
<th>Action(s)</th>
</thead>
<?php
    $i = $start;
    foreach ( $user_set as $user )
    {
        $class = $i % 2 == 0 ? 'odd' : 'even';
        echo "<tr>";
        echo "<td class='$class'>$user->id</td>";
        echo "<td class='$class'>$user->username</td>";
        echo "<td class='$class'>$user->email</td>";
        echo "<td class='$class'>" . $user->roles_name() . "</td>";
        echo "<td class='$class'>" . $user->logins . "</td>";
        echo "<td class='$class'>" . $user->last_login() . "</td>";
        echo "<td class='$class'>" 
            . HTML::anchor("/user/edit/$user->id", 'Edit') 
            . ", "
            . HTML::anchor("/user/remove/$user->id", 'Remove') 
            . "</td>";
        echo "</tr>";
        $i++;
    }
?>
</table>
</div>
