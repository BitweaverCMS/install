<h1>Upgrade Packages</h1>

{form id="package_select" legend="Please select packages you wish to upgrade" id="package_select"}
	<p class="success">The following packages were successfully upgraded</p>
	<input type="hidden" name="step" value="{$next_step}" />
	<ul>
		{foreach from=$success item=package}
			<li>{$package} &rarr; {$gBitSystem->getVersion($package)}</li>
		{/foreach}
	</ul>

	<div class="row submit">
		<input type="submit" name="continue" value="Continue Install Process" />
	</div>
{/form}
