{strip}
<h1>Upgrade Clyde</h1>
<br />
{form}
	{legend legend="Upgrade from Beta 1 to Beta 2"}
		<input type="hidden" name="step" value="{$next_step}" />

		<p class="control-group">To upgrade CLYDE Beta 1 to CLYDE Beta 2, you need to upgrade your languages package.<br />We know we said we wouldn't make any rash schema changes, but we thought that since languages weren't working anyway, nobody could possibly loose data. We hope that this does not cause too great of a problem and we appologise for messing with the schema.<p>

		{foreach from=$schema key=package item=item}
			{if $item.tables || $item.defaults}
				{if $package eq 'languages'}
					<div class="control-group">
						<div class="formlabel">
							<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$item.name`}</label>
						</div>
						{forminput}
							<label><input type="checkbox" name="PACKAGE[]" value="{$package}" id="{$package}" checked="checked" /> {$item.name}</label>
							{formhelp note=`$item.info`}
							{formhelp note="<strong>Location</strong>: `$item.url`"}
							{formhelp package=$package}
						{/forminput}
					</div>
				{/if}
			{/if}
		{/foreach}
	{/legend}

	<div class="control-group submit">
		Please press this button only once<br />
		Depending on the number of packages and the hardware,<br />
		this process might take up to a few minutes.<br /><br />
		<input type="hidden" name="resetdb" value="{$resetdb}" />
		<input type="submit" name="fSubmitDbCreate" value="Install Packages" />
	</div>

	<div class="control-group">
		{forminput}
			<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
			{formhelp note="Display SQL statements."}
		{/forminput}
	</div>
{/form}
{/strip}
