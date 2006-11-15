<h1>Deactivated Packages</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="success">
		{biticon ipackage="icons" iname="dialog-ok" iexplain=success}
		bitweaver was successfully updated
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

		<p>Since permissions have been modified, you should probably visit the <a href="{$smarty.const.USERS_PKG_URL}admin/unassigned_perms.php">Unassigned Permissions</a> page to make sure that all permissions are assigned to the correct groups.</p>
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
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
