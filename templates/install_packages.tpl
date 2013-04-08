{strip}
{if $first_install}
	<h1>Package Installation</h1>
{else}
	<h1>Adding and removing packages</h1>
{/if}
{if $error}
		<div class="alert alert-error">
			<strong>Administrator Data Missing</strong>
			<p>Unfortunately there seems to be a problem with your installation. We can't find the administrator information you entered.</p>
		</div>

		<p>Please go back one step (using the link to your right, rather than the back button on your browser) and enter the administrator data again. If this is the second time you see this screen, please confirm that PHP can write sessions and that any firewall/anti-virus software is turned off during the installation process.</p>
		<p>If you just can't figure out what the hell is going on, please contact the Bitweaver team via <a href="http://www.bitweaver.org/wiki/Live+Support">IRC</a> if possible or post to the forums on <a href="http://www.bitweaver.org">bitweaver.org</a>.</p>
{else}
	{formfeedback warning=$warning}
	{form class="form-horizontal" id="installpackagesform"}
	{jstabs tab=0}
		{jstab title="Install Packages"}
				<input type="hidden" name="resetdb" value="{$resetdb}" />
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
					{legend legend="Please select packages and services you wish to install"}

					<p>Packages are apps in Bitweaver that deal with content such as wiki pages, blogs or news articles. Below is a list with all available Bitweaver packages that are ready for installation. Packages that are installed now, can later be deactivated and even deleted from your server if you don't need them anymore.</p>

					<p class="alert alert-block">Be conscientious about installing packages. The more packages you activate, the more computer power you will need. It is easy to install packages at a later date, so we advise initially installing just the packages you need.</p>

					<div class="control-group">
						{forminput}
							<script type="text/javascript">/* <![CDATA[ */
								document.write("<label><input name=\"switcher\" id=\"switcher\" type=\"checkbox\" checked onclick=\"BitBase.switchCheckboxes(this.form.id,'packages[]','switcher')\" /> Batch (de)select all Packages and Services on this page</label>");
							/* ]]> */</script>
						{/forminput}
					</div>

					{foreach from=$schema key=package item=item}
						{if !$item.installed and !$item.required}
							<div class="control-group">
								<label class="control-label" for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=$package}</label>
								{forminput}
									<label><input type="checkbox" name="packages[]" value="{$package}" id="{$package}" checked="checked" /> <strong>{$package|capitalize}</strong></label>
									{formhelp note=$item.info is_installer=1}
									{formhelp note="<strong>Location</strong>: `$item.url`"}
									{formhelp package=$package}
								{/forminput}
							</div>
						{/if}
					{/foreach}
					{/legend}
				{elseif $first_install}
					<h2>Core System Installation</h2>
					<p>{tr}Only the core required packages will be installed{/tr}</p>
				{else}
					<h2>No Additional Packages</h2>

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
				<div class="control-group">
					{forminput}
						<label><input type="checkbox" name="debug" value="true" /> Debug mode</label>
						{formhelp note="Display SQL statements."}
					{/forminput}
				</div>

				<div class="control-group">
					{forminput}
						<div class="alert alert-warning">
							<strong>Please press the install button only once.</strong>
							<p> Depending on the number of packages and the hardware, this process might take up to a few minutes.</p>
						</div>
						<input type="submit" class="btn btn-primary" name="submit_packages" value="Install Packages" />
					{/forminput}
				</div>

		{/jstab}

		{if !$first_install}
			{jstab title="Uninstall/Reinstall"}
					<input type="hidden" name="step" value="{$next_step}" />

					<div class="control-group">
						<p class="alert alert-block">These packages are already installed on your system. If you select any of these checkboxes, all the data associated with it will be erased (depending on options below).</p>
					</div>

					<div class="control-group">
						{formlabel label="selected packages:"}
						{forminput}
							<label><input type="radio" name="method" value="reinstall" checked="checked" /> Reinstall</label>
							<br />
							<label><input type="radio" name="method" value="uninstall" /> Uninstall</label>
							{formhelp note="Choose whether you want to uninstall or reinstall selected packages."}
						{/forminput}
					</div>

					<div class="control-group">
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
								<div class="control-group">
									<label class="control-label">
										<label for="{$package}">{biticon ipackage=$package iname="pkg_$package" iexplain=$package}</label>
									</label>
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

					<div class="control-group">
						{forminput}
							<input type="submit" class="btn" name="submit_packages" value="Uninstall/Reinstall Packages" onclick="return confirm( 'Are you sure you want to uninstall/reinstall the selected packages?' );" />
						{/forminput}
					</div>

					<div class="alert alert-info">
						<strong>Please press the install button only once.</strong>
						<p> Depending on the number of packages and the hardware, this process might take up to a few minutes.</p>
					</div>

					<div class="control-group">
						{forminput}
							<label><input type="checkbox" name="debug" value="true" /> Debug mode</label>
							{formhelp note="Display SQL statements."}
						{/forminput}
					</div>
			{/jstab}
		{/if}

		{jstab title="Required"}
			{legend legend="Packages and services required by Bitweaver"}
				{if !$first_install}
					<div class="control-group">
						<p class="alert alert-block">To reset the entire system, first create a new database (or empty the existing database manually).</p>
					</div>
				{/if}

				{foreach from=$schema key=package item=item}
					{if $item.required}
						<div class="control-group">
							<label class="control-label">
								{biticon ipackage=$package iname="pkg_$package" iexplain=$package}
							</label>
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
			<input type="hidden" name="step" value="{$next_step}" />
			<div class="control-group">
				{forminput}
					<input type="submit" class="btn" name="cancel" value="Skip this stage" />
				{/forminput}
			</div>
	{/if}
	{/form}
{/if}
{/strip}
