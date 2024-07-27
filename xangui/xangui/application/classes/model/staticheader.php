<?php

class Model_Staticheader extends ORM
{
    protected $_table_name  = 'static_header';
    protected $_primary_key = 'xid';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );
}
