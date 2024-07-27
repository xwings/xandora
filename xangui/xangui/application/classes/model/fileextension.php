<?php

class Model_Fileextension extends ORM
{
    protected $_table_name  = '_file_extension';
    protected $_primary_key = 'id';
    protected $_has_one     = array(
        'malwareinfo' => array('foreign_key' => 'id')
    );
}
