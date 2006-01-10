<h1>Deactivated Packages</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			<li class="success">
				{biticon ipackage=liberty iname=success iexplain=success}
				bitweaver was successfully updated
			</li>
		</ul>
	</div>

	{if $fixedPermissions}
		<div class="row">
			{formlabel label="Permissions that were updated"}
			{forminput}
				{foreach from=$fixedPermissions item=perm}
					{formfeedback note="<strong>`$perm.0`</strong>:<br />`$perm.1`"}
				{/foreach}
			{/forminput}
		</div>
	{/if}

	{if $deActivated}
		<div class="row">
			{formlabel label="Packages that were deactivated"}
			{forminput}
				{foreach from=$deActivated item=package}
					{formfeedback note=$package}
				{/foreach}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
