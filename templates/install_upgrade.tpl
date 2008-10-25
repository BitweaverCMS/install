<h1>Upgrade Packages</h1>

{jstabs tab=0}
	{jstab title="Available Upgrades"}
		{form id="package_select" legend="Please select packages you wish to upgrade" id="package_select"}
			<p class="danger">You are about to run an upgrade which might make changes to your database. We <strong>strongly</strong> recommend that you back up your database (preferably carry out the entire <a class="external" href="http://www.bitweaver.org/wiki/bitweaverUpgrade#Generalproceduretoupgrade">backup procedure</a>).</p>
			<input type="hidden" name="step" value="{$next_step}" />
			{foreach from=$packageUpgrades item=upgrade key=package}
				<h3><label><input type="checkbox" name="packages[]" value="{$package}" checked="checked" /> {$package}</label></h3>
				<dl>
					<dt>{$gBitSystem->getVersion($package)}</dt>
					<dd>This is the currently installed version</dd>
					{foreach from=$upgrade item=data key=version}
						<dt>{$data.version}</dt>
						<dd>{$data.description}</dd>
						{if $errors.$package.$version}
							<p class="error">SQL errors that occurred during the {$version} upgrade:<br />
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

			{if $success}
				<h2>Post Install Notes</h2>
				<p class="success">Some packages were successfully updated which might have important post upgrade notes.</p>
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
								{assign var=upgrade_notes value=1}
							{/if}
						{/foreach}
					{/foreach}
				</dl>

				{if !$upgrade_notes}
					<p class="help">No package seems to have any important notes.</p>
				{/if}
			{/if}

			{if $errors}
				<hr />
				<p class="error">The upgrade process was halted due to the SQL problems listed above. Please contact the bitweaver team to fix this issue.</p>
			{/if}

			<div class="row submit">
				<input type="submit" name="upgrade_packages" value="Upgrade Packages" />
			</div>

			<div class="row">
				{forminput}
					<label><input type="checkbox" name="debug" value="true" /> Debug mode</label>
					{formhelp note="Display SQL statements."}
				{/forminput}
			</div>
		{/form}
	{/jstab}

	{jstab title="Installed Packages"}
		{legend legend="Already Installed Packages"}
			{foreach from=$schema key=package item=item}
				{if $item.installed}
					<div class="row">
						<div class="formlabel">
							<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
						</div>
						{forminput}
							<strong>{$package|capitalize}</strong>
							{formhelp note=`$item.info`}
							{formhelp note="<strong>Location</strong>: `$item.url`"}
							{formhelp package=$package}
						{/forminput}
					</div>
				{/if}
			{/foreach}
		{/legend}
	{/jstab}
{/jstabs}
