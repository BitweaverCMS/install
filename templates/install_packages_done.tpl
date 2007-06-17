<h1>Package Installation</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	{if $failedcommands or $error}
		{if $error}
			<div class="row">
				<ul class="result">
					<li class="error">
						{biticon ipackage="icons" iname="dialog-error" iexplain=error}
						There was a problem during the installation
					</li>
					<li>
						It seems the administrators information got lost during the process. Please go back to the admin setup page and enter the information again and follow through with the installation.<br />
						Please <strong>don't use the back button</strong>.
					</li>
				</ul>
			</div>
		{/if}
		{if $failedcommands}
			<div class="row">
				<h2 class="warning">
					{biticon ipackage="icons" iname="dialog-error" iexplain=error}
					The following database operations failed
				</h2>
				{section loop=$failedcommands name=idx}<p class="error">{$errors[idx]|escape}:<br/>&nbsp;&nbsp;&nbsp;&nbsp;{$failedcommands[idx]|escape}</p>{/section}
				<h3>Some errors occured. Your site may not be ready to run. You can revisit the previous page to rerun the installation.</h3>
			</div>
		{/if}
	{else}
		<div class="row">
			<ul class="result">
				<li class="success">
					{biticon ipackage="icons" iname="dialog-ok" iexplain=success}
					All Database operations completed succesfully
				</li>
			</ul>
		</div>

		{if !$first_install}
			<div class="row">
				<ul class="result">
					<li class="warning">
						{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
						You have just successfully installed new packages.
						During installation, new permissions were probably
						added to the database, but not assigned to any groups.
						You can use the <strong>{smartlink ititle="permission
						maintenance" ipackage=users ifile=admin/permissions.php}
						</strong> page to assign these permissions quickly and
						easily.
					</li>
				</ul>
			</div>
		{/if}

		{if $packageList.install}
			<div class="row">
				{formlabel label="Packages that were installed"}
				{forminput}
					<ul>
						{foreach from=$packageList.install item=package}
							<li>{$package}</li>
						{foreachelse}
							<li>No packages were installed<li>
						{/foreach}
					</ul>
				{/forminput}
			</div>
		{/if}

		{if $packageList.uninstall}
			<div class="row">
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
			<div class="row">
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

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
