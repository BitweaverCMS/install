<h1>Deactivated Packages</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p class="success">
		{biticon ipackage=liberty iname=success iexplain=success}
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
