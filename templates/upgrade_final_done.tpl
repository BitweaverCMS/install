<h1>Upgrade Process Completed</h1>
{form legend="Select what you want to do next"}
	<p>
		Go back to the installer to install additional packages that were not part of this upgrade.<br />
		Returning to the installer is generally a good idea, even if you don't want to install additional packages. it allows you to resolve potential problems and will insert missing permissions and settings into your database.
	</p>
	<div class="row submit">
		<input type="hidden" name="step" value="{$next_step}" />
		<input type="submit" name="continue_install" value="Return to Installer" />
	</div>

	<hr />

	<p>
		Enter your bitweaver site now to see if the upgrade process was successful.<br />
		You can return to the installer at any time to resolve potential issues and insert missing permissions and settings.
	</p>
	<div class="row submit">
		<input type="submit" name="enter_bitweaver" value="Enter bitweaver" />
	</div>
{/form}
