<?php 
    if ( isset($errors) ) 
    {   
        echo "<div class='grid_12'>";
        echo "<div id='error'>" . $errors['malware'] . "</div>"; 
        echo "</div>";
        echo "<div class='grid_12'>&nbsp;</div>";
    }   
?>

<div class="grid_12">
<h1>Upload Files</h1>
    <?php
        echo Form::open('file/upload', 
            array('method' => 'post', 'enctype' => 'multipart/form-data'));
    ?>
    <table>

    <tr>
    <td width="10%"><label>File :</td>
    <td><input type="file" name="malware"/></td>
    </tr>

    <tr>
    <td><input type="submit" value = "Upload"/></td>
    <td>&nbsp;</td>
    </tr>

    </table>
    </form>

</div>
