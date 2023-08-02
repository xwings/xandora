<?php defined('SYSPATH') or die('No direct script access.');

/**
 * Auth 
 * 
 * @uses Kohana_Auth
 * @package 
 * @version $Id$
 */
abstract class Auth extends Kohana_Auth
{
    /**
     * Create a similar record in htpasswd file using
     * shell > htpasswd -s passwordfile username 
     *
     * The hash string is fixed at 28 characters. 
     *
     * @param string $password 
     * @return string
     */
    public function htpasswd($password)
    {
        return base64_encode(sha1($password, true));
    }
}
