<h1>Database Connection Information</h1>

{form legend="Your database connection information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<p>If you don't want to reset or change your installation settings, please press the continue button.</p>
	</div>

	<div class="row submit">
		<input type="submit" name="continue_install" value="Continue {$section|default:"Install"} Process" />
	</div>

	<div class="row">
		<p>Your database information is stored in the file '<strong>{$smarty.const.INSTALL_PKG_PATH}kernel/config_inc.php</strong>'. If you would like to reset these settings with new ones, you will first have to delete the settings stored therein before you can connect to a different database.</p>
		<p>Before you hit the <strong>Reset config_inc.php file button</strong> please make sure you know what you are doing.</p>
		<p>Hitting the <strong>Reset</strong> button will delete all contents in the config_inc.php file which will render your site useless until you've completed the installation process again. This is only really useful if your database access information has changed or if you plan to install bitweaver to a different database or use a different schema or prefix.</p>
		<p>If you want to reinstall bitweaver into the same database as before, make sure you have deleted all bitweaver related tables before doing so. Reinstalling into an existing database might cause unwanted effects.</p>
	</div>

	<div class="row submit">
		<input type="submit" name="reset_config_inc" value="Reset config_inc.php file" />
	</div>
{/form}
