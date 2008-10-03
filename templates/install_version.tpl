<h1>Bitweaver version update</h1>

{form id="integrity_check"}
	<input type="hidden" name="step" value="{$next_step}" />
	<input type="hidden" name="update_version" value="true" />

	{legend legend="Update bitweaver version"}
		{if $upToDate}
			<p class="success">
				Your version of bitweaver is already up to date.
			</p>
		{else}
			<p class="help">
				Your version of bitweaver will be updated to <strong>{$smarty.const.BIT_MAJOR_VERSION}.{$smarty.const.BIT_MINOR_VERSION}.{$smarty.const.BIT_SUB_VERSION} {$smarty.const.BIT_LEVEL}</strong> as soon as you hit the submit button below. This will allow you to enter your site again.
			</p>
		{/if}

		{if $version_210beta}
			<h3>Update to version 2.1.0 beta</h3>
			<p class="help">
				You can visit the {smartlink ititle="Permission Maintenance" ipackage=users ifile=admin/permissions.php} page at any time to make further adjustments.
			</p>

			<p class="help">
				The following table shows you all permissions on your system. The default group of a given permission is <span style="background:yellow">highlighted</span>.  We urge you to study this table closely as the default for some permissions has changed. If you don't update these, your site might allow unwanted users to edit content.
			</p>

			<table class="data">
				<caption>{tr}Available Permissions{/tr}</caption>
				{capture assign=theader}
					<tr>
						<th style="width:30%;">{tr}Permission{/tr}</th>
						{foreach from=$allGroups item=group name=groups}
							<th>
								<abbr title="{$group.group_name}">{if $smarty.foreach.groups.total > 8}{$group.group_id}{else}{$group.group_name}{/if}</abbr>
							</th>
						{/foreach}
					</tr>
				{/capture}

				{foreach from=$allPerms item=perm key=p name=perms}
					{if $prev_package != $perm.package}
						{$theader}
						{assign var=prev_package value=$perm.package}
					{/if}
					<tr class="{cycle values="odd,even"}">
						<td title="{$perm.perm_desc}"><abbr title="{$perm.perm_desc}">{$p}</abbr></td>
						{foreach from=$allGroups item=group}

							{if     $perm.perm_level == 'admin'     }{assign var=id value=1}
							{elseif $perm.perm_level == 'editors'   }{assign var=id value=2}
							{elseif $perm.perm_level == 'registered'}{assign var=id value=3}
							{elseif $perm.perm_level == 'basic'     }{assign var=id value=-1}{/if}

							<td style="text-align:center;{if $id == $group.group_id}background:yellow;{/if}">
								<input id="{$p}{$group.group_id}" type="checkbox" value="{$p}" name="perms[{$group.group_id}][{$p}]" title="{$group.group_name}" {if $group.perms.$p}checked="checked"{/if}/>
							</td>
						{/foreach}
					</tr>
				{/foreach}
			</table>

			<div class="row submit">
				<input type="submit" name="fix_version_210beta" value="Fix Permissions" />
			</div>

			<div class="row">
				{forminput}
					<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
					{formhelp note="Display SQL statements."}
				{/forminput}
			</div>
		{else}
			<div class="row submit">
				<input type="submit" name="skip" value="Continue install process" />
			</div>
		{/if}
	{/legend}
{/form}
