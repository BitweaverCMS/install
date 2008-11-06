<h1>Resolved Conflicts</h1>

{form legend="Resolved Conflicts"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="success">
		Bitweaver was successfully updated
	</p>

	{if $fixedPermissions}
		<div class="row">
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
		<div class="row">
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

	<div class="row submit">
		<input type="submit" value="Continue install process" />
	</div>
{/form}