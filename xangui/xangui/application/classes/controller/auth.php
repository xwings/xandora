<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Auth extends Controller_Page 
{
    protected $acl = array
    (
        'register' => false,
        'signin'   => false,
        'signout'  => array('login'),
    );

/**
 * action_register
 * 
 * @return void
 */

	public function action_register()
	{	

		#Load the view
		$content = $this->template->content = View::factory('auth/register');		

		#If there is a post and $_POST is not empty
		if ($_POST)
		{
		
			$error_msg = '';
        	if ( Request::$method == 'POST' )
        	{
            	$recaptcha = Recaptcha::instance(Kohana::config('recaptcha'));
            	$resp = $recaptcha->check_answer();
            	
				if ( ! $resp->is_valid ) 
            	{
                	$error_msg = "The reCAPTCHA wasn't entered correctly. Please try it again."; 
                	// echo $resp->error;
            	} 
            	else 
            	{
		
					#Instantiate a new user
					$user = ORM::factory('user');	

					#Load the validation rules, filters etc...
					$post = $user->validate_create($_POST);			

					#If the post data validates using the rules setup in the user model
				
					if ($post->check())
					{
						#Affects the sanitized vars to the user object
						$user->values($post);

						#create the account
						$user->save();

						#Add the login role to the user
						$login_role = new Model_Role(array('name' =>'login'));
						$user->add('roles',$login_role);
					
						#sign the user in
						Auth::instance()->login($post['username'], $post['password']);

						#redirect to the user account
						Request::instance()->redirect('/');
					}
				}
			}
		}
		else
			{
            	#Get errors for display in view
				$content->errors = $post->errors('register');
			}
	}
		


    /**
     * action_signin 
     * 
     * @return void
     */
	public function action_signin()
	{
        if ( Request::$protocol == 'http' )
        {
            
			//Request::instance()->redirect(URL::site(Request::instance()->uri, 'https'));
        }

        $error_msg = '';
        if ( Request::$method == 'POST' )
        {
           	#$recaptcha = Recaptcha::instance(Kohana::config('recaptcha'));
            #$resp = $recaptcha->check_answer();
            #if ( ! $resp->is_valid ) 
            #{
            #    $error_msg = "The reCAPTCHA wasn't entered correctly. Please try it again."; 
            #    // echo $resp->error;
            #} 
            #else 
            #{
                $auth = Auth::instance();
                if ( $auth->login($_POST['username'], $_POST['password']) )
                {
                    Request::instance()->redirect(URL::site('/', 'http'));
                }
                else
                {
                    $error_msg = "Invalid username or password. Please try it again."; 
                }
            #}          
        }

        $view = View::factory('auth/signin');
        $view->error_msg = $error_msg;
        $this->template->title   = __('Xandora - Member Sign In');
        $this->template->content = $view;
	}

    /**
     * Sign out from the system 
     * 
     * @return void
     */
    public function action_signout()
    {
        Auth::instance()->logout();
        Request::instance()->redirect('welcome');     
    }
} 
