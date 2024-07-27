<?php

class Model_Generatedfile extends ORM
{
    protected $_table_name  = 'generated_file';
    protected $_primary_key = 'id';
    protected $_belongs_to  = array(
        'malwareinfo' => array('foreign_key' => 'xid')
    );
}
