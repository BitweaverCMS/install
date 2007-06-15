<h1>Database Options</h1>

{form legend="Installation Options"}
	<input type="hidden" name="step" value="{$next_step}" />

	<h2>Continue Installation</h2>
	<p>Select this option if this is your first installation of bitweaver.</p>

	<div class="row submit">
		<input type="submit" name="continue_install" value="Continue Install Process" />
	</div>

	<hr />

	<h2>Upgrade bitweaver Release 1</h2>

	<p>If you have an existing version 1 of bitweaver installed and would like
		to upgrade to version 2, please use the upgrader.</p>

	<p class="warning">This path will only work for upgrading bitweaver release
		one to release two. if you want to upgrade from previous versions or
		from other applications such as tikiwiki, please use the option
		below.</p>

	<div class="row submit">
		<input type="submit" name="upgrade_r1" value="Upgrade bitweaver" />
	</div>

	<hr />

	<h2>Upgrade an Existing Database</h2>
	<p>Choosing this path will allow you to upgrade your database from an
		application like TikiWiki to a bitweaver database. You will be brought
		back to the installer once the upgrade process has been completed.</p>

	<div class="row submit">
		<input type="submit" name="upgrade" value="Upgrade an existing Database" />
	</div>

	<hr />

	<h2>Migrate a Database</h2>
	<p>If you wish to migrate a database from one database source to another,
		such as from MySQL to PostgreSQL, please select this option. You will
		be brought back to the installer once the upgrade process has been
		completed.</p>

	<p class="warning">This feature is currently not working. It was working
		once and needs some attention since it hasn't been updated in a while.
		If you know some PHP, please help us out if you are interested in this
		feature.<p>

	<div class="row submit">
		<input type="submit" name="migrate" value="Migrate a Database" />
	</div>
{/form}
