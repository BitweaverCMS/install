{strip}
{if $first_install}
	<h1>Package Installation</h1>
{else}
	<h1>Adding and removing packages</h1>
{/if}
<br />
{if $error}
	{legend legend="Administrator Data Missing"}
		<p class="error">
			Unfortunately there seems to be a problem with your installation. We can't find the administrator information you entered.
		</p>

		<p>Please go back one step (using the link to your right, rather than the back button on your browser) and enter the administrator data again. If this is the second time you see this screen, please confirm that PHP can write sessions and that any firewall/anti-virus software is turned off during the installation process.</p>
		<p>If you just can't figure out what the hell is going on, please contact the Bitweaver team via <a href="http://www.bitweaver.org/wiki/Live+Support">IRC</a> if possible or post to the forums on <a href="http://www.bitweaver.org">bitweaver.org</a>.</p>
	{/legend}
{else}
	{formfeedback warning=$warning}
	{jstabs tab=0}
		{jstab title="Install Packages"}
			{form id="package_select" legend="Please select packages and services you wish to install" id="package_select"}
				<input type="hidden" name="step" value="{$next_step}" />
				<input type="hidden" name="method" value="install" />

				{* include required packages during first install *}
				{foreach from=$schema key=package item=item}
					{if $item.required && !$item.installed}
						<input type="hidden" name="packages[]" value="{$package}" />
					{/if}
				{/foreach}

				{foreach from=$schema key=package item=item}
					{if !$item.installed and !$item.required}
						{assign var=new_packages value=true}
					{/if}
				{/foreach}

				{if $new_packages}
					<p>This is a list with all available Bitweaver packages that are ready for installation. Packages that are installed now, can later be deactivated and even deleted from your server if you don't need them anymore.<br />If you have any external packages such as <strong>phpBB</strong> or <strong>gallery2</strong> lined up for installation, you will have to do this separately after completing the Bitweaver installation process.</p>

					<p class="warning">Be conscientious about installing packages. The more packages you activate, the more computer power you will need. It is easy to install packages at a later date, so we advise initially installing just the packages you need.</p>

					<div class="row">
						{forminput}
							<script type="text/javascript">/* <![CDATA[ */
								document.write("<label><input name=\"switcher\" id=\"switcher\" type=\"checkbox\" checked onclick=\"BitBase.switchCheckboxes(this.form.id,'packages[]','switcher')\" /> Batch (de)select all Packages and Services on this page</label>");
							/* ]]> */</script>
						{/forminput}
					</div>

					<h2>Packages</h2>

					<p>Packages are the parts of Bitweaver that deal with content such as wiki pages, blogs or news articles.</p>

					{foreach from=$schema key=package item=item}
						{if !$item.installed and !$item.required}
							<div class="row">
								<div class="formlabel">
									<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}</label>
								</div>
								{forminput}
									<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" checked="checked" /> <strong>{$package|capitalize}</strong></label>
									{formhelp note=$item.info is_installer=1}
									{formhelp note="<strong>Location</strong>: `$item.url`"}
									{formhelp package=$package}
								{/forminput}
							</div>
						{/if}
					{/foreach}
				{else}
					<h2>No new Packages</h2>

					<p>
						All available packages have already been installed. If you are expecting to see a particular package here, please make sure that it is in the correct directory and also that the server has read permissions to that package. You can always test the permissions by setting them 777:<br />
						<code>
							cd {$smarty.const.BIT_ROOT_PATH}<br />
							chmod -R 777 &lt;package&gt;/
						</code><br />
					</p>
					<p>
						Common permissions that work on most systems can be set as follows:<br />
						<code>
							cd {$smarty.const.BIT_ROOT_PATH}<br />
							chmod -R 755 &lt;package&gt;/<br />
							find &lt;package&gt;/ -type f -print | xargs chmod 644
						</code><br />
					</p>
				{/if}
				<div class="row submit">
					Please press this button only once.<br />
					Depending on the number of packages and the hardware,<br />
					this process might take up to a few minutes.<br /><br />
					<input type="hidden" name="resetdb" value="{$resetdb}" />
					<input type="submit" name="submit_packages" value="Install Packages" />
				</div>

				<div class="row">
					{forminput}
						<label><input type="checkbox" name="debug" value="true" /> Debug mode</label>
						{formhelp note="Display SQL statements."}
					{/forminput}
				</div>

			{/form}
		{/jstab}

		{if !$first_install}
			{jstab title="Uninstall/Reinstall"}
				{form legend="Already Installed Packages"}
					<input type="hidden" name="step" value="{$next_step}" />

					<div class="row">
						<p class="warning">These packages are already installed on your system. If you select any of these checkboxes, all the data associated with it will be erased (depending on options below).</p>
					</div>

					<div class="row">
						{formlabel label="selected packages:"}
						{forminput}
							<label><input type="radio" name="method" value="reinstall" checked="checked" /> Reinstall</label>
							<br />
							<label><input type="radio" name="method" value="uninstall" /> Uninstall</label>
							{formhelp note="Choose whether you want to uninstall or reinstall selected packages."}
						{/forminput}
					</div>

					<div class="row">
						{formlabel label=""}
						{forminput}
							<label><input type="checkbox" name="remove_actions[]" value="tables" checked="checked" />&nbsp;Delete database tables</label>
							{formhelp note="If selected, the package's database tables are deleted. If no other option is selected, specific settings might remain in Kernel configuration, and specific content might remain in Liberty tables, both of which might lead to undesired results."}
							<label><input type="checkbox" name="remove_actions[]" value="settings" checked="checked" />&nbsp;Delete package settings</label>
							{formhelp note="If selected, all package specific settings are removed. Therefor the package is reset to it's default values, including permissions."}
							<label><input type="checkbox" name="remove_actions[]" value="content" checked="checked" />&nbsp;Delete stored content</label>
							{formhelp note="If selected, all content that has been stored in the common content storage area is removed."}
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
										{formhelp note=$item.info is_installer=1}
										{formhelp note="<strong>Location</strong>: `$item.url`"}
										{formhelp package=$package}
									{/forminput}
								</div>
							{/if}
						{/if}
					{/foreach}

					<div class="row submit">
						Please press this button only once.<br />
						Depending on the number of packages and the hardware,<br />
						this process might take up to a few minutes.<br /><br />
						<input type="submit" name="submit_packages" value="Uninstall/Reinstall Packages" onclick="return confirm( 'Are you sure you want to uninstall/reinstall the selected packages?' );" />
					</div>

					<div class="row">
						{forminput}
							<label><input type="checkbox" name="debug" value="true" /> Debug mode</label>
							{formhelp note="Display SQL statements."}
						{/forminput}
					</div>
				{/form}
			{/jstab}
		{/if}

		{jstab title="Required"}
			{legend legend="Packages and services required by Bitweaver"}
				{if !$first_install}
					<div class="row">
						<p class="warning">To reset the entire system, first create a new database (or empty the existing database manually).</p>
					</div>
				{/if}

				{foreach from=$schema key=package item=item}
					{if $item.required}
						<div class="row">
							<div class="formlabel">
								{biticon ipackage=$package iname="pkg_$package" iexplain=`$package`}
							</div>
							{forminput}
								<strong>{$package|capitalize}</strong>
								{formhelp note=$item.info is_installer=1}
								{formhelp note="<strong>Location</strong>: `$item.url`"}
								{formhelp package=$package}
							{/forminput}
						</div>
					{/if}
				{/foreach}
			{/legend}
		{/jstab}
	{/jstabs}

	{if !$first_install}
		{form}
			<input type="hidden" name="step" value="{$next_step}" />
			<div class="row submit">
				&nbsp;&nbsp;<input type="submit" name="cancel" value="Skip this stage" />
			</div>
		{/form}
	{/if}
{/if}
{/strip}
