{strip}
{if $first_install}
	<h1>Package Installation</h1>
{else}
	<h1>Adding and Remove Packages</h1>
{/if}
<br />
{if $error}
	{legend legend="Administrator Data Missing"}
		<div class="row">
			<ul class="result">
				<li class="error">
					{biticon ipackage=liberty iname=error iexplain=error}
					Unfortunately there seems to be a problem with your installation. We can't find the administrator information you entered.
				</li>
			</ul>
		</div>

		<p>
			Please go back one step (using the link to your right, rather than the back button on your browser) and enter the administrator data again. If this is the second time you see this screen, please confirm that php can write sessions and that any firewall / anti-virus software is turned off during the installation process.
		</p>
		<p>
			If you just can't figure out what the hell is going on, please contact the bitweaver team via <a href="http://www.bitweaver.org/wiki/index.php?page=ConnectingToIrc">IRC</a> if possible or post to the forums on <a href="http://www.bitweaver.org">bitweaver.org</a>.
		</p>
	{/legend}
{else}
	{form id="package_select"}
		{if $warning}
			<div class="row">
				{formfeedback warning=$warning}
			</div>
		{/if}
		{jstabs}
			{jstab title="Install Packages"}
				{legend legend="Please select packages you wish to install"}
					<input type="hidden" name="step" value="{$next_step}" />

					<div class="row">
						{formfeedback note="This is a list with all available bitweaver packages that are ready for installation. Packages that are installed now, can later be deactivated and even deleted from your server if you don't need them anymore.<br />If you have any external packages such as <strong>phpBB</strong> or <strong>gallery2</strong> lined up for installation, you will have to do this sepeartely after completing the bitweaver installation process."}
					</div>
					<div class="row">
						{formlabel label="Toggle all package selections" for="switcher"}
						{forminput}
							<script type="text/javascript">
								document.write("<input name=\"switcher\" id=\"switcher\" type=\"checkbox\" checked onclick=\"switchCheckboxes(this.form.id,'PACKAGE[]','switcher')\" /><br />");
							</script>
							{formhelp note="Select or de-select all packages"}
						{/forminput}
					</div>
					{foreach from=$schema key=package item=item}
						{if $item.tables || $item.defaults}
							{if !$item.installed and !$item.required}
								<div class="row">
									<div class="formlabel">
										<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
									</div>
									{forminput}
										<label><input type="checkbox" name="PACKAGE[]" value="{$package}" id="{$package}" checked="checked" /> {$package|capitalize}</label>
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
						<div class="row">
							{formlabel label="Reinstall package" for="replace"}
							{forminput}
								<input type="checkbox" name="replace" id="replace" value="true" />
								{formhelp note="This will reinstall the selected packages rather than uninstalling them."}
							{/forminput}
						</div>
						{foreach from=$schema key=package item=item}
							{if $item.tables || $item.defaults}
								{if $item.installed and !$item.required}
									<div class="row">
										<div class="formlabel">
											<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
										</div>
										{forminput}
											<label><input type="checkbox" name="UN_PACKAGE[]" value="{$package}" id="{$package}" /> {$package|capitalize}</label>
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
							{formfeedback warning="If you wish to reset the data in your entire system, you will first have to create a new database or empty it manually."}
						</div>
					{/if}

					{foreach from=$schema key=package item=item}
						{if $item.tables || $item.defaults}
							{if $item.required}
								<div class="row">
									<div class="formlabel">
										{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}
									</div>
									{forminput}
										{if !$item.installed}
											<input type="hidden" name="PACKAGE[]" value="{$package}" />
										{/if}
										{$package|capitalize}
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
			{if !$first_install}
				&nbsp;&nbsp;<input type="submit" name="fCancel" value="Cancel Install" />
			{/if}
		</div>

		<div class="row">
			{formlabel label="Debug mode" for="debug"}
			{forminput}
				<input type="checkbox" name="debug" id="debug" value="true" />
				{formhelp note="This will display SQL statements."}
			{/forminput}
		</div>
	{/form}
{/if}
{/strip}
