<h1>Install Options</h1>

{form class="form-horizontal" legend="Install or upgrade Bitweaver" style="text-align:center"}
	<input type="hidden" name="step" value="{$next_step}" />

	<input type="submit" class="btn btn-default" name="continue_install" value="Install Bitweaver" />
{*
	<br />
	<p>Select this option if this is your first installation of Bitweaver.</p>
	
	<hr />
	
	<input type="submit" class="btn btn-default" name="upgrade_r1" value="Upgrade from R1" />
	<p>Select this option, if you have an existing Bitweaver version 1 installed and would like to upgrade to version 2.</p>

	<hr />

	<input type="submit" class="btn btn-default" name="upgrade" value="Upgrade database" />
	<p>Select this option, if you want to upgrade from Bitweaver versions prior to 1, or from other applications such as Tikiwiki. You will be brought back to the installer once the upgrade process has been completed.</p>

	<hr />

	<input type="submit" class="btn btn-default" name="migrate" value="Migrate database" />
	<p>Select this option, if you wish to migrate from one database source to another, such as from MySQL to PostgreSQL. You will be brought back to the installer once the upgrade process has been completed. <strong>This feature is currently not working. It was working once and needs some attention since it hasn't been updated in a while. If you know some PHP, please help us out if you are interested in this feature.</strong><p>
*}

{/form}
