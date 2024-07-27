<?php

class Model_Registryinfo extends ORM
{
    protected $_table_name  = 'registryinfo';
    protected $_primary_key = 'id';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );
}
