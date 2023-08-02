<?php defined('SYSPATH') or die('No direct access allowed.');

return array
(
    'malware' => array(
        'Upload::valid'     => 'valid msg',
        'Upload::not_empty' => 'No file is uploaded !',
        'Upload::type'      => 'Wrong file type! Must be .exe or .dll file.',
        'Upload::size'      => 'size msg',
        'default'           => 'default msg'
    ),
);
