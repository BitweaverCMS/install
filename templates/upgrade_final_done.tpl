<h1>Upgrade Process Completed</h1>
{form legend="Select what you want to do next"}
	<p>
		Go back to the installer to <strong>install additional
			packages</strong> that have become available by upgrading. It will
		also allow you to uninstall unwanted packages. After selecting
		additional packages, your system will automatically be analysed for
		potential problems.
	</p>
	<div class="form-group">
		{forminput}
			<input type="hidden" name="step" value="{$next_step}" />
		{/forminput}
		<input type="submit" class="btn btn-default" name="continue_install" value="Install more packages" />
	</div>

	<hr />

	<p>
		Due to the large number of changes that have been made, there might be
		permissions and other minor issues that need to be fixed. You can
		return to the installer to let Bitweaver analyse your install and
		try to <strong>resolve conflicts</strong>. This option is recommended. It will
		inform you of the health of your install.
	</p>
	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-default" name="resolve_conflicts" value="Resolve Conflicts" />
		{/forminput}
	</div>

	<hr />

	<p>
		It's recommended to resolve conflicts now, but if you want to see if your website is still working, you can enter your
		Bitweaver now. You can return to the installer at any time to
		resolve potential issues and insert missing permissions and settings.
	</p>
	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-default" name="enter_bitweaver" value="Enter Bitweaver" />
		{/forminput}
	</div>
{/form}
