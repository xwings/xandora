<?php

class Model_Processinfo extends ORM
{
    protected $_table_name  = 'processinfo';
    protected $_primary_key = 'id';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );
}
