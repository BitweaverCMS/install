<h1>Database Connection Information</h1>

{form class="form-horizontal" legend="Your database connection information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="control-group">
		<p>If you don't want to reset or change your installation settings, please press the continue button.</p>
	</div>

	<div class="control-group submit">
		<input type="submit" class="btn" name="continue_install" value="Continue {$section|default:"install"} process" />
	</div>

	<div class="control-group">
		<p>Your database information is stored in the file <kbd>{$smarty.const.BIT_ROOT_PATH}config/kernel/config_inc.php</kbd>. To reset these settings with new ones, delete the settings stored therein before you connect to a different database.</p>
		<p class="warning">Before you hit the <strong>Reset config_inc.php file button</strong> please make sure you know what you are doing.</p>
		<p>Hitting the <strong>Reset</strong> button will delete all contents in the <kbd>config_inc.php</kbd> file which will render your site useless until you've completed the installation process again. This is only really useful if your database access information has changed or if you plan to install Bitweaver to a different database or use a different schema or prefix.</p>
		<p>If you want to reinstall Bitweaver into the same database as before, make sure you have deleted all Bitweaver related tables before doing so. Reinstalling into an existing database might cause unwanted effects.</p>
	</div>

	<div class="control-group submit">
		<input type="submit" class="btn" name="reset_config_inc" value="Reset config_inc.php file" onclick="return confirm( 'Are you absolutely sure you want to reset your configuration file?' );" />
	</div>
{/form}
