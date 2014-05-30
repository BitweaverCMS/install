<h1>Upgrade Packages</h1>

{jstabs tab=0}
	{jstab title="Available Upgrades"}
		{form id="package_select" legend="Packages that will be upgraded" id="package_select"}
			<input type="hidden" name="step" value="{$next_step}" />

			{if $packageUpgrades}
				<h2>Packages and their upgrades</h2>
				<div class="alert alert-danger"><div class="pull-left"><i class="icon-warning-sign" style="font-size:3em;padding-right:20px;"></i></div> You are about to run an upgrade which might make changes to your database. We <strong>strongly</strong> recommend that you back up your database (preferably carry out the entire <a class="external" href="http://www.bitweaver.org/wiki/bitweaverUpgrade#Generalproceduretoupgrade">backup procedure</a>).</div>
				{foreach from=$packageUpgrades item=upgrade key=package}
					{* users don't have the option to select what packages to upgrade since the code of the package is dependent on this upgrade
					<h3><label class="checkbox"><input type="checkbox" name="packages[]" value="{$package}" checked="checked" /> {$package}</label></h3> *}

					<h3>{$package}</h3>
					<input type="hidden" name="packages[]" value="{$package}" />
					<dl>
						<dt>{$gBitSystem->getVersion($package)}</dt>
						<dd><small>Currently installed version</small></dd>
						{foreach from=$upgrade item=data key=version}
							<dt>{$data.version}</dt>
							<dd>{$data.description}</dd>
							{if $errors.$package.$version}
								<p class="alert alert-danger">SQL errors that occurred during the {$version} upgrade:<br />
									<kbd>
										{if $errors.$package.$version.failedcommands}
											{foreach from=$errors.$package.$version.failedcommands item=command}
												{$command}<br />
											{/foreach}
										{/if}
									</kbd>
								</p>
							{/if}
						{/foreach}
					</dl>
				{/foreach}

				{if $errors}
					<p class="danger">The upgrade process was halted due to the SQL problems listed above. Please contact the bitweaver team to fix this issue.</p>
				{/if}
			{elseif !$success}
				<p class="alert alert-success">Seems all installed packages are up to date!</p>
			{/if}

			{if $success}
				<h2>Post Install Notes</h2>
				<p class="alert alert-success">Some packages were successfully updated which might have important post upgrade notes.</p>
				<dl>
					{foreach from=$success item=upgrade key=package}
						{foreach from=$upgrade item=data key=version}
							{if $data.post_upgrade}
								<dt>{$package}</dt>
								<dd>
									Upgrade &rarr; {$version}<br />
									<strong>Post install notes</strong><br />
									{$data.post_upgrade}
								</dd>
							{/if}
						{/foreach}
					{/foreach}
				</dl>
			{/if}

			{if $requirementsMap}
				<h2>Requirements Graph</h2>
				<p class="help">Below you will find an illustration of how packages will depend on each other after the upgrade has been completed.</p>
				<div style="text-align:center; overflow:auto;">
					<img alt="A graphical representation of package requirements" title="Requirements graph" src="{$smarty.const.KERNEL_PKG_URL}requirements_graph.php?format={$smarty.request.format}&amp;command={$smarty.request.command}" usemap="#Requirements" />
					{$requirementsMap}
				</div>
			{/if}

			{if $requirements}
				<h2>Requirements Table</h2>
				<p class="help">Below you will find a detailed table with package requirements after the upgrade has completed successfully. If not all package requirements are met, consider trying to meet all package requirements. If you don't meet them, you may continue at your own peril.</p>
				<table id="requirements">
					<caption>Package Requirements</caption>
					<tr>
						<th style="width:16%;">Requirement</th>
						<th style="width:16%;">Min Version</th>
						<th style="width:16%;">Max Version</th>
						<th style="width:16%;">Available</th>
						<th style="width:36%;">Result</th>
					</tr>
					{foreach from=$requirements item=dep}
						{if $pkg != $dep.package}
							<tr><th colspan="5">{$dep.package|ucfirst} requirements</th></tr>
							{assign var=pkg value=$dep.package}
						{/if}

						{if $dep.result == 'ok'}
							{assign var=class value=success}
						{elseif $dep.result == 'missing'}
							{assign var=class value=error}
						{elseif $dep.result == 'min_dep'}
							{assign var=class value=error}
						{else}
							{assign var=class value=warning}
						{/if}

						<tr class="{$class}">
							<td>{$dep.requires|ucfirst}</td>
							<td>{$dep.required_version.min}</td>
							<td>{$dep.required_version.max}</td>
							<td>{$dep.version.available}</td>
							<td>
								{if $dep.result == 'ok'}
									OK
								{elseif $dep.result == 'missing'}
									Package missing
									{assign var=missing value=true}
								{elseif $dep.result == 'min_dep'}
									Minimum version not met
									{assign var=min_dep value=true}
								{elseif $dep.result == 'max_dep'}
									Maximum version exceeded
									{assign var=max_dep value=true}
								{elseif $dep.result == 'inactive'}
									Package disabled
									{assign var=inactive value=true}
								{else}
									Unknown state
									{assign var=confused value=true}
								{/if}
							</td>
						</tr>
					{/foreach}
				</table>

				{if $missing}
					<p class="alert alert-block">At least one required package is missing. Please install that package before proceeding with the upgrade.</p>
				{/if}

				{if $min_dep}
					<p class="alert alert-block">At least one package did not meet the minimum version requirement in our calculations. If possible, please get a newer version of those packages and upgrade them as well.</p>
				{/if}

				{if $max_dep}
					<p class="alert alert-block">At least one package recommend a version lower to the one you have installed or are about to upgrade to. The package you wish to upgrade might work with this combination, but no guarantees can be given.</p>
				{/if}

				{if $inactive}
					<p class="alert alert-block">At least one required package is disabled. Please activate that package once your install is complete.</p>
				{/if}

				{if $confused}
					<p class="alert alert-block">At least one required package is in an unknown state. The upgrade may not work because of this. It is probably worth reinstalling the latest version of that package or contacting its developer.</p>
				{/if}

				{if !$min_dep && !$max_dep && !$missing}
					<p class="alert alert-success">All package requirements have been met. You can proceed with the installation process.</p>
				{/if}
			{/if}

			<div class="control-group">
				{forminput}
					<label class="checkbox"><input type="checkbox" name="debug" value="true" /> Debug mode</label>
					{formhelp note="Display SQL statements."}
				{/forminput}
			</div>

			<div class="control-group">
				{forminput}
					<input type="submit" class="btn btn-primary" name="upgrade_packages" value="Upgrade Packages" />
				{/forminput}
			</div>
		{/form}
	{/jstab}

	{jstab title="Installed Packages"}
		{legend legend="Already Installed Packages"}
			{foreach from=$schema key=package item=item}
				{if $item.installed}
					<div class="control-group">
						<div class="formlabel">
							<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=$package}</label>
						</div>
						{forminput}
							<strong>{$package|capitalize}</strong>
							{formhelp note=$item.info}
							{formhelp note="<strong>Location</strong>: `$item.url`"}
							{formhelp package=$package}
						{/forminput}
					</div>
				{/if}
			{/foreach}
		{/legend}
	{/jstab}
{/jstabs}
