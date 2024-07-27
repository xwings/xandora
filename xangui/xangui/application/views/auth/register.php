<div class="grid_12">
<?php 
    if ( $error_msg != '' ) 
    {
        echo '<div class="error_msg">';
        echo 'Error : ' . $error_msg; 
        echo '</div>';
    }
?>

<div class="section">Registration</div>

<?php echo FORM::open('auth/register', array('method' => 'post', 'name' => 'register')); ?>

Username/Email : 
<br />
<input name="username" type="text" size="25" width="25" /></td></tr>
<br />

Password : 
<br />
<input name="password" type="password" size="25" width="25" />
<p></p>

<?php 
    $recaptcha = Recaptcha::instance(Kohana::config('recaptcha')); 
    echo $recaptcha->get_html();
?>

<input type="submit" value = "Sign Up"/></form>
</div>
