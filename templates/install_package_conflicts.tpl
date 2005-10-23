<h1>Package Conflicts</h1>

{form}
	<input type="hidden" name="step" value="{$next_step}" />
	{legend legend="Resolve Service Conflicts"}
		{if $serviceList}
			<p class="warning">
				We have noticed that you have activated multiple packages of the same service type.
				A service package is a package that allows you to extend the way you display bitweaver content - such as <em>categorising your content</em>.
				<br />
				The site should still be fully functional, however, there might be some minor problems such as display of the wrong menus and overlapping functionality.
				We therefore recommend that you enable only one of each service type.
			</p>

			<p>
				You can change your selection at a later time point by modifying the settings in the packages administration screen.
			</p>

			{foreach from=$serviceList key=service_name item=packages}
				<h3>{$service_name|capitalize}</h3>
				{foreach from=$packages key=package item=item}
					<div class="row">
						<div class="formlabel">
							<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
						</div>
						{forminput}
							<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" checked="checked" /> {$package|capitalize}</label>
							{formhelp note=`$schema.$package.info`}
							{formhelp note="<strong>Location</strong>: `$schema.$package.url`"}
							{formhelp package=$package}
						{/forminput}
					</div>
				{/foreach}
			{/foreach}

			<div class="row submit">
				<input type="submit" name="deactivate_packages" value="De / Activate Packages" />
			</div>
		{else}
			<p class="success">None of the packages you have installed are causing any problems. Please continue with the install process.</p>

			<div class="row submit">
				<input type="submit" name="skip" value="Continue Install Process" />
			</div>
		{/if}
	{/legend}
{/form}
