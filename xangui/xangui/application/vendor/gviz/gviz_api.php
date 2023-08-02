<?php
/**
 * 
 *
 * @author Lee Parker
 * @copyright Copyright (c) 2009 Social Agency
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 *
 * The MIT License
 *
 * Copyright (c) 2009 Social Agency
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 **/

/**
 * This class is the main class for building out a DataTable object and rendering
 * that object as a JSON Response to a query from the Google Visualization API.
 * 
 * Here is an example of how to use the class.  This example builds out a DataTable
 * with two columns and one row of data.  Then it turns it into a JSON Response and
 * echos that out.
 * <code>
 * <?php
 * include('gviz_api.php');
 * $Gviz = new GvizDataTable($_GET['tqx'], $_GET['responseHandler']);
 * $Gviz->addColumn('name', 'Name', 'string');
 * $Gviz->addColumn('sales', 'Sales', 'number');
 * $rowId = $Gviz->newRow();
 * $Gviz->addCell($rowId, 'name', 'Bob');
 * $Gviz->addCell($rowId, 'sales', 1234.56);
 * echo $Gviz->toJsonResponse();
 * </code>
 *
 * Note: The patterns expected by the column class are proper syntax for PHP's date 
 * function. These patterns will not be in the response when the object is rendered.
 **/
class GvizDataTable
{
    protected $_version = 0.5;
    protected $_responseHandler = 'google.visualization.Query.setResponse';
    protected $_reqId = 0;
    protected $_status = 'ok';
    protected $_sig;
    protected $_errors = array();
    protected $_warnings = array();
    protected $_columns = array();
    protected $_rows = array();
    protected $_lastNewRow = null;
    
    public function __construct($tqx = '', $responseHandler = '')
    {
        if(!empty($tqx))
        {
            $pairs = explode(';', $tqx);
            foreach($pairs as $pair)
            {
                list($key, $value) = explode(':', $pair);
                $key = '_' . $key;
                $this->$key = $value;
            }
        }
        if(!empty($responseHandler))
        {
            $this->_responseHandler = $responseHandler;
        }
        if(empty($this->_sig))
        {
            $this->_sig = md5(uniqid(rand(), true));
        }
    }
    
    public function addColumn($id, $label = '', $type = '', $pattern = '')
    {
        $this->_columns[$id] = new GvizDataTableColumn($id, $label, $type, $pattern);
        return $id;
    }
    
    public function addWarning($reason, $message = '', $detailed_message = '')
    {
        $this->_warnings[] = new GvizDataTableWarning($reason, $message, $detailed_message);
        $this->_status = 'warning';
    }
    
    public function addError($reason, $message = '', $detailed_message = '')
    {
        $this->_errors[] = new GvizDataTableError($reason, $message, $detailed_message);
        $this->_status = 'error';
    }
    
    public function newRow()
    {
        if(is_null($this->_lastNewRow))
        {
            $id = 0;
        }
        else
        {
            $id = $this->_lastNewRow + 1;
        }
        $row = new GvizDataTableRow();
        $this->_rows[$id] = $row;
        
        $this->_lastNewRow = $id;
        return $id;
    }

    public function addCell($rowId, $colId, $value, $formatted = '')
    {
        if(!isset($this->_rows[$rowId]) || !is_a($this->_rows[$rowId], 'GvizDataTableRow'))
            throw new GvizDataTableException("Row id, $rowId, not found");

        if(!isset($this->_columns[$colId]) || !is_a($this->_columns[$colId], 'GvizDataTableColumn'))
            throw new GvizDataTableException("Column id, $colId, not found");

        $type = $this->_columns[$colId]->getType();
        $pattern = $this->_columns[$colId]->getPattern();
        $this->_rows[$rowId]->addCell($colId, $type, $value, $formatted, $pattern);
    }
    
    protected function _arrayToJson($arrayName, $jsonName = '', $order = array())
    {
        $arrayName = ltrim($arrayName, '_');
        if(empty($jsonName))
        {
            $jsonName = $arrayName;
        }
        $arrayName = '_' . $arrayName;
        if(!isset($this->$arrayName) || !is_array($this->$arrayName))
        {
            throw new GvizDataTableException("Array name, $arrayName, is not set or is not an array.");
        }
        
        $jsonItems = array();
        foreach($this->$arrayName as $item)
        {
            $jsonItems[] = $item->toJson($order);
        }
        $itemsInner = implode(',', $jsonItems);
        
        $json = sprintf('%s:[%s]',$jsonName, $itemsInner);
        
        return $json;
    }
    
    public function toJson()
    {
        $table = array();
        $table[] = $this->_arrayToJson('columns', 'cols');
        $columnOrder = array_keys($this->_columns);
        $table[] = $this->_arrayToJson('rows', 'rows', $columnOrder);
        $tableInner = implode(',', $table);
        $json = sprintf('table: {%s}', $tableInner);
        return $json;
    }
    
    public function toJsonResponse()
    {
        $response = array();
        $response[] = "version: '{$this->_version}'";
        $response[] = "reqId: '{$this->_reqId}'";
        $response[] = "sig: '{$this->_sig}'";
        $response[] = "status: '{$this->_status}'";
        switch($this->_status)
        {
            case "error":
                $response[] = $this->_arrayToJson('errors');
                break;
            
            case "warning":
                $response[] = $this->_arrayToJson('warnings');
            case "ok":
                $response[] = $this->toJson();
                break;
        }
        $responseInner = implode(',', $response);
        $json = sprintf('%s({%s});', $this->_responseHandler, $responseInner);
        
        return $json;
    }
}

class GvizDataTableColumn
{
    protected $_id;
    protected $_label = '';
    protected $_type = 'string';
    protected $_pattern = '';
    protected $_validTypes = array(
        'boolean',
        'number',
        'string',
        'date',
        'datetime',
        'timeofday',
    );
    
    public function __construct($id, $label = '', $type = 'string', $pattern = '')
    {
        $this->_id = $id;
        
        if(empty($label))
        {
            $this->_label = $id;
        }
        else
        {
            $this->_label = $label;
        }
        
        if(in_array($type, $this->_validTypes))
        {
            $this->_type = $type;
        }
        else
        {
            throw new GvizDataTableException("Type, $type, not supported by this api.");
        }
        
        $this->_pattern = $pattern;
    }
    
    public function getType()
    {
        return $this->_type;
    }
    
    public function getPattern()
    {
        return $this->_pattern;
    }
    
    public function toJson($order = array())
    {
        $column = array();
        $column[] = "id: '{$this->_id}'";
        $column[] = "label: '{$this->_label}'";
        $column[] = "type: '{$this->_type}'";
        $columnInner = implode(',', $column);
        $json = sprintf('{%s}', $columnInner);
        
        return $json;
    }
    
    public static function getValidTypes()
    {
        $obj = new self(0);
        return $obj->_validTypes;
    }
}

class GvizDataTableRow
{
    protected $_cells = array();
    
    public function addCell($colId, $type, $value, $formatted = '', $pattern = '')
    {
        $this->_cells[$colId] = GvizDataTableCell::factory($type, $value, $formatted, $pattern);
    }
    
    public function toJson($order = array())
    {
        $row = array();
        if(!empty($order))
        {
            foreach($order as $column)
            {
                if(is_a($this->_cells[$column], 'GvizDataTableCell'))
                    $row[] = $this->_cells[$column]->toJson();
            }
        }
        else
        {
            foreach($this->_cells as $cell)
            {
                $row[] = $cell->toJson();
            }
        }
        
        $rowInner = implode(',', $row);
        $json = sprintf('{c:[%s]}', $rowInner);
        
        return $json;
    }
}

class GvizDataTableCell
{
    protected $_value;
    protected $_formatted = '';
    
    public function __construct($value, $formatted = '', $pattern = '')
    {
        $this->_value = $value;
        $this->_formatted = $formatted;
    }
    
    public static function factory($type, $value, $formatted = '', $pattern = '')
    {
        $type = strtolower($type);
        $class = "GvizDataTable" . ucfirst($type) . "Cell";
        if(!in_array($type, GvizDataTableColumn::getValidTypes()) || !class_exists($class))
        {
            throw new GvizDataTableException("Type, $type, not supported by this api");
        }
        
        if($value === '')
        {
            $class = 'GvizDataTableEmptyCell';
        }
        return new $class($value, $formatted, $pattern);
    }
    
    public function toJson()
    {
        $cell = array();
        $cell[] = "v: '{$this->_value}'";
        if(!empty($this->_formatted))
        {
            $cell[] = "f: '{$this->_formatted}'";
        }
        $cellInner = implode(',', $cell);
        
        $json = sprintf('{%s}', $cellInner);
        
        return $json;
    }
}

class GvizDataTableEmptyCell
{
    public function toJson()
    {
        return '';
    }
}

class GvizDataTableBooleanCell extends GvizDataTableCell
{
    public function __construct($value, $formatted = '', $pattern = '')
    {
        $possibleFalses = array('false', '0', 0, FALSE, '', NULL);
        $value = strtolower($value);
        if(in_array($value, $possibleFalses, true))
        {
            $value = 'false';
        }
        else
        {
            $value = 'true';
        }
        
        parent::__construct($value, $formatted);
    }
}

class GvizDataTableNumberCell extends GvizDataTableCell
{
    public function toJson()
    {
        $cell = array();
        $cell[] = "v: {$this->_value}";
        if(!empty($this->_formatted))
        {
            $cell[] = "f: '{$this->_formatted}'";
        }
        $cellInner = implode(',', $cell);
        
        $json = sprintf('{%s}', $cellInner);
        
        return $json;
    }
}

class GvizDataTableStringCell extends GvizDataTableCell
{
    
}

class GvizDataTableDatetimeCell extends GvizDataTableCell
{
    public function __construct($value, $formatted = '', $pattern = '')
    {
        if(!is_numeric($value))
        {
            $this->_value = strtotime($value);
        }
        else
        {
            $this->_value = $value;
        }
        
        if(empty($formatted) && !empty($pattern))
        {
            $this->_formatted = date($pattern, $this->_value);
        }
        else
        {
            $this->_formatted = $formatted;
        }
    }
    
    public function toJson()
    {
        $cell = array();
        $date = $this->_getDateParts();
        $cell[] = sprintf("v: new Date(%d, %d, %d, %d, %d, %d)",
            $date['year'],
            ($date['month'] - 1), //JS uses 0-11 for month
            $date['day'],
            $date['hour'],
            $date['minute'],
            $date['second']
        );
        if(!empty($this->_formatted))
        {
            $cell[] = "f: '{$this->_formatted}'";
        }
        $cellInner = implode(',', $cell);
        
        $json = sprintf('{%s}', $cellInner);
        
        return $json;
    }
    
    protected function _getDateParts()
    {
        $month = (int) date("m", $this->_value);
        $day = (int) date("d", $this->_value);
        $year = (int) date("Y", $this->_value);
        $hour = (int) date("H", $this->_value);
        $minute = (int) date("i", $this->_value);
        $second = (int) date("s", $this->_value);
        return compact('month', 'day', 'year', 'hour', 'minute', 'second');
    }
}

class GvizDataTableDateCell extends GvizDataTableDatetimeCell
{
    public function toJson()
    {
        $cell = array();
        $date = $this->_getDateParts();
        $cell[] = sprintf("v: new Date(%d, %d, %d)",
            $date['year'],
            ($date['month'] - 1),
            $date['day']
        );
        if(!empty($this->_formatted))
        {
            $cell[] = "f: '{$this->_formatted}'";
        }
        $cellInner = implode(',', $cell);
        
        $json = sprintf('{%s}', $cellInner);
        
        return $json;
    }
}

class GvizDataTableTimeofdayCell extends GvizDataTableDatetimeCell
{
    public function toJson()
    {
        $cell = array();
        $date = $this->_getDateParts();
        $cell[] = sprintf("v: [%d, %d, %d])",
            $date['hour'],
            $date['minute'],
            $date['second']
        );
        if(!empty($this->_formatted))
        {
            $cell[] = "f: '{$this->_formatted}'";
        }
        $cellInner = implode(',', $cell);
        
        $json = sprintf('{%s}', $cellInner);
        
        return $json;
    }
}

class GvizDataTableWarning
{
    protected $_reason;
    protected $_message = '';
    protected $_detailed_message = '';
    protected $_validReasons = array(
        'data_truncated',
        'other',
    );
    
    public function __construct($reason, $message = '', $detailed_message = '')
    {
        if(in_array($reason, $this->_validReasons))
        {
            $this->_reason = $reason;
        }
        else
        {
            throw new GvizDataTableException("Reason, $reason, is not a valid reason.");
        }
        
        $this->_message = $message;
        $this->_detailed_message = $detailed_message;
    }
    
    public function toJson($order = array())
    {
        $items = array();
        $items[] = "reason:'{$this->_reason}'";
        if(!empty($this->_message))
        {
            $items[] = "message:'{$this->_message}'";
        }
        if(!empty($this->_detailed_message))
        {
            $items[] = "detailed_message:'{$this->_detailed_message}'";
        }
        
        $warningInner = implode(',', $items);
        
        $json = sprintf('{%s}', $warningInner);
        
        return $json;
    }
    
    public static function getValidReasons()
    {
        $obj = new self('other');
        return $obj->_validReasons;
    }
}

class GvizDataTableError extends GvizDataTableWarning
{
    protected $_validReasons = array(
        'not_modified',
        'user_not_authenticated',
        'unknown_data_source_id',
        'access_denied',
        'unsupported_query_operation',
        'invalid_query',
        'invalid_request',
        'internal_error',
        'not_supported',
        'illegal_formatting_patterns',
        'other',
    );
    
    public static function getValidReasons()
    {
        $obj = new self('other');
        return $obj->_validReasons;
    }
}

class GvizDataTableException extends Exception
{
    
}
