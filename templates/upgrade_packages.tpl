<h3>Upgrading {$upgradeFrom} to {$smarty.const.BIT_MAJOR_VERSION}.{$smarty.const.BIT_MINOR_VERSION}.{$smarty.const.BIT_SUB_VERSION} {$smarty.const.BIT_LEVEL}</h3>

{* should be fixed at some point
<p>The following packages will be updated</p>

<ol>
	{foreach from=$gBitSystem->mUpgrades key=pkg item=upHash}
		<li>{$pkg}</li>
	{/foreach}
</ol>
*}

{form legend="Begin the upgrade process"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		{formlabel label="Upgrade Application" for="db"}
		{forminput}
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
			<br />to bitweaver <strong>ReleaseTwo</strong> -R2-
			{formhelp note="The type of application you intend to upgrade"}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Debug mode" for="debug"}
		{forminput}
			<input type="checkbox" name="debug" id="debug" value="true" />
			{formhelp note="This will display SQL statements."}
		{/forminput}
	</div>

	<div class="row submit">
		<input type="submit" name="upgrade" value="Upgrade Packages" />
	</div>
{/form}
