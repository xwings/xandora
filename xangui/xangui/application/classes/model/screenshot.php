<?php

class Model_Screenshot extends ORM
{
    protected $_table_name  = 'screenshot';
    protected $_primary_key = 'id';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );
}
