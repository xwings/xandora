<div class="grid_12">
<?php 
    if ( $error_msg != '' ) 
    {
        echo '<div class="error_msg">';
        echo 'Error : ' . $error_msg; 
        echo '</div>';
    }
?>

<div class="section">Sign In</div>

<?php echo FORM::open('auth/signin', array('method' => 'post', 'name' => 'signin')); ?>

Username/Email : 
<br />
<input name="username" type="text" size="25" width="25" /></td></tr>
<br />

Password : 
<br />
<input name="password" type="password" size="25" width="25" />
<p></p>

<?php 
    #$recaptcha = Recaptcha::instance(Kohana::config('recaptcha')); 
    #echo $recaptcha->get_html();
?>

<input type="submit" value = "Sign In"/></form>
<br>
<div class="section">
Get account in xandora facebook page
</div>
<script src="http://connect.facebook.net/en_US/all.js#xfbml=1"></script><fb:like-box href="http://www.facebook.com/#!/pages/Xandora/180984238612166" width="292" show_faces="false" stream="false" header="false"></fb:like-box>

</div>
