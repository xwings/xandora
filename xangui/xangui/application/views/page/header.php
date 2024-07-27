<div style="margin-bottom: 0pt; padding-top: 10pt;" class="grid_12">
<p id="topnav" style="float:right; text-align: right;">
	<?php 
	    $user = Auth::instance()->get_user();
	    if ( $user )
	    {
	        echo "Sign in as "; 
	        echo HTML::tabitem('account/profile', $user->email, true, true);
	        echo HTML::tabitem('auth/signout', 'Sign out', false);
	    }
	    else
	    {
	        if ( Request::instance()->action != 'signin' )
	        {
	            echo HTML::tabitem('auth/login', 'Sign In', false);
				echo "|";
				echo HTML::tabitem('http://www.facebook.com/xandora.net?sk=app_4949752878', 'Registration', false);
			
	        }
	    }
	?>
</p>
</div>

<div style="float:left;" class="grid_7">
    <?php echo Html::anchor('/', Html::image('images/logo.png', array('align' => 'left'))); ?>
    <span id="title">Xandora - Your Online Binary Analyzer</span>
    <p id="tabs" style="text-align: left;">
    <?php 
        $navbar = Kohana::config('navbar');
        $max = sizeof($navbar);
        $i = 1;
        foreach ( $navbar as $uri => $title )
        {
            echo HTML::tabitem($uri, $title, $i == $max ? false : true, $i == 1 ? true : false);
            $i++;
        }
    ?>
    </p>
</div>

<div style="float:right;" class="grid_5">
<?php 
    echo FORM::open('malware/search', array('id' => 'search', 'method' => 'get'));
    $by_set = array
    (
        'md5'    => 'md5', 
        'ip'     => 'ip', 
        'domain' => 'domain', 
        //'url'    => 'url', 
        'name'   => 'name'
    );
    $by = isset($_GET['by']) ? $_GET['by'] : '';
    echo FORM::select('by', $by_set, $by);
?>

<input name="keyword" type="text" size="20" width="140" 
    value="<?php echo isset($_GET['keyword']) ? $_GET['keyword'] : ''; ?>" />
<input type="submit" value = "Search"/>
</form>
	
</div>

<div class="grid_12"><hr /></div>
