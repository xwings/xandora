<?php defined('SYSPATH') or die('No direct script access.');

class Controller_File extends Controller_Page 
{
    protected $acl = array
    (
        'index'       => array('login'),
        'upload'      => array('login'),
        'download'    => array('login'),
    );

    /**
     * A list of all malwares 
     * 
     * @access public
     * @return void
     */
    function action_index()
    {
        // temporary hacks unless i remember how to do the route
        $bycriteria  = $this->request->param('id');
        $count       = Model::factory('malwareinfo')->count_by($bycriteria);
        $pagination  = Pagination::factory(array('total_items' => $count));
        $malware_set = Model::factory('malwareinfo')->find_by($bycriteria, $pagination->offset);

        $view  = View::factory('file/index');
        $view->set('malware_set', $malware_set)
            ->set('count', $count)
            ->set('start', $pagination->offset + 1)
            ->set('pagination', $pagination->render())
            ->set('message', Session::instance()->get_once('message', false));

        // debuggin purpose
        //echo Database::instance()->last_query;

        $this->template->title = __('Files');
        $this->template->content = $view;
    }

    /**
     * action_upload 
     * 
     * @access public
     * @return void
     */
    function action_upload()
    {
        if ( $_FILES ) 
        {
            $post = Validate::factory($_FILES);
            $post->rules('malware', array(
                'Upload::valid'     => array(),
                'Upload::not_empty' => array(), 
                'Upload::type'      => array('Upload::type' => array('exe','dll','')), 
                'Upload::size'      => array('5M'))
            );


            if ( $post->check() )
            {
                $uid      = $this->user->id;
                $md5_file = md5_file($_FILES['malware']['tmp_name']);
                $filename = $md5_file . '.' . $uid;
                $fullpath = Upload::save($_FILES['malware'], $filename, '/opt/malwareader/vendor/webupload', 0644);

                $message  = $_FILES['malware']['name'] . " ($md5_file) has been uploaded to the system.";
                $session  = Session::instance()->set('message', $message);
                Request::instance()->redirect('dashboard/index');
            }
            else
            {
                $this->errors = $post->errors('upload');
            }
        }
        
        $view = View::factory('file/upload');
        if ( isset($this->errors) ) $view->errors = $this->errors;

	    $this->template->title   = __('Upload File'); 
	    $this->template->content = $view;
    }

    /**
     * Download the malware using the SHA1 hash
     * 
     * @access public
     * @return void
     */
    function action_download()
    {
        $sha1 = $this->request->param('id');
		$malinfo = Model::factory('malwareinfo')->where('sha512','=',$sha1)->find();
		$date = $malinfo->mdate;
        //echo "$date";
		$this->request->send_file("/home/xandora/samples/$date/$sha1.zip");
    }
} 
