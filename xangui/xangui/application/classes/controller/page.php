<?php defined('SYSPATH') or die('No direct script access.');
  
class Controller_Page extends Controller_Template 
{
    /**
     * 'action' => roles
     *
     * where action is request action
     * roles consists of  
     * - an array('role1', 'role2', 'rolen') 
     * - false, open to all
     *
     * @var array
     */
    protected $acl            = array();
    protected $_public_header = true;
    public $auto_render       = true;
    public $template          = 'page/template';
    public $map_render        = false;

    /**
     * Check authorization and authentication
     * 
     * @return void
     */
    private function check_acl()
    {
        $this->user = Auth::instance()->get_user();
        $action = Request::instance()->action;

        if ( ! $this->user && $this->acl[$action] !== false )
            Request::instance()->redirect('auth/signin');

        if ( ! array_key_exists($action, $this->acl) )
            Request::instance()->redirect('errors/404');

        if ( is_array($this->acl[$action]) )
        {
            foreach ( $this->acl[$action] as $role )
            {
                if ( ! $this->user->has_role($role) )
                    Request::instance()->redirect('errors/404');
            }
        }
    }

    /**
     * before 
     * 
     * @return void
     */
    public function before()
    {
        //parent::before();
        
        if ( $this->request === Request::instance() && $this->_param('format') == '')
        {
            $this->check_acl();
            //echo "external ";
            //echo $this->request->action;
            //echo "<br />";
            $this->template = View::factory($this->template);
            $this->template->title   = '';
            $this->template->styles  = array();
            $this->template->scripts = array();
            $this->template->header  = $this->_header();
            $this->template->content = '';
            $this->template->footer  = $this->_footer();
        }
        else
        {
            //echo "internal ";
            //echo $this->request->action;
            //echo "<br />";
            
            // for internal request, we put a dummp template until we can 
            // figure a right way to handle between internal and external 
            // request
            $this->template = View::Factory('page/empty');
        }
    }

    /**
     * Default action for all controller should redirect to 404 page 
     * 
     * @todo check if action is missing, redirect to 404
     * @access public
     * @return void
     */
    function action_index()
    {
        $this->request->redirect('errors/404');
    }
        	
    /**
     * after 
     * 
     * @return void
     */
    public function after()
    {
        if ( $this->request === Request::instance() && $this->_param('format') == '')
        {
            $styles = array
            (
                'css/reset.css'  		=> 'all',
                'css/text.css'   		=> 'all',
                'css/960.css'    		=> 'all',
                'css/xangui.css' 		=> 'all',
            );

            $scripts = array();
            //$scripts[] = 'http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js';
            if ( $this->map_render )
            {
                $scripts[] = 'http://www.google.com/jsapi';
                $scripts[] = 'js/map.js';
            }

            $this->template->styles  = array_merge($this->template->styles, $styles);
            $this->template->scripts = array_merge($this->template->scripts, $scripts);
        }
        else
        {
            // internal request output will be assigned to response
            $this->template = $this->request->response;
        }
        parent::after();
    }

    /**
     * Parameters value from the default route
     * 
     * @param string $key 
     * @param mixed $default 
     * @access protected
     * @return mixed
     */
    function _param($key, $default = false)
    {
        return Arr::get($this->request->route->matches($this->request->uri), $key, $default); 
    }

    /**
     * _header 
     * 
     * @access protected
     * @return object
     */
    function _header()
    {
        $template = 'page/header';
        return View::factory($template);
    }

    /**
     * _footer 
     * 
     * @access protected
     * @return object
     */
    function _footer()
    {
        return View::factory('page/footer');
    }
}
