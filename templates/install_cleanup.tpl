<h1>Package Conflicts</h1>

<p>
	{biticon ipackage=liberty iname=info iexplain=Information}
	This page allows you to fix some basic setup problems.
</p>

{form}
	<input type="hidden" name="step" value="{$next_step}" />
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
				{biticon ipackage=liberty iname=success iexplain=success}
				The permissioning system in your installation is up to date and does not require any adjustments.
			</p>
		{/if}
	{/legend}
	<br /> <br />

	{legend legend="Resolve Service Conflicts"}
		{if $serviceList}
			<p class="warning">
				{biticon ipackage=liberty iname=warning iexplain=warning}
				We have noticed that you have activated multiple packages of the same service type.
				A service package is a package that allows you to extend the way you display bitweaver content - such as <em>categorising your content</em>.
				<br />
				The site should still be fully functional, however, there might be some minor problems such as display of the wrong menus and overlapping functionality.
				We therefore recommend that you enable only one of each service type.
			</p>

			<p>
				You can change your selection at a later time point by modifying the settings in the packages administration screen.
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
				{biticon ipackage=liberty iname=success iexplain=success}
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
