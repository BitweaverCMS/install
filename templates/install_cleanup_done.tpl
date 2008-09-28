<h1>Deactivated Packages</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="success">
		Bitweaver was successfully updated
	</p>

	{if $fixedPermissions}
		<div class="row">
			{formlabel label="Permissions that were updated"}
			{forminput}
				<ul>
					{foreach from=$fixedPermissions item=perm}
						<li><strong>{$perm.0}</strong>:<br />{$perm.1}<li>
					{/foreach}
				</ul>
			{/forminput}
		</div>

		<p>Since permissions have been modified, you should probably visit the
			{smartlink ititle="permission maintenance" ipackage=users
			ifile=admin/permissions.php} page to make sure that all permissions
			are assigned to the correct groups.</p>
	{/if}

	{if $deActivated}
		<div class="row">
			{formlabel label="Packages that were deactivated"}
			{forminput}
				<ul>
					{foreach from=$deActivated item=package}
						<li>{$package}<li>
					{/foreach}
				</ul>
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue install process" />
	</div>
{/form}
