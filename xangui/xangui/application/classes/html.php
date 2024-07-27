<?php defined('SYSPATH') or die('No direct script access.');

class HTML extends Kohana_HTML 
{
    /**
     * css_button 
     * 
     * @param string $url 
     * @param string $name 
     * @param string $filename 
     * @return string
     */
    public static function css_button($url, $name, $filename = '')
    {
        $span = $name;
        return Html::anchor($url, $span, array('class' => 'button'));
    }

    /**
     * error_msg 
     * 
     * @param array $errors 
     * @param string $name 
     * @return string
     */
    public static function error_msg(array $errors, $name)
    {
        if ( ! isset($errors[$name]) ) return '';
        return "<span style='color:red; font-weight: bold;'>" 
            . ucfirst($errors[$name]) 
            . "</span>";
    }

    /**
     * Create a tab item in the page header for a navigation bar 
     * 
     * @param string $uri 
     * @param string $title 
     * @param string $separator toggle the separator or not 
     * @return string
     */
    public static function tabitem($uri, $title, $separator = true, $first = false)
    {
        $selected = ( Request::instance()->uri == $uri ) ? TRUE : FALSE;
        // there should be a better of checking this
        if ( ! $selected )
        {
            if ( Request::instance()->uri == '' && 
                 Request::instance()->controller == 'welcome' &&
                 $uri == '/'
                )
                $selected = TRUE;
        }

        $property = array();
        if ( $first ) $property['class']              = 'first';
        if ( $selected ) $property['class']           = 'selected';
        if ( $first && $selected ) $property['class'] = 'first_selected';

        $a = HTML::anchor($uri, $title, $property);
        return ( $separator ) ? $a . "|" : $a;
    }

    /**
     * section 
     * 
     * @param string $title 
     * @param boolean $non_member 
     * @return string
     */
    public static function section($title, $non_member = true)
    {
        $h = "<div class='section'>&nbsp;"
           . "<div style='float:left;'>$title</div>";

        if ( $non_member )
        {   
            $h .= "<div style='float:right;'>read "    
               . HTML::anchor('auth/login', 'more')
               . "</div>";

        }   
        $h .= "</div>";
        return $h; 
    } 

    /**
     * Create a Google's Map Chart
     * 
     * @param array $country_set 
     * @return string
     */
    public static function googlemap_chart($country_set, $type = 'marker')
    {
        foreach ( $country_set as $country )
        {
            $data[$country->country] = $country->count;
        }

        if ( $type == 'marker' )
        {
            $i = 0; $chm = '';
            foreach ( $data as $k => $count )
            {
                $item = $i + 1;
                $chm .= "f$item,000000,0,$i,10"; 
                if ( $i < 9 ) $chm .= '|';
                $i++;
            }

            $chld = implode('|', array_keys($data));
            $attr = array
            (
                'width'  => '600', 
                'height' => '300', 
                'alt'    => 'Top Ten Countries'
            );
        
            $params = array
            (
                'cht'  =>'map',
                'chf'  =>'bg,s,EEEEEE', 
                'chs'  =>'600x300', 
                'chld' => $chld, 
                'chco' =>'B3BCC0|5781AE|FF0000|FFC726|885E80|518274|FFCC00|000084', 
                'chm'  => $chm, 
                'chma' =>'0,0,0,0' 
            );
        }
        else
        {
            foreach ( $data as $k => $count )
            {
                $data[$k] = $count;
            }
            $sum = array_sum(array_values($data));
            foreach ( $data as $k => $count )
            {
                $data[$k] = round(( $count / $sum ) * 100) + 1;
            }
            ksort($data);
            $chld = implode('|', array_keys($data));
            $chd  = 't:' . implode(',', array_values($data));

            $attr = array
            (
                'width'  => '440', 
                'height' => '220', 
                'alt'    => 'Top Ten Countries'
            );
            $params = array
            (
                'chf'  =>'bg,s,EEEEEE', 
                'chs'  =>'440x220', 
                'cht'  =>'t', 
                'chco' =>'FFFFFF,FF0000,FFFF00,00FF00', 
                'chld' => $chld,
                'chd'  => $chd,
                'chtm' => 'world' 
            );
        }

        $url  = "http://chart.apis.google.com/chart?" . http_build_query($params);

		return HTML::image($url, $attr);

    }
}
