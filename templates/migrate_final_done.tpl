<h1>Upgrade Process Completed</h1>
{form legend="Select what you want to do next"}
	<p>Go back to the installer to install additional packages that were not part of this migrate.</p>
	<div class="control-group column-group gutters">
		{forminput}
			<input type="hidden" name="step" value="{$next_step}" />
		{/forminput}
		<input type="submit" class="ink-button" name="continue_install" value="Return to Installer" />
	</div>

	<hr />

	<p>Enter your Bitweaver site now to see if the migrate process was successful.</p>
	<div class="control-group column-group gutters">
		{forminput}
			<input type="submit" class="ink-button" name="enter_bitweaver" value="Enter site" />
		{/forminput}
	</div>
{/form}
