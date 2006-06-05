<h1>bitweaver PHP Settings</h1>

{form legend="Server Settings" class=checks}
	<input type="hidden" name="step" value="{$next_step}" />

	<h3>Required Settings</h3>

	<p class="help">The settings below are required by bitweaver to run. If any of these settings are not met, you will have to change these before you can continue with the installation process.</p>

	<div class="row">
		{formlabel label="Required settings"}
		{forminput}
			{foreach from=$required item="check"}
				{if $check.passed}
					<p>{biticon ipackage=liberty iname=success iexplain=success} {$check.note}</p>
				{else}
					<p class="error">{biticon ipackage=liberty iname=error iexplain=error} {$check.note}</p>
				{/if}
			{/foreach}
			{if $http_referer_error}
				<p class="error">{biticon ipackage=liberty iname=error iexplain=error} We have detected that we cannot access the _SERVER['HTTP_REFERER'] variable from your browser. This can be because you have bookmarked this page and accessed this page directly. If so, this will probably not cause any problems during installation.<br />However, if you came here from the welcome page, you are probably using some sort of firewall which is blocking this information (a common example is Norton Firewall). Please disable this feature or the firewall until the installation process is completed.</p>
			{/if}
		{/forminput}
	</div>

	{if $error}
		<p class="error">
			{biticon ipackage=liberty iname=error iexplain=error}
			Before you can continue with the installation, you must rectify the <strong style="color:red;">problems listed in red</strong>.
		</p>
	{else}
		<p class="success">
			{biticon ipackage=liberty iname=success iexplain=success}
			Your system meets all the requirements.
		</p>
	{/if}

	<h3>Recommended Extensions</h3>

	<p class="help">
		Virtually all settings below this point can be adjusted by changing appropriate values in your php.ini file.
		If you should have problems setting these, please consult the documentation in the php.ini file itself
		and the <a class="external" href="http://www.php.net">PHP HomePage</a>.
	</p>
	<p class="help">
		bitweaver takes advantage of particular PHP extensions for full functionality.
		If any of these extensions are not available to bitweaver, particular features might not work and it might even render particular packages useless.
	</p>

	<div class="row">
		{formlabel label="Thoroughly recommended extensions"}
		{forminput}
			{foreach from=$extensions item="check"}
				{if $check.passed}
					<p>{biticon ipackage=liberty iname=success iexplain=success} {$check.note}</p>
				{else}
					<p class="warning">{biticon ipackage=liberty iname=warning iexplain=warning} {$check.note}</p>
				{/if}
			{/foreach}
		{/forminput}
	</div>

	{if $warning}
		<p class="warning">
			{biticon ipackage=liberty iname=warning iexplain=warning}
			Before you continue, we suggest that you try and install the mentioned extensions. If you can not do so, please bear in mind that these extensions can be installed at any time and might enhance your bitweaver experience.
		</p>
	{else}
		<p class="success">
			{biticon ipackage=liberty iname=success iexplain=success}
			All recommended extensions are installed.
		</p>
	{/if}

	<h3>Recommended Settings</h3>

	<p class="help">
		The following are settings that aren't strictly required by bitweaver to run, but are recommendations.<br />
		bitweaver might still operate if your settings do not quite match the recommended.
	</p>

	<div class="row">
		{formlabel label="Recommended settings"}
		{forminput}
			<table width="100%" summary="This table lists recommended php settings for bitweaver to run smoothly">
				<caption>Recommended php.ini Settings</caption>
				<tr>
					<th scope="col">Setting</th>
					<th scope="col">Should be</th>
					<th scope="col">Actual</th>
				</tr>
				{foreach from=$recommended item="check"}
					<tr class="{if $check.passed eq 'y'}note{else}warning{/if}">
						<td>
							{if $check.passed}
								{biticon ipackage=liberty iname=success iexplain=success}
							{else}
								{biticon ipackage=liberty iname=warning iexplain=warning}
								{assign var=rec_warning value=true}
							{/if}
							<abbr title="php.ini setting: {$check.1}">{$check.0}</abbr>
						</td>
						<td>{$check.shouldbe}</td>
						<td>{$check.actual}</td>
					</tr>
				{/foreach}
			</table>
		{/forminput}
	</div>

	{if $memory_warning}
		<p class="warning">
			{biticon ipackage=liberty iname=warning iexplain=warning}
			Your memory limit settings are rather low. bitweaver requires at least 8MB memory to run, even having a limit of 8MB might cause undesired results. If you end up laoding blank pages, it might be the <strong>memory_limit</strong> setting in your <strong>php.ini</strong> file. if possible, please get your host to increase the limit to at least <strong>16MB</strong>.
		</p>
	{/if}
	{if $rec_warning}
		<p class="warning">
			{biticon ipackage=liberty iname=warning iexplain=warning}
			Not all the recommended setting have been met. However,  your site might still work without problems. Please keep these settings in mind when you run into problems.
		</p>
	{else}
		<p class="success">
			{biticon ipackage=liberty iname=success iexplain=success}
			All recommended settings have been met.
		</p>
	{/if}

	<h3>Settings worth knowing about</h3>

	<p class="help">The settings below are merely for your information and are meant to help you work out problems that might occur.</p>

	<div class="row">
		{formlabel label="Settings worth knowing about"}
		{forminput}
			{foreach from=$show item="check"}
				<p>{$check}</p>
			{/foreach}
		{/forminput}
	</div>

	{if !$error}
		<div class="row submit">
			<input type="submit" name="" value="Continue the Install process" />
		</div>
	{/if}
{/form}
