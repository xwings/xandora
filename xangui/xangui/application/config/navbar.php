<?php

$user = Auth::instance()->get_user(); 
if ( ! $user )
{
    return array
    (
        '/'						=> 'Home',
		'../upload'				=> 'Upload Files',
		'welcome/disclaimer' 	=> 'Disclaimer',
		'welcome/about' 		=> 'About',

    );
}

if ( $user->has_role('admin') )
{
    return array
    (
        '/'               => 'Home',
        'dashboard/index' => 'Dashboard',
        //'file/index'      => 'Files',
        'user/index'      => 'Users',
    );
}
else
{
    return array
    (
        '/'               => 'Home',
        'dashboard/index' => 'Dashboard',
        //'file/index'      => 'Files',
    );
}
