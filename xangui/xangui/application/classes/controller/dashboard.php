<?php defined('SYSPATH') or die('No direct script access.');

class Controller_Dashboard extends Controller_Page 
{
    protected $acl = array
    (
        'index' => array('login')
    );

    /**
     * Main dashboard page for each user 
     * 
     * @return void
     */
	public function action_index()
	{
        $model = Model::factory('malwareinfo');
		//$smodel = Model::factory('stat');
		

        $template = ( $this->user->has_role('admin') ) 
            ? 'dashboard/index_admin'
            : 'dashboard/index_user';
        $view  = View::factory($template);
		$lastdays = date("Y-m-d",strtotime('yesterday'));
		//$lasthours = date("H:i:s",mktime(date("H",strtotime('-1 hour')), 0, 0, date("m"),date("d"), date("Y")));


        if ( $this->user->has_role('admin') )
        {
            $view->processed	        = $model->count_all();
            //$view->total_malware            = $smodel->dashboard()->totalrec;
            $view->queued               = $model->count_by('queued');
			$view->process              = $model->count_by('process');
            $view->processed_today      = $model->count_by('processed_today');
            $view->processed_this_week  = $model->count_by('processed_this_week');
            $view->processed_this_month = $model->count_by('processed_this_month');

            $count       = Model::factory('malwareinfo')
							->where('cdate','>',$lastdays)
							//->where('ctime','>',$lasthours)
							->count_all();
			
            $pagination  = Pagination::factory(array('total_items' => $count));
            $malware_set = Model::factory('malwareinfo')
                ->limit(Kohana::config('pagination')->default['items_per_page'])		
                ->offset($pagination->offset)
				//->join('fileuid')
				//->on('fileuid.xid','=','malwareinfo.xid')
				->order_by('cdate', 'desc')
				->order_by('ctime', 'desc')
				->where('status','=', 'Done')
				->where('cdate','>',$lastdays)
				//->where('ctime','>',$lasthours)
                ->find_all();

             $view->set('malware_set', $malware_set)
                ->set('start', $pagination->offset + 1)
                ->set('pagination', $pagination->render());
        }
        else
        {
            
			$uid      = $this->user->id;
			
			#$view->total_malware        = $model->count_all();
            $view->uprocessed            = $model->ucount_by('uprocessed',$uid);
            $view->uqueued               = $model->ucount_by('uqueued',$uid);
			$view->uprocess              = $model->ucount_by('uprocess',$uid);
            $view->uprocessed_today      = $model->ucount_by('uprocessed_today',$uid);
            $view->uprocessed_this_week  = $model->ucount_by('uprocessed_this_week',$uid);
            $view->uprocessed_this_month = $model->ucount_by('uprocessed_this_month',$uid);
			
			$count       = Model::factory('malwareinfo')
			->join('fileuid')
			->on('fileuid.xid','=','malwareinfo.xid')
            ->order_by('cdate', 'desc')
            ->order_by('ctime', 'desc')
			->where('status','=', "Done")
			->where('user_id','=',$uid)
			->where('cdate','>',$lastdays)
			//->where('ctime','>',$lasthours)
			->count_all();
            $pagination  = Pagination::factory(array('total_items' => $count));

            $malware_set = Model::factory('malwareinfo')

	
                ->limit(Kohana::config('pagination')->default['items_per_page'])
                ->offset($pagination->offset)
				->join('fileuid')
				
				->on('fileuid.xid','=','malwareinfo.xid')
                ->order_by('cdate', 'desc')
				->where('user_id','=',$uid)
				->where('cdate','>',$lastdays)
				//->where('ctime','>',$lasthours)
                ->find_all();
			

             	$view->set('malware_set', $malware_set)
                ->set('start', $pagination->offset + 1)
                ->set('pagination', $pagination->render())
                ->set('message', Session::instance()->get_once('message', false));
        }

        $this->template->title = __('Dashboard');
        $this->template->content = $view;
	}

}
