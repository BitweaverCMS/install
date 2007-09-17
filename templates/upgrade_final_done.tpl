<h1>Upgrade Process Completed</h1>
{form legend="Select what you want to do next"}
	<p>
		Go back to the installer to <strong>install additional
			packages</strong> that have become available by upgrading. It will
		also allow you to uninstall unwanted packages. After selecting
		additional packages, your system will automatically be analysed for
		potential problems.
	</p>
	<div class="row submit">
		<input type="hidden" name="step" value="{$next_step}" />
		<input type="submit" name="continue_install" value="Install more Packages" />
	</div>

	<hr />

	<p>
		Due to the large number of changes that have been made, there might be
		permissions and other minor issues that need to be fixed. You can
		return to the installer to let us analyse your bitweaver install and
		try to <strong>resole conflicts</strong>. We will inform you what steps
		need to be taken to fix these. This option is recommneded since it will
		inform you of the health of your install.
	</p>
	<div class="row submit">
		<input type="submit" name="resolve_conflicts" value="Resolve Conflicts" />
	</div>

	<hr />

	<p>
		We recommend that you try to resolve conflicts now but if you can't
		wait to see if your website is still working, you can enter your
		bitweaver site now. You can return to the installer at any time to
		resolve potential issues and insert missing permissions and settings.
	</p>
	<div class="row submit">
		<input type="submit" name="enter_bitweaver" value="Enter bitweaver" />
	</div>
{/form}
