{strip}
<h1>Package Installation</h1>
<br />
{form}
	{jstabs}
		{jstab title="Install Packages"}
			{legend legend="Please select packages you wish to install"}
				<input type="hidden" name="step" value="{$next_step}" />

				<div class="row">
					{formfeedback note="This is a list with all available bitweaver packages that are ready for installation. Packages that are installed now, can later be deactivated and even deleted from your server if you don't need them anymore.<br />If you have any external packages such as <strong>phpBB</strong> or <strong>ZenCart</strong> lined up for installation, you can do this later on during the install process."}
				</div>
				{foreach from=$schema key=package item=item}
					{if $item.tables || $item.defaults}
						{if !$item.installed and !$item.required}
							<div class="row">
								<div class="formlabel">
									<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$item.name`}</label>
								</div>
								{forminput}
									<label><input type="checkbox" name="PACKAGE[]" value="{$package}" id="{$package}" checked="checked" /> {$item.name}</label>
									{formhelp note=`$item.info`}
									{formhelp note="<strong>Location</strong>: `$item.url`"}
									{formhelp package=$package}
								{/forminput}
							</div>
						{/if}
					{/if}
				{/foreach}
			{/legend}
		{/jstab}

		{if !$first_install}
			{jstab title="Installed Packages"}
				{legend legend="Already Installed Packages"}
					<div class="row">
						{formfeedback warning="These packages are already installed on your system. If you select any of these checkboxes, all the data associated with it, will be erased."}
					</div>
					{foreach from=$schema key=package item=item}
						{if $item.tables || $item.defaults}
							{if $item.installed and !$item.required}
								<div class="row">
									<div class="formlabel">
										<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$item.name`}</label>
									</div>
									{forminput}
										<label><input type="checkbox" name="PACKAGE[]" value="{$package}" id="{$package}" /> {$item.name}</label>
										{formhelp note=`$item.info`}
										{formhelp note="<strong>Location</strong>: `$item.url`"}
										{formhelp package=$package}
									{/forminput}
								</div>
							{/if}
						{/if}
					{/foreach}
				{/legend}
			{/jstab}
		{/if}

		{jstab title="Required Packages"}
			{legend legend="Packages that are required by bitweaver"}
				{if !$first_install}
					<div class="row">
						<ul class="result">
							<li class="warning">
								{biticon ipackage=liberty iname=warning iexplain=warning} 
								If you wish to reset the data in your entire system, you will first have to create a new database or empty it manually.
							</li>
						</ul>
					</div>
				{/if}

				{foreach from=$schema key=package item=item}
					{if $item.tables || $item.defaults}
						{if $item.required}
							<div class="row">
								<div class="formlabel">
									{biticon ipackage=$package iname="pkg_$package" iexplain=`$item.name`}
								</div>
								{forminput}
									{if !$item.installed}
										<input type="hidden" name="PACKAGE[]" value="{$package}" />
									{/if}
									{$item.name}
									{formhelp note=`$item.info`}
									{formhelp note="<strong>Location</strong>: `$item.url`"}
									{formhelp package=$package}
								{/forminput}
							</div>
						{/if}
					{/if}
				{/foreach}
			{/legend}
		{/jstab}
	{/jstabs}

	<div class="row submit">
		Please press this button only once<br />
		Depending on the number of packages and the hardware,<br />
		this process might take up to a few minutes.<br /><br />
		<input type="hidden" name="resetdb" value="{$resetdb}" />
		<input type="submit" name="fSubmitDbCreate" value="Install Packages" />
	</div>

	<div class="row">
		{formlabel label="Debug mode" for="debug"}
		{forminput}
			<input type="checkbox" name="debug" id="debug" value="true" />
			{formhelp note="This will display SQL statements."}
		{/forminput}
	</div>
{/form}
{/strip}
