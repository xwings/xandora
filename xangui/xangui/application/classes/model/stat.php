<?php

/**
 * All statistic related data (e.g. top ten something)
 * 
 */
class Model_stat
{
    /**
     * Constructor 
     * 
     * @access protected
     * @return object
     */
    public function __construct()
    {
        return $this;
    }

    /**
     * top_country 
     * 
     * @access public
     * @return object
     */

    /**
     * top_country 
     * 
     * @return object | array
     */
    public function top_country()
    {
        return DB::select('*')
            ->from('stat_country')
            ->join('_country')
            ->on('country', '=', 'iso')
            ->order_by('count', 'DESC')
            //->limit('999')
            ->cached('86400')
            ->as_object()
            ->execute();
    }    

	public function dashboard()
	    {
	        return DB::select('*')
	            ->from('stat_counter')
	            //->limit('999')
	            ->cached('86400')
	            ->as_object()
	            ->execute();
	    }

    /**
     * latest top ips (ipv4) 
     * 
     * @access public
     * @return void
     */
    public function top_ip()
    {
        return DB::select('*')
            ->from('stat_ip')
            ->order_by('count', 'DESC')
            ->limit('10')
            ->as_object()
            ->execute();
    }

    /**
     * latest top domains
     * 
     * @access public
     * @return object
     */
    public function top_domain()
    {
        return DB::select('*')
            ->from('stat_domain')
            ->order_by('count', 'DESC')
            ->limit('10')
            ->as_object()
            ->execute();
    }

    /**
     * latest top malwares
     * 
     * @access public
     * @return object
     */
    public function top_malware()
    {
        return DB::select('*')
            ->from('stat_malware')
            ->order_by('count', 'DESC')
            ->limit('10')
            ->as_object()
            ->execute();
    }
}
