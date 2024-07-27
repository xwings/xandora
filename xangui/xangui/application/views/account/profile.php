<div class="grid_12">
<h1>Update Your Profile</h1>
    <?php
        echo FORM::open('account/profile', array('id' => 'account.profile', 'method' => 'post'));
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
    <td><input type="submit" value = "Update"/></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
    </table>
    </form>
</div>
