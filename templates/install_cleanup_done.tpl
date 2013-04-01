<h1>Resolved Conflicts</h1>

{form class="form-horizontal" legend="Resolved Conflicts"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="alert alert-success">
		Bitweaver was successfully updated
	</p>

	{if $fixedPermissions}
		<div class="control-group">
			{formlabel label="Updated Permissions"}
			{forminput}
				<ul id="fixedpermlist">
					{foreach from=$fixedPermissions item=perm}
						<li><strong>{$perm.0}</strong>: {$perm.1}<li>
					{/foreach}
				</ul>
			{/forminput}
		</div>

		<p>Since permissions have been modified, you should visit the
			{smartlink ititle="permission maintenance" ipackage=users
			ifile=admin/permissions.php} page to make sure that all permissions
			are assigned to the correct groups.</p>
	{/if}

	{if $deActivated}
		<div class="control-group">
			{formlabel label="Deactivated Packages"}
			{forminput}
				<ul>
					{foreach from=$deActivated item=package}
						<li>{$package}<li>
					{/foreach}
				</ul>
			{/forminput}
		</div>
	{/if}

	<div class="control-group">
		{forminput}
			<input type="submit" class="btn" value="Continue install process" />
		{/forminput}
	</div>
{/form}
