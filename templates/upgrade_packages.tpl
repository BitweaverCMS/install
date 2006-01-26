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
				<option value="TikiWiki 1.8">TikiWiki 1.8</option>
				<option value="TikiWiki 1.9">TikiWiki 1.9</option>
				<option value="BWR0">bitweaver ReleaseZero -BONNIE-</option>
				{formhelp note="The type of application you intend to upgrade"}
			</select>
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
