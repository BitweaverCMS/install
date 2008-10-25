<h1>Upgrade Packages</h1>

{form id="package_select" legend="Please select packages you wish to upgrade" id="package_select"}
	<p class="success">The following packages were successfully upgraded</p>
	<input type="hidden" name="step" value="{$next_step}" />
	<dl>
		{foreach from=$success item=upgrade key=package}
			{foreach from=$upgrade item=data key=version}
				<dt>{$package}</dt>
				<dd>Upgrade &rarr; {$version}
					{if $data.post_upgrade}
						<br /><strong>Post install notes</strong>:
						<br />{$data.post_upgrade}
						{assign var=upgrade_notes value=1}
					{/if}
				</dd>
			{/foreach}
		{/foreach}
	</dl>

	{if !$upgrade_notes}
		<p class="help">No package seems to have any important notes.</p>
	{/if}

	<div class="row submit">
		<input type="submit" name="continue" value="Continue Install Process" />
	</div>
{/form}
