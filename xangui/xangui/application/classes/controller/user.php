<?php defined('SYSPATH') or die('No direct script access.');

class Controller_User extends Controller_Page
{
    protected $acl = array
    ( 
        'index'  => array('admin'),
        'add'    => array('admin'),
        'edit'   => array('admin'),
        'remove' => array('admin'),
    ); 

    /**
     * List all available users in the system 
     *
     * @return void
     */
    public function action_index()
    {
        $count      = Model::factory('user')->count_all();
        $pagination = Pagination::factory(array('total_items' => $count));
        $user_set   = Model::factory('user')
            ->limit(Kohana::config('pagination')->default['items_per_page'])
            ->offset($pagination->offset)
            ->find_all();

        $view = View::factory('user/index')
            ->set('user_set', $user_set)
            ->set('start', $pagination->offset + 1)
            ->set('pagination', $pagination->render())
            ->set('message', Session::instance()->get_once('message', false));

        $this->template->title   = __('xandora.net - User List');
        $this->template->content = $view;
    }

    /**
     * Add a new user 
     * 
     * @return void
     */
    public function action_add()
    {
        if ( Request::$method == 'POST' ) {
            $user = ORM::factory('user');
            $post = $user->validate_add($_POST);
            if ( $post->check() )
            {
                $user->values($post);
                $user->save();
                $user->assign_role('login');
                if ( Arr::get($_POST, 'is_admin', false) )
                    $user->assign_role('admin');
				elseif ( Arr::get($_POST, 'is_researchers', false) )
                    $user->assign_role('researchers');
				elseif ( Arr::get($_POST, 'is_community', false) )
                    $user->assign_role('community');
				
				
				$to      = $user->email;  // Address can also be array('to@example.com', 'Name')
				$from    = array('reg@xandora.net','Xandora Registration System');
				$subject = "Welcome to Xandora";
				$message = 	"Hello,<br><br>" . 
							"Thank you for registration." .
							"<br>Your account is being created." .
							"<br><br>Username: ". $user->username .
							"<br>Password: ". $post['password'] .
							"<br>Email: ". $user->email .
							"<br><br>Please login to: http://xandora.net and change your password" .
							"<br><br>If you have any questions, you can contact us at reg@xandora.net";
				
				//$config['driver'] = 'native';			
				email::send($to, $from, $subject, $message, TRUE);

                $message = "$user->username ($user->email) has been added to the system.";
                $session = Session::instance()->set('message', $message);
                Request::instance()->redirect('user/index');
            }
            else
            {
                $errors = $post->errors('add');
            }
        }
        else
        {
            $errors = array();
            $post = array
            (
                'username' => '', 
                'email'    => '',
                'password' => ''
            );
        }

        $view = View::factory('user/add', $_POST ? $_POST : $post);
        $view->errors = isset($errors) ? $errors : false;
        $this->template->title   = __('xandora.net - Add new member');
        $this->template->content = $view;
    }


    public function action_edit()
    {
        if ( Request::$method == 'POST' ) 
        {
            $user = ORM::factory('user')->find($_POST['id']);
            $post = $user->validate_update($_POST);
            if ( $post->check() )
            {
                $user->email = $post['email'];
                if ( $post['password'] != '' )
                {
                    $user->password = $post['password'];
                }

                $user->save();

                if ( Arr::get($_POST, 'is_admin', false) && ! $user->has_role('admin') )
                {
                    $user->assign_role('admin');
                }
				else
                {
                    $user->remove_role('admin');
					#$user->remove_role('researchers');
					#$user->remove_role('community');
                }

                if ( Arr::get($_POST, 'is_researchers', false) && ! $user->has_role('researchers') )
				{
					$user->assign_role('researchers');
				}
				else
                {
                    #$user->remove_role('admin');
					$user->remove_role('researchers');
					#$user->remove_role('community');
                }
				if ( Arr::get($_POST, 'is_community', false) && ! $user->has_role('community') )
				{
					$user->assign_role('community');
				}
				else
                {
                    #$user->remove_role('admin');
					#$user->remove_role('researchers');
					$user->remove_role('community');
                }
				

                $message = "$user->username ($user->email) details has been updated in the system.";
                $session = Session::instance()->set('message', $message);
                Request::instance()->redirect('user/index');
            }
            else
            {
                $errors = $post->errors('add');
            }
        }

        $id   = ( Request::$method == 'POST' ) ? Arr::get($_POST, 'id') : $this->_param('id');
        $user = Model::factory('user')->find($id);
        $view = View::factory('user/edit');
        $view->set('id', $user->id);
        $view->set('username', $user->username);

        if ( Request::$method == 'POST' ) 
        {
            $view->set('email', Arr::get($_POST, 'email', null));
            $view->set('password', Arr::get($_POST, 'password', ''));
            $view->set('is_admin', Arr::get($_POST, 'is_admin', null));
            #$view->set('is_researchers', Arr::get($_POST, 'is_researchers', null));
            #$view->set('is_community', Arr::get($_POST, 'is_community', null));
        }
        else
        {
            $errors = array();
            $view->set('email', $user->email);
            $view->set('password', '');
            $view->set('is_admin', $user->has_role('admin') ? 'on' : null);
            #$view->set('is_researchers', $user->has_role('researchers') ? 'on' : null);
            #$view->set('is_community', $user->has_role('community') ? 'on' : null);
        }

        $view->errors = $errors; 
        $this->template->title   = __('xandora.net - Edit member details');
        $this->template->content = $view;
    }

    /**
     * Remove a user from the system 
     * 
     * @return void
     */
    public function action_remove()
    {
        $user    = Model::factory('user')->find($this->_param('id'));
        $message = "$user->username ($user->email) has been removed from the system.";
        $session = Session::instance()->set('message', $message);
        $user->delete();
        Request::instance()->redirect('user/index');
    }
}
