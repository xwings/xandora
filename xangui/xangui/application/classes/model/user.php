<?php

/**
 * Model_User 
 * 
 * @uses Model_Auth_User
 * @package 
 * @version $Id$
 * @copyright Copyright (C) 2010-2011 Xandora. All rights reserved.
 */
class Model_User extends Model_Auth_User 
{
    /**
     * save 
     * 
     * @return boolean
     */
    public function save()
    {   
        if ( array_key_exists('password', $this->_changed) || isset($this->htpasswd) )
        {   
            $this->htpasswd = Auth::instance()->htpasswd($this->_object['password']);
            #$this->htpasswd = Auth::instance()->htpasswd($user->password);
        }   
        return parent::save();
    } 

    /**
     * Assign a role to this user
     * 
     * @param string $role_name 
     * @return void
     */
    public function assign_role($role_name)
    {
        $this->add('roles', new Model_Role(array('name' => $role_name)));
    }

    /**
     * Remove a user's role 
     * 
     * @param mixed $role_name 
     * @return void
     */
    public function remove_role($role_name)
    {
        $this->remove('roles', new Model_Role(array('name' => $role_name)));
    }

    /**
     * Last login date in human readable form
     * 
     * @return void
     */
    public function last_login()
    {
        $format = 'D d M Y - H:i:s';
        return ($this->last_login) ? date($format, $this->last_login) : 'Never';
    }

    /**
     * Check this user has a particular role 
     * 
     * @param string $role 
     * @return boolean
     */
    public function has_role($role)
    {
        $role = $this->roles->where('name', '=', $role)->find();
        return $role == '' ? false : true;
    }


    /**
     * Roles name in comma separated list  
     * 
     * @return void
     */
    public function roles_name()
    {
        $names = array();
        foreach ( $this->roles->find_all() as $role )
        {
            $names[] = $role->name;
        }
        return implode($names, ', ');
    }
    
    /**
     * validate 
     * 
     * @return object validation
     */
    public function validate_add($post)
    {
        // Initialise the validation library and setup some rules       
        $validator = Validate::factory($post)
            ->rules('password', $this->_rules['password'])
            ->rules('username', $this->_rules['username'])
            ->rules('email', $this->_rules['email'])
            //->rules('password_confirm', $this->_rules['password_confirm'])
            ->filter('username', 'trim')
            ->filter('email', 'trim')
            ->filter('password', 'trim');
            //->filter('password_confirm', 'trim');
 
 
            #Add Model_Auth_User callbacks
            foreach ( $this->_callbacks as $field => $callbacks )
            {
                foreach ( $callbacks as $callback )
                {
                    $validator->callback($field, array($this, $callback));
                }
            }
        return $validator;
    }

    /**
     * validate for updating
     * 
     * @return object validation
     */
    public function validate_update($post)
    {
        $post = Validate::factory($post)
            ->rules('email', $this->_rules['email'])             
            ->filter('email', 'trim')
            ->filter('password', 'trim');
 
        if ( trim($post['password']) != '' )
        {
            $post->rules('password', array('min_length'=> array(5), 'max_length'=>array(42)));
        }
        return $post;  
    }
}
