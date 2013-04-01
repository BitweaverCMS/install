<h1>Bitweaver version update</h1>

{form legend="Bitweaver version update"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="success">
		Your version of bitweaver is now up to date and you can enter your site again.
	</p>

	{if $version_210beta}
		<p class="success">
			You have successfully modified the permissions of bitweaver.
		</p>
	{/if}

	<div class="control-group submit">
		<input type="submit" value="Continue install process" />
	</div>
{/form}
