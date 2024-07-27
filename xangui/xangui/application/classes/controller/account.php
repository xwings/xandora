<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Account extends Controller_Page
{
    protected $acl = array
    (
        'profile' => array('login')
    );

    /**
     * Edit own profile details like email address or password
     * 
     * @return void
     */
    public function action_profile()
    {
        // fixme
        // quick hack to prevent this user from changing the password
        //if ( $this->user->has_role('public') )
        //{
        //    Request::instance()->redirect('errors/404');
        //}

        if ( Request::$method == 'POST' ) 
        {
            $user = $this->user;
            $post = $user->validate_update($_POST);
            if ( $post->check() )
            {
                $user->email = $post['email'];
                if ( $post['password'] != '' )
                {
                    $user->password = $post['password'];
                }
                $user->save();

                $message = "Your user profile have been has been updated in the system.";
                $session = Session::instance()->set('message', $message);
                Request::instance()->redirect('dashboard/index');
            }
            else
            {
                $errors = $post->errors('add');
            }
        }

        $user = $this->user;
        $view = View::factory('account/profile');
        $view->set('id', $user->id);
        $view->set('username', $user->username);

        if ( Request::$method == 'POST' ) 
        {
            $view->set('email', Arr::get($_POST, 'email', null));
            $view->set('password', Arr::get($_POST, 'password', ''));
        }
        else
        {
            $errors = array();
            $view->set('email', $user->email);
            $view->set('password', '');
        }

        $view->errors = $errors; 
        $this->template->title   = __('Xandora - Update Profile');
        $this->template->content = $view;
    }
}
