<?php

/**
 * Model_Search 
 *
 * Due to Kohana fucked up chicken-and-egg pagination problem, we needs to 
 * query twice for the same result, first for total count and second for the 
 * exact result. This means that the searching is not really that optmize at 
 * all and proned to ddos attack. 
 * 
 */
class Model_Search
{
	protected $acl = array
    (
        'index' => array('login')
    );

    /**
     * Search a particular malware by md5, sha512, url, domain, or name 
     * 
     * @param string $by the types of seach 
     * @param mixed $keyword 
     * @param integer $offset 
     * @access public
     * @return array
     */
    function search($by, $keyword, $offset='')
    {
        $method_name = 'by_' .$by;
        return $this->$method_name($keyword, $offset);
    }

    /**
     * count 
     * 
     * @param mixed $by 
     * @param mixed $keyword 
     * @access public
     * @return void
     */
    function count($by, $keyword)
    {
        $method_name = 'count_by_' .$by;
        return $this->$method_name($keyword, '', true);
    }

    /**
     * by_md5 
     * 
     * @param string $md5 
     * @param integer $offset 
     * @return object | false
     */
    private function by_md5($md5, $offset)
    {
        
		if ( strlen($md5) != 32 ) return false; 
		$xid_set = DB::select(DB::expr('distinct xid'))
            ->from('malwareinfo')
            ->where('md5', 'like', "$md5%")
            ->limit(10)
            ->order_by('xid', 'desc')
            ->offset($offset)
            ->execute()
            ->as_array();
        return $this->by_xid($xid_set);
        //return Model::factory('malwareinfo')->where('md5', '=', $md5)->find();
    }

    private function count_by_md5($md5)
    {
        return DB::select(DB::expr('count(distinct xid) as total'))
            ->from('malwareinfo')
			->limit(10)
            ->where('md5', 'like', "$md5%")
            ->execute()
            ->get('total');
    }

    /**
     * by_ip 
     * 
     * @param string $ip 
     * @param integer $offset 
     * @return object | false
     */
    private function by_ip($ip, $offset)
    {
	
		if ( ! preg_match("/^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/", $ip) ) return false;

        $xid_set = DB::select(DB::expr('distinct xid'))
            ->from('trafficinfo')
            ->where('ipv4', '=', "$ip")
            ->limit(10)
            ->order_by('xid', 'desc')
            ->offset($offset)
            ->execute()
            ->as_array();
        return $this->by_xid($xid_set);
    }

    /**
     * count_by_ip 
     * 
     * @param string $ip 
     * @return integer
     */
    private function count_by_ip($ip)
    {
        return DB::select(DB::expr('count(distinct xid) as total'))
            ->from('trafficinfo')
			->limit(10)
            ->where('ipv4', '=', "$ip")
            ->execute()
            ->get('total');
    }

    /**
     * by_domain 
     * 
     * @param string $domain 
     * @param integer $offset 
     * @return object : false 
     */
    private function by_domain($domain, $offset)
    {
        $xid_set = DB::select(DB::expr('distinct xid'))
            ->from('trafficinfo')
            ->where('domain', 'like', "%$domain%")
            ->limit(10)
            ->order_by('xid', 'desc')
            ->offset($offset)
            ->execute()
            ->as_array();
        return $this->by_xid($xid_set);
    }

    /**
     * count_by_domain 
     * 
     * @param string $domain 
     * @return integer
     */
    private function count_by_domain($domain)
    {
        return DB::select(DB::expr('count(distinct xid) as total'))
            ->from('trafficinfo')
			->limit(10)
            ->where('domain', 'like', "%$domain%")
            ->execute()
            ->get('total');
    }

    /**
     * Find all malwares using part of the virus name 
     * 
     * @param string $name 
     * @param integer $offset 
     * @access public
     * @return array
     */
    function by_name($name, $offset)
    {
        $xid_set = DB::select(DB::expr('distinct xid'))
            ->from('scaninfo')
            ->where('name', 'like', "%$name%")
            ->limit(10)
            ->order_by('xid', 'desc')
            ->offset($offset)
            ->execute()
            ->as_array();
        return $this->by_xid($xid_set);
    }

    /**
     * count_by_name 
     * 
     * @param string $name 
     * @return integer
     */
    private function count_by_name($name)
    {
        return DB::select(DB::expr('count(distinct xid) as total'))
            ->from('scaninfo')
			->limit(10)
            ->where('name', 'like', "%$name%")
            ->execute()
            ->get('total');
    }

    private function by_url($url, $offset)
    {
    }

    /**
     * by_xid 
     * 
     * @param object $xid_set 
     * @return array
     */
    private function by_xid($xid_set)
    {
        $malware_set = array();
        foreach ($xid_set as $xid)
        {
            $malware_set[] = ORM::factory('malwareinfo', $xid);
        }
        return sizeof($malware_set) > 0 ? $malware_set : false;
    }
}
