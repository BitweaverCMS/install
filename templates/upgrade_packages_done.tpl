<h1>Package Upgrade</h1>

{form class="form-horizontal" legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	{if $failedcommands}
		<div class="control-group">
			<h3>The following database operations failed</h3>
			<textarea rows="20" cols="50">{section loop=$failedcommands name=ix}{$failedcommands[ix]}{/section}</textarea>
			<h4>Some errors occured. Your site may not be ready to run. You can revisit the previous page to rerun the installation.</h4>
		</div>
	{else}
		<div class="control-group">
			<ul class="result">
				<li class="success">
					All Database operations completed succesfully
				</li>
			</ul>
		</div>

		<div class="control-group">
			{formlabel label="Packages that were upgraded"}
			{forminput}
				<ul>
					{foreach from=$package_list item=package}
						<li>{$package}</li>
					{/foreach}
				</ul>
			{/forminput}
		</div>
	{/if}

	<div class="control-group">
		{forminput}
			<input type="submit" class="btn btn-default" value="Continue upgrade process" />
		{/forminput}
	</div>
{/form}
