{form legend="Begin the upgrade process"}
<h3>Upgrading {$upgradeFrom} to {$smarty.const.BIT_MAJOR_VERSION}.{$smarty.const.BIT_MINOR_VERSION}.{$smarty.const.BIT_SUB_VERSION} {$smarty.const.BIT_LEVEL}</h3>

<p>The following packages will be updated:

<ol>
{foreach from=$gBitSystem->mUpgrades key=pkg item=upHash }
<li>{$pkg}
{/foreach}
</ol>
</p>
	<div class="row">
		{formlabel label="Upgrade Application" for="db"}
		{forminput}
		<select name="upgrade_from">
			<option value="TikiWiki 1.8">TikiWiki 1.8</option>
			<option value="BONNIE">bitweaver 2.0 -BONNIE-</option>
		</select>
			{formhelp note="The type of application you intend to upgrade"}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Debug mode" for="debug"}
		{forminput}
			<input type="checkbox" name="debug" id="debug" value="true" />
		{/forminput}
		{formhelp note="This will display SQL statements."}
	</div>

	<div class="row submit">
		<input type="submit" name="upgrade" value="Upgrade Packages" />
	</div>


{/form}
