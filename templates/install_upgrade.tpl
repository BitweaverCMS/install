<h1>Package Upgrades</h1>
{foreach from=$packageUpgrades item=upgrade key=package}
	<h2>{$package}</h2>
	<p>Your current version of {$package} is {$gBitSystem->getVersion($package)}. These are the available upgrades for your package:</p>
	<ul>
		{foreach from=$upgrade item=data key=version}
			<li>{$version}</li>
		{/foreach}
	</ul>
{/foreach}
