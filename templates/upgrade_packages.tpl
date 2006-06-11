<h3>Upgrading {$upgradeFrom} to {$smarty.const.BIT_MAJOR_VERSION}.{$smarty.const.BIT_MINOR_VERSION}.{$smarty.const.BIT_SUB_VERSION} {$smarty.const.BIT_LEVEL}</h3>

{form legend="Begin the upgrade process"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		{formlabel label="Upgrade Application" for="db"}
		{forminput}
			{if $smarty.session.upgrade_r1}
				<input type="hidden" name="upgrade_from" value="BWR1" />
				bitweaver <strong>ReleaseOne</strong> &nbsp; <em>-R1-</em>
			{else}
				<select name="upgrade_from">
					<optgroup label="bitweaver">
						<option value="BWR0">bitweaver ReleaseZero -BONNIE-</option>
						<option value="BWR1">bitweaver ReleaseOne -R1-</option>
					</optgroup>
					<optgroup label="TikiWiki">
						<option value="TikiWiki 1.8">TikiWiki 1.8</option>
						<option value="TikiWiki 1.9">TikiWiki 1.9</option>
					</optgroup>
				</select>
			{/if}
			<br />to
			<br />bitweaver <strong>ReleaseTwo</strong> &nbsp; <em>-R2-</em>
			{formhelp note="The type of application you intend to upgrade"}
		{/forminput}
	</div>

	{if $smarty.session.upgrade_r1}
		<p>The following packages will be updated</p>
		<ul>
			{foreach from=$upgrading item=package}
				<li>{$package}</li>
			{/foreach}
		</ul>
	{/if}

	<div class="row submit">
		<input type="submit" name="upgrade" value="Upgrade Packages" />
	</div>

	<div class="row">
		{forminput}
			<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
			{formhelp note="This will display SQL statements."}
		{/forminput}
	</div>
{/form}
