<div class="grid_12">
<h1>Add New User</h1>
    <?php
        echo FORM::open('user/add', array('id' => 'user.add', 'method' => 'post'));
    ?>
    <table>
    <tr>
    <td><label>Username :</td>
    <td><input type="text" name="username" value="<?php echo $username; ?>"/></td>
    <td><?php echo Html::error_msg($errors, 'username'); ?></td>
    </tr>
    <tr>
    <td><label>Email :</td>
    <td><input type="text" name="email" value="<?php echo $email; ?>"/></td>
    <td><?php echo Html::error_msg($errors, 'email'); ?></td>
    </tr>
    <tr>
    <td><label>Password :</td>
    <td><input type="password" name="password" value="<?php echo $password; ?>"/></td>
    <td><?php echo Html::error_msg($errors, 'password'); ?></td>
    </tr>
    <tr>
    <tr>
    <td>&nbsp;</td>
	
    	<td><input type="checkbox" name="is_admin" />
        	Administrator</td>
		<td><input type="checkbox" name="is_researchers" />
		    Researchers</td>
		<td><input type="checkbox" name="is_community" />
		    Community</td>
		
    <td>&nbsp;</td>
    </tr>
    <tr>
    <td><input type="submit" value = "Add"/></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
    </table>
    </form>
</div>
