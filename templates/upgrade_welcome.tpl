<h1>Bitweaver upgrade tool</h1>

{form class="form-horizontal" legend="Begin the upgrade process"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>
		Welcome to the new and improved Bitweaver package manager. Using this
		package manager will allow you to download packages from our central
		repository and apply the install or upgrade process easily. We have 
		done our best to make sure all situations are handled. However,
		your install might have the one case we haven't run into yet. 
		Initial steps before beginning the actual upgrade stages:
	</p>
	<p class="warning">
		<strong>Make a Backup</strong><br />
		You should have a spare dump of your database before you run this. (Of
		course, you already have a cron job making nightly backups and
		scp'ing them to another host? Right? Right.)
	</p>
	<p class="warning">
		<strong>Do a trial run first</strong><br />
		You should run a trial upgrade on an offline server, personal machine,
		etc. before you do this on your live site.
	</p>
	{if $max_execution_time}
		<p class="warning">
			<strong>Upgrades can take a long time. </strong> 
			We tried to override the max_execution_time setting in your php.ini
			to ensure enough time but on some systems this does not work. If
			you get a blank page with a non-functional site as a result, the
			execution time might be the reason.<br />
			The value we are trying to set max_execution_time to is 86400.
			However, your value of {$max_execution_time} cannot be overridden
			on your system. If you run into problems with the upgrade process
			and you think this might be problem, please consult the
			<a class="external" href="http://us2.php.net/manual/en/ref.info.php#ini.max-execution-time">PHP manual</a>
			on how to change the value.
		</p>
	{/if}
	{if $dbWarning}
		<p class="warning">
			{$dbWarning}
		</p>
	{/if}

	{if $smarty.session.upgrade_r1}
		<h2>Important</h2>
		<p class="danger">
			Since you are upgrading from Bitweaver version 1 to version 2, please visit the
			<strong><a class="external" href="http://www.bitweaver.org/wiki/bitweaver+R1+to+R2+Upgrade">Upgrade documentation page</a></strong>.
			It contains <strong>crucial information</strong> about the
			changes that have occurred and how to fix certain upgrade issues
			that can not be dealt with by the installer. We can not stress
			enough that it is <strong>essential</strong> that you make a backup
			of your files and your database before attempting this upgrade.
		</p>
	{/if}

	<div class="control-group">
		{forminput}
			<input type="submit" class="btn" name="fSubmitWelcome" value="{$warningSubmit|default:"Begin the upgrade process!"}" />
		{/forminput}
	</div>
{/form}
