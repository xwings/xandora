<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Welcome extends Controller_Page 
{
    protected $acl = array
    (
        'index'      => false,
        'disclaimer' => false,
		'about'		 => false,
    );

    /**
     * action_index 
     * 
     * @return void
     */
	public function action_index()
	{
        $this->map_render = true;
        $view = View::factory('welcome/index');
        $view->top_country       = Request::factory('malware/top_country')->execute()->response;
        $view->top_malware       = Request::factory('malware/top_malware')->execute()->response;
        $view->top_ip            = Request::factory('malware/top_ip')->execute()->response;
        $view->top_domain        = Request::factory('malware/top_domain')->execute()->response;
        $this->template->title   = __('xandora.net - Your Online Binary Analyser');
        $this->template->content = $view;
		#$this->template->content = View::factory('home');
	}

    /**
     * action_disclaimer 
     * 
     * @access public
     * @return void
     */
    function action_disclaimer() 
    {
        $view = View::factory('welcome/disclaimer');
        $this->template->title    = __('xandora.net - Disclaimer');
        $this->template->header   = $this->_header();
        $this->template->content  = $view;
    }

    /**
     * action_about
     * 
     * @access public
     * @return void
     */
    function action_about() 
    {
        $view = View::factory('welcome/about');
        $this->template->title    = __('xandora.net - about');
        $this->template->header   = $this->_header();
        $this->template->content  = $view;
    }



}
