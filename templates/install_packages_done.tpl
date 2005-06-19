<h1>Package Installation</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	{if $failedcommands}
		<div class="row">
			<h3>The following database operations failed</h3>
			<textarea rows="20" cols="80">{section loop=$failedcommands name=ix}{$failedcommands[ix]}{/section}</textarea>
			<h4>Some errors occured. Your site may not be ready to run. You can revisit the previous page to rerun the installation.</h4>
		</div>
	{else}
		<div class="row">
			<ul class="result">
				<li class="success">
					{biticon ipackage=liberty iname=success iexplain=success}
					All Database operations completed succesfully
				</li>
			</ul>
		</div>

		<div class="row">
			{formlabel label="Packages that were installed"}
			{forminput}
				{foreach from=$package_list item=package}
					{formfeedback note=$package}
				{/foreach}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
