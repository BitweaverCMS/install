<h1>Package Installation</h1>

{form class="form-horizontal" legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	{if $failedcommands or $error}
		{if $error}
			<div class="alert alert-danger">
				<p>There was a problem during the installation</p>
				<p>
					It seems the administrators information got lost during the process. Please go back to the admin setup page and enter the information again and follow through with the installation.<br />
					Please <strong>don't use the back button</strong>.
				</p>
			</div>
		{/if}
		{if $failedcommands}
			<div class="alert alert-danger">
				<h2 class="warning">
					The following database operations failed
				</h2>
				{section loop=$failedcommands name=idx}<p class="">{$errors[idx]|escape}:<br/>&nbsp;&nbsp;&nbsp;&nbsp;{$failedcommands[idx]|escape}</p>{/section}
				<h3>Some errors occured. Your site may not be ready to run. You can revisit the previous page to rerun the installation.</h3>
			</div>
		{/if}
	{else}
		<div class="alert alert-success">
			All Database operations completed succesfully
		</div>

		{if !$first_install}
			<div class="alert alert-warning">
				You have just successfully installed new packages.  During installation, new permissions were probably added to the database, but not assigned to any groups.  You can use the <strong>{smartlink ititle="permission maintenance" ipackage=users ifile='admin/permissions.php'} </strong> page to assign these permissions quickly and easily.
			</div>
		{/if}

		{if $packageList.install}
			<h2>Packages that were installed</h2>
			<ul>
				{foreach from=$packageList.install item=package}
					<li>{$package}</li>
				{foreachelse}
					<li>No packages were installed<li>
				{/foreach}
			</ul>
		{/if}

		{if $packageList.uninstall}
			<div class="form-group">
				{formlabel label="Packages that were uninstalled"}
				{forminput}
					<ul>
						{foreach from=$packageList.uninstall item=package}
							<li>{$package}</li>
						{foreachelse}
							<li>No packages were uninstalled<li>
						{/foreach}
					</ul>
				{/forminput}
			</div>
		{/if}

		{if $packageList.reinstall}
			<div class="form-group">
				{formlabel label="Packages that were reinstalled"}
				{forminput}
					<ul>
						{foreach from=$packageList.reinstall item=package}
							<li>{$package}</li>
						{foreachelse}
							<li>No packages were reinstalled<li>
						{/foreach}
					</ul>
				{/forminput}
			</div>
		{/if}
	{/if}

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Continue install process" />
		{/forminput}
	</div>
{/form}
