<?php

class Model_Scaninfo extends ORM
{
    protected $_table_name  = 'scaninfo';
    protected $_primary_key = 'id';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );

	#function vendorname()
    #{
    #    $sql = " select _antivirus_company.name as aname,scaninfo.name as vname from scaninfo,_antivirus_company"
    #         . " where _antivirus_company.id=scaninfo.antivirus_company and xid= :xid";
    #    $result = DB::query(Database::SELECT, $sql)->param(':xid', $this->xid)->as_object(get_class($this))->execute();
    #    return $result;
    #}
}
