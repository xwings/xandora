<?php

class Model_Trafficinfo extends ORM
{
    protected $_table_name  = 'trafficinfo';
    protected $_privary_key = 'id';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );

    /**
     * Latest top ten domains with infected malwares
     * 
     * @param int $total 
     * @access public
     * @return object
     */
    function latest_domain($total = 10)
    {
        $sql = " select t.* from trafficinfo t"
             . " join malwareinfo m using(xid)"
             . " where t.domain != ''"
             . " group by t.domain"
             . " order by count(id) desc, m.cdate desc"
             . " limit $total";
        $result = DB::query(Database::SELECT, $sql)->as_object(get_class($this))->execute();
        return $result;
    }
}
