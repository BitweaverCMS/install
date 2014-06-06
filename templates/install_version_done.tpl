<h1>Bitweaver version update</h1>

{form legend="Bitweaver version update"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="alert alert-success">
		Your version of bitweaver is now up to date and you can enter your site again.
	</p>

	{if $version_210beta}
		<p class="alert alert-success">
			You have successfully modified the permissions of bitweaver.
		</p>
	{/if}

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Continue install process" />
		{/forminput}
	</div>
{/form}
