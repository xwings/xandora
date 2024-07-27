<div class="grid_12">
<h1>Edit User's Details</h1>
    <?php
        echo FORM::open('user/edit', array('id' => 'user.edit', 'method' => 'post'));
    ?>
    <table>
    <tr>
    <td><label>Username</td>
    <td width="1%">:</td>
    <td><?php echo $username; ?></td>
    <td>&nbsp;</td>
    </tr>
    <tr>
    <td width="8%"><label>Email</td>
    <td width="1%">:</td>
    <td><input type="text" name="email" value="<?php echo $email; ?>"/></td>
    <td><?php echo Html::error_msg($errors, 'email'); ?></td>
    </tr>
    <tr>
    <td><label>Password</td>
    <td width="1%">:</td>
    <td><input type="password" name="password" value="<?php echo $password; ?>"/></td>
    <td><?php echo Html::error_msg($errors, 'password'); ?></td>
    </tr>
    <tr>
    <tr>
    <td>&nbsp;</td>
    <td width="1%">&nbsp;</td>
	<td><input type="checkbox" name="is_admin" <?php if ( isset($is_admin) ) echo "checked"; ?>/>
    	Administrator</td>
	<td><input type="checkbox" name="is_researchers"/>
	   	Researchers</td>
   	<td><input type="checkbox" name="is_community"/>
    	Community</td>
	<td>&nbsp;</td>
    </tr>
    <tr>
    <td><input type="submit" value = "Update"/></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><input type="hidden" name="id" value="<?php echo $id; ?>"></td>
    </tr>
    </table>
    </form>
</div>
