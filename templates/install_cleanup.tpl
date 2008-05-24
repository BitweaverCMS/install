<h1>Bitweaver integrity check</h1>

<p>
	{biticon ipackage="icons" iname="dialog-information" iexplain=Information}
	This page allows you to fix some basic setup problems.
</p>

{form}
	<input type="hidden" name="step" value="{$next_step}" />
	{legend legend="Database Integrity Check"}
		{if $metaTables}
			<p class="warning">
				{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
				We have scanned the database and have found some outdated tables.
				We will update these to the latest set of tables.
				If you wish to upgrade the tables by hand, please visit the
				<a class="external" href="http://www.bitweaver.org/wiki/SchemaChangelog">SchemaChangelog</a>
				and apply the new schema from the 23-MAY-2008.
			</p>
			<ul>
				{foreach from=$metaTables key=type item=tables}
					<li>
						{$type}
						<ul>
							{foreach from=$tables item=table}
								<li>{$table}</li>
							{/foreach}
						</ul>
					</li>
				{/foreach}
			</ul>

			<div class="row submit">
				<input type="submit" name="update_tables" value="Update old meta table(s)" />
			</div>

			<div class="row">
				{forminput}
					<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
					{formhelp note="This will display SQL statements."}
				{/forminput}
			</div>
		{elseif $dbIntegrity}
			<p class="warning">
				{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
				We have scanned the database for missing tables and have found that the following tables have not been installed:
			</p>
			<ul>
				{foreach from=$dbIntegrity item=package}
					<li>
						<strong>{$package.name}</strong>
						<small>
							{if $package.required}
								[<strong>required package</strong>]
								{assign var=required value=1}
							{else}
								[optional package]
								{assign var=optional value=1}
							{/if}
						</small>
						<ul>
							{foreach from=$package.tables item=table}
								<li>
									<a style="float:right" href="#" onclick="flip('{$table.name}');return false">show table details</a> {$table.name}<br />
									<div id="{$table.name}" style="display:none;">
										<code>{$table.sql|nl2br}</code>
									</div>
								</li>
							{/foreach}
						</ul>
					</li>
				{/foreach}
			</ul>
			<p>If you know SQL, you can display the table details and try to create such a table in your database and reload this page. This check merely checks the existence of a given table, not the table columns.</p>
			{if $required}
				<p class="error">
					{biticon ipackage="icons" iname="dialog-error" iexplain=error}
					A required package is missing at least one table. This will have unpredictable results. Please make a note of the table and contact the bitweaver team on how to proceed.
					If this is your first install, we recommend that you give it another shot, perhaps with fewer packages selected. You can return to the installer at any time and install more packages later.
					<br />If this problem persists, we recommend that you turn on the <strong>debugging</strong> option and look for error messages regarding the above table(s). This will help the bitweaver team identify the problem more quickly when you contact them.
				</p>
			{/if}
			{if $optional}
				<p class="warning">
					{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
					One of the optional packages you have selected for
					installation has not installed one of its tables. This will
					probably render the package useless.  You can try
					installing this package again by revisiting the
					<a href="{$smarty.const.INSTALL_PKG_URL}install.php?step={$smarty.request.step-1}">Package installation</a>
					page.  <br />If this problem persists, we recommend that
					you turn on the <strong>debugging</strong> option and look
					for error messages regarding the above table(s). This will
					help the bitweaver team identify the problem more quickly
					when you contact them.
				</p>
			{/if}

			<div class="row submit">
				<input type="submit" name="create_tables" value="Try to create missing table(s)" />
			</div>

			<div class="row">
				{forminput}
					<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
					{formhelp note="This will display SQL statements."}
				{/forminput}
			</div>
		{else}
			<p class="success">
				{biticon ipackage="icons" iname="dialog-ok" iexplain=success}
				Database integrity has been confirmed by scanning all available tables in your database and comparing them to the ones that should be present.
			</p>
		{/if}
	{/legend}
	<br /> <br />

	{legend legend="Fix Permissioning"}
		{if $delPerms || $insPerms}
			<p class="warning">
				Please select the permissions you wish to update.
			</p>

			<table class="data">
				<caption>Permissions that need amending</caption>
				{if $insPerms}
					<tr><th colspan="5">New Permissions</th></tr>
					<tr>
						<th></th>
						<th>Permission</th>
						<th>Description</th>
						<th>Level</th>
						<th>Package</th>
					</tr>
					{foreach from=$insPerms item=perm}
						<tr class="{cycle values="odd,even"}">
							<td><input type="checkbox" value="{$perm.0}" id="{$perm.0}" name="perms[{$perm.0}]" checked="checked" /></td>
							<td><label for="{$perm.0}"><strong>{$perm.0}</strong></label></td>
							<td><label for="{$perm.0}">{$perm.1}</label></td>
							<td><label for="{$perm.0}">{$perm.2}</label></td>
							<td><label for="{$perm.0}">{$perm.3}</label></td>
						</tr>
					{/foreach}
				{/if}

				{if $delPerms}
					<tr><th colspan="5">Permissions no longer in use</th></tr>
					<tr>
						<th></th>
						<th>Permission</th>
						<th>Description</th>
						<th>Level</th>
						<th>Package</th>
					</tr>
					{foreach from=$delPerms item=perm}
						<tr class="{cycle values="odd,even"}">
							<td><input type="checkbox" value="{$perm.0}" id="{$perm.0}" name="perms[{$perm.0}]" checked="checked" /></td>
							<td><label for="{$perm.0}"><strong>{$perm.0}</strong></label></td>
							<td><label for="{$perm.0}">{$perm.1}</label></td>
							<td><label for="{$perm.0}">{$perm.2}</label></td>
							<td><label for="{$perm.0}">{$perm.3}</label></td>
						</tr>
					{/foreach}
				{/if}
			</table>
		{else}
			<p class="success">
				{biticon ipackage="icons" iname="dialog-ok" iexplain=success}
				The permissioning system in your installation is up to date and
				does not require any adjustments. Even though this is true, we
				recommend you visit the {smartlink ititle="Permission
				Maintenance" ipackage=users ifile=admin/permissions.php} page
				at some point to ensure that all permissions are active.
			</p>
		{/if}
	{/legend}
	<br /> <br />

	{legend legend="Resolve Service Conflicts"}
		{if $serviceList}
			<p class="warning">
				{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
				We have noticed that you have activated multiple packages of
				the same service type.  A service package is a package that
				allows you to extend the way you display bitweaver content -
				such as <em>categorising your content</em>.  <br /> The site
				should still be fully functional, however, there might be some
				minor problems such as display of the wrong menus and
				overlapping functionality.  We therefore recommend that you
				enable only one of each service type.
			</p>

			<p>
				You can change your selection at a later time point by
				modifying the settings in the packages administration screen.
			</p>

			{foreach from=$serviceList key=service_name item=packages}
				<h3>{$service_name|capitalize}</h3>
				{foreach from=$packages key=package item=item}
					<div class="row">
						<div class="formlabel">
							<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
						</div>
						{forminput}
							<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" checked="checked" /> {$package|capitalize}</label>
							{formhelp note=`$schema.$package.info`}
							{formhelp note="<strong>Location</strong>: `$schema.$package.url`"}
							{formhelp package=$package}
						{/forminput}
					</div>
				{/foreach}
				<div class="clear"></div>
			{/foreach}
		{else}
			<p class="success">
				{biticon ipackage="icons" iname="dialog-ok" iexplain=success}
				None of the packages you have installed are causing any problems.
			</p>
		{/if}

		{if $delPerms || $insPerms || $serviceList}
			<div class="row submit">
				<input type="submit" name="resolve_conflicts" value="Resolve Issues" />
			</div>

			<div class="row">
				{forminput}
					<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
					{formhelp note="This will display SQL statements."}
				{/forminput}
			</div>
		{else}
			<div class="row submit">
				<input type="submit" name="skip" value="Continue Install Process" />
			</div>
		{/if}
	{/legend}
{/form}
