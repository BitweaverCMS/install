<h1>Package Installation</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	{if $failedcommands or $error}
		{if $error}
			<div class="row">
				<ul class="result">
					<li class="error">
						{biticon ipackage=liberty iname=error iexplain=success}
						There was a problem during the installation
					</li>
					<li>
						It seems the administrators information got lost during the process. Please go back to the admin setup page and enter the information again and follow through with the installation.<br />
						Please <strong>don't use the back button</strong>.
					</li>
				</ul>
			</div>
		{/if}
		{if $failedcommands}
			<div class="row">
				<h2 class="warning">
					{biticon ipackage=liberty iname=error iexplain=success}
					The following database operations failed
				</h2>
				<textarea rows="20" cols="80">{section loop=$failedcommands name=ix}{$failedcommands[ix]}{/section}</textarea>
				<h3>Some errors occured. Your site may not be ready to run. You can revisit the previous page to rerun the installation.</h3>
			</div>
		{/if}
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
