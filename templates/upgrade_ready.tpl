{form legend="Begin the upgrade process"}
	<h3>Upgrading {$upgradeFrom} to {$gBitSystem->getBitVersion()}</h3>

	<p>The following packages will be updated: </p>

	<ol>
		{foreach from=$gBitSystem->mUpgrades key=pkg item=upHash }
			<li>{$pkg}</li>
		{/foreach}
	</ol>

	<div class="form-group">
		{formlabel label="Upgrade Application" for="db"}
		{forminput}
			<select name="upgrade_from">
				<option value="TikiWiki 1.8">TikiWiki 1.8</option>
				<option value="TikiWiki 1.9">TikiWiki 1.9</option>
				<option value="BWR0">Bitweaver ReleaseZero -BONNIE-</option>
			</select>
			{formhelp note="The type of application you intend to upgrade"}
		{/forminput}
	</div>

	<div class="form-group">
		{forminput}
			<label class="checkbox"><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
		{/forminput}
		{formhelp note="Display SQL statements."}
	</div>

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-default" name="upgrade" value="Upgrade Packages" />
		{/forminput}
	</div>
{/form}
