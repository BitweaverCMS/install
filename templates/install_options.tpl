<h1>Database Options</h1>

{form legend="Installation Options"}
	<input type="hidden" name="step" value="{$next_step}" />

	<h2>Continue Installation</h2>
	<p>Select this option if this is your first installation of bitweaver.</p>

	<div class="row submit">
		<input type="submit" name="continue_install" value="Continue Install Process" />
	</div>

	<hr />

	<h2>Upgrade an Existing Database</h2>
	<p>if you wish to upgrade or convert an existing database to a bitweaver database, please select this option. You will be brought back to the installer once the upgrade process has been completed.</p>

	<div class="row submit">
		<input type="submit" name="upgrade" value="Upgrade an existing Database" />
	</div>

	<hr />

	<h2>Migrate a Database</h2>
	<p>if you wish to migrate a database from one database source to another, please select this option. You will be brought back to the installer once the upgrade process has been completed.</p>

	<div class="row submit">
		<input type="submit" name="migrate" value="Migrate a Database" />
	</div>
{/form}
