<h1>Bitweaver version update</h1>

{form class="form-horizontal" legend="Bitweaver version update"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="alert alert-success">
		Your version of bitweaver is now up to date and you can enter your site again.
	</p>

	{if $version_210beta}
		<p class="alert alert-success">
			You have successfully modified the permissions of bitweaver.
		</p>
	{/if}

	<div class="control-group">
		{forminput}
			<input type="submit" class="btn" value="Continue install process" />
		{/forminput}
	</div>
{/form}
