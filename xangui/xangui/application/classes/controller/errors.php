<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Errors extends Controller_Page
{
    protected $acl = array
    (
        '404'              => false, 
        'search_not_found' => false
    );
       
    /**
     * action_404 
     * 
     * @return void
     */
    public function action_404()
    {
        $view                    = View::factory('errors/404');
        $this->request->status   = 404;
	    $this->template->title   = __('xandora.net - 404 Not Found'); 
	    $this->template->content = $view;
    }

    /**
     * action_search_not_found 
     * 
     * @return void
     */
    public function action_search_not_found()
    {
        $view                    = View::factory('errors/search_not_found');
        $this->request->status   = 404;
	    $this->template->title   = __('xandora.net - Search not found'); 
	    $this->template->content = $view;
    }
}
