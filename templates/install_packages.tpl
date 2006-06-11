{strip}
{if $first_install}
	<h1>Package Installation</h1>
{else}
	<h1>Adding and Removing Packages</h1>
{/if}
<br />
{if $error}
	{legend legend="Administrator Data Missing"}
		<p class="error">
			{biticon ipackage=liberty iname=error iexplain=error}
			Unfortunately there seems to be a problem with your installation. We can't find the administrator information you entered.
		</p>

		<p>Please go back one step (using the link to your right, rather than the back button on your browser) and enter the administrator data again. If this is the second time you see this screen, please confirm that php can write sessions and that any firewall / anti-virus software is turned off during the installation process. </p>
		<p>If you just can't figure out what the hell is going on, please contact the bitweaver team via <a href="http://www.bitweaver.org/wiki/index.php?page=ConnectingToIrc">IRC</a> if possible or post to the forums on <a href="http://www.bitweaver.org">bitweaver.org</a>.</p>
	{/legend}
{else}
	{formfeedback warning=$warning}
	{jstabs}
		{jstab title="Install Packages"}
			{form id="package_select" legend="Please select packages and services you wish to install" id="package_select"}
				<input type="hidden" name="step" value="{$next_step}" />
				<input type="hidden" name="method" value="install" />

				{* include required packages during first install *}
				{foreach from=$schema key=package item=item}
					{if $item.tables || $item.defaults}
						{if $item.required && !$item.installed}
							<input type="hidden" name="packages[]" value="{$package}" />
						{/if}
					{/if}
				{/foreach}

				<p>This is a list with all available bitweaver packages that are ready for installation. Packages that are installed now, can later be deactivated and even deleted from your server if you don't need them anymore.<br />If you have any external packages such as <strong>phpBB</strong> or <strong>gallery2</strong> lined up for installation, you will have to do this sepeartely after completing the bitweaver installation process.</p>

				<div class="row">
					{forminput}
						<script type="text/javascript">
							document.write("<label><input name=\"switcher\" id=\"switcher\" type=\"checkbox\" checked onclick=\"switchCheckboxes(this.form.id,'packages[]','switcher')\" /> Batch (de)select all Packages and Services on this page</label>");
						</script>
						<noscript>
							You don't have javascript enabled
						</noscript>
					{/forminput}
				</div>

				<h2>Packages</h2>

				<p>Packages are the parts of bitweaver that deal with content such as wiki pages, blogs or news articles.</p>

				{foreach from=$schema key=package item=item}
					{if $item.tables || $item.defaults}
						{if !$item.installed and !$item.required and !$item.service}
							<div class="row">
								<div class="formlabel">
									<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
								</div>
								{forminput}
									<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" checked="checked" /> <strong>{$package|capitalize}</strong></label>
									{formhelp note=`$item.info`}
									{formhelp note="<strong>Location</strong>: `$item.url`"}
									{formhelp package=$package}
								{/forminput}
							</div>
						{/if}
					{/if}
				{/foreach}

				<h2>Services</h2>

				<p>Services are special packages and can be considered extensions to the way content is handled. An extension might allow you to protect, categorise or rate your content.</p>

				{foreach from=$schema key=package item=item}
					{if $item.tables || $item.defaults}
						{if !$item.installed and !$item.required and $item.service}
							<div class="row">
								<div class="formlabel">
									<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
								</div>
								{forminput}
									<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" checked="checked" /> <strong>{$package|capitalize}</strong></label>
									{formhelp note=`$item.info`}
									{formhelp note="<strong>Location</strong>: `$item.url`"}
									{formhelp package=$package}
								{/forminput}
							</div>
						{/if}
					{/if}
				{/foreach}

				<div class="row submit">
					Please press this button only once<br />
					Depending on the number of packages and the hardware,<br />
					this process might take up to a few minutes.<br /><br />
					<input type="hidden" name="resetdb" value="{$resetdb}" />
					<input type="submit" name="submit_packages" value="Install Packages" />
				</div>

				<div class="row">
					{forminput}
						<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
						{formhelp note="This will display SQL statements."}
					{/forminput}
				</div>
			{/form}
		{/jstab}

		{if !$first_install}
			{jstab title="Un / Reinstall Packages"}
				{form legend="Already Installed Packages"}
					<input type="hidden" name="step" value="{$next_step}" />

					<div class="row">
						{formfeedback warning="These packages are already installed on your system. If you select any of these checkboxes, all the data associated with it, will be erased."}
					</div>

					<div class="row">
						{formlabel label="Un / Reinstall packages"}
						{forminput}
							<label><input type="radio" name="method" value="reinstall" checked="checked" /> Reinstall</label>
							<br />
							<label><input type="radio" name="method" value="uninstall" /> Uninstall</label>
							{formhelp note="Choose whether you want to uninstall or reinstall selected packages."}
						{/forminput}
					</div>

					<div class="clear"><hr /></div>

					{foreach from=$schema key=package item=item}
						{if $item.tables || $item.defaults}
							{if $item.installed and !$item.required}
								<div class="row">
									<div class="formlabel">
										<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
									</div>
									{forminput}
										<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" /> <strong>{$package|capitalize}</strong></label>
										{formhelp note=`$item.info`}
										{formhelp note="<strong>Location</strong>: `$item.url`"}
										{formhelp package=$package}
									{/forminput}
								</div>
							{/if}
						{/if}
					{/foreach}

					<div class="row submit">
						Please press this button only once<br />
						Depending on the number of packages and the hardware,<br />
						this process might take up to a few minutes.<br /><br />
						<input type="submit" name="submit_packages" value="Un / Reinstall Packages" />
					</div>

					<div class="row">
						{forminput}
							<label><input type="checkbox" name="debug" id="debug" value="true" /> Debug mode</label>
							{formhelp note="This will display SQL statements."}
						{/forminput}
					</div>
				{/form}
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
									<strong>{$package|capitalize}</strong>
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

	{if !$first_install}
		{form}
			<input type="hidden" name="step" value="{$next_step}" />
			<div class="row submit">
				&nbsp;&nbsp;<input type="submit" name="cancel" value="Skip this Stage and resolve existing conflicts" />
			</div>
		{/form}
	{/if}
{/if}
{/strip}
