<h1>Server Settings Check</h1>

{form class="form-horizontal" legend="Server settings" class=checks}
	<input type="hidden" name="step" value="{$next_step}" />

	{jstabs tab=0}
		{jstab title="Setup"}

			<h2>Required Settings</h2>
			<p class="help">The settings below are required by Bitweaver to run. If any of these settings are not met, you will have to change these before you can continue with the installation process.</p>

			<div class="control-group requirements">
				{formlabel label="Basic Requirements"}
				{forminput}
					{foreach from=$required item="check"}
						{if $check.passed}
							<p class="alert alert-success">{$check.note}</p>
						{else}
							<p class="alert alert-error">{$check.note}</p>
						{/if}
					{/foreach}
					{if $http_referer_error}
						<p class="alert alert-error">We have detected that we cannot access the _SERVER['HTTP_REFERER'] variable from your browser. This can be because you have bookmarked this page and accessed this page directly. If so, this will probably not cause any problems during installation. However, if you came here from the welcome page, you are probably using some sort of firewall which is blocking this information (a common example is Norton Firewall). Please disable this feature or the firewall until the installation process is completed.</p>
					{/if}
				{/forminput}
			</div>

			{if $error}
				<p class="alert alert-error">Before you can continue with the installation, you must rectify the <strong>problems listed in red</strong>. After you have made the changes, you can reload the page.</p>
				<div class="control-group column-group gutters">
		{forminput}
						<input type="submit" class="ink-button" name="reload" value="Reload Page" />
		{/forminput}
				</div>
			{else}
				<p class="alert alert-success">Your system meets all the requirements. You are ready to install Bitweaver.</p>
			{/if}



			<h2>Recommended PHP Settings</h2>
			<p class="help">The following are settings that aren't strictly required by Bitweaver to run, but are recommendations. Bitweaver might still operate if your settings do not quite match the recommended.  These settings can be adjusted by changing appropriate values in your <kbd>php.ini</kbd> file.  If you should have problems setting these, please consult the documentation in the <kbd>php.ini</kbd> file itself and the <a class="external" href="http://www.php.net/">PHP homepage</a>.</p>
				<table class="table" summary="This table lists recommended PHP settings for Bitweaver to run smoothly.">
					<tr>
						<th scope="col">php.ini setting</th>
						<th scope="col">should be</th>
						<th scope="col">actual</th>
					</tr>
					{foreach from=$recommended item="check"}
						<tr class="{if $check.passed eq 'y'}success{else}warning{assign var=rec_warning value=true}{/if}">
							<td>
								<abbr title="php.ini setting: {$check.1}">{$check.0}</abbr>
							</td>
							<td>{$check.shouldbe}</td>
							<td>{$check.actual}</td>
						</tr>
					{/foreach}
				</table>

			{if $memory_warning}
				<p class="alert alert-block">Your memory limit settings are rather low. Bitweaver requires at least 16MB memory to run, even having a limit of 16MB might cause undesired results. If you end up loading blank pages, it might be the <kbd>memory_limit</kbd> setting in your <kbd>php.ini</kbd> file. If you have a PHP optimiser such as eAccelerator installed you should be fine with 16MB, if not, please try to raise the limit to something higher.</p>
			{/if}

			{if $rec_warning}
				<p class="alert alert-block">Not all the recommended setting have been met. However, your site might still work without problems. Please keep these settings in mind if you run into problems.</p>
			{else}
				<p class="alert alert-success">All recommended settings have been met.</p>
			{/if}

		{/jstab}
		{jstab title="Recommended"}

			<h2>Recommended Extensions</h2>
			<p class="help">Bitweaver takes advantage of particular PHP extensions for full functionality. If any of these extensions are not available to Bitweaver, particular features might not work and it might even render particular packages useless.</p>

			<div class="control-group recommended">
				{formlabel label="Thoroughly recommended extensions"}
				{forminput}
					{foreach from=$extensions item="check"}
						{if $check.passed}
							<p class="alert alert-success">{$check.note}</p>
						{else}
							{assign var=extwarning value=1}
							<p class="alert alert-block">{$check.note}</p>
						{/if}
					{/foreach}
				{/forminput}
			</div>

			{if $extwarning}
				<p class="alert alert-block">Before you continue, we suggest that you try and install the mentioned extensions. If you can not do so, please bear in mind that these extensions can be installed at any time and might enhance your Bitweaver experience.</p>
			{else}
				<p class="alert alert-success">All recommended extensions are installed.</p>
			{/if}



			<h2>Recommended PEAR Extensions</h2>
			<p class="help">PEAR provides extensions to PHP, which can easily be installed and updated using the pear interface on Linux. None of the extenstions below are required, they always provide an alternative to the existing methods available. Often these alternatives are superior to the default methods.</p>

			<div class="control-group recommended">
				{formlabel label="Recommended PEAR Extensions"}
				{forminput}
					{if !$pearexts.PEAR.passed}
						{assign var=pearinstall value=1}
						<p class="alert alert-block">{$pearexts.PEAR.note}</p>
						<p>Extensions we can make use of:</p>
						<ul>
							{foreach from=$pearexts key=ext item="check"}
								{if $ext != 'PEAR'}
									<li><strong>PEAR::{$ext}</strong><br />{$check.original_note}</li>
								{/if}
							{/foreach}
						</ul>
					{else}
						{foreach from=$pearexts item="check"}
							{if $check.passed}
								<p class="alert alert-success">{$check.note}</p>
							{else}
								{assign var=pearextswarning value=1}
								<p class="alert alert-block">{$check.note}</p>
							{/if}
						{/foreach}
					{/if}
				{/forminput}
			</div>

			{if $pearinstall or $pearextswarning}
				<p class="alert alert-block">
					<strong>Installation help</strong>: None of the recommend extension are required.
					However, they do enhance some Bitweaver features. To install PEAR for your
					Bitweaver site, choose one of the following methods. Users in a shared hosting environment
					without PEAR should download the pre-packed set:
				</p>

				<ul>
					{if $pearinstall}
						<li>If you want to install PEAR, you can view the <a
								class="external"
								href="http://pear.php.net/manual/en/installation.getting.php">instructions</a>
							(this is not necessary if you download the pre-packed set of
							PEAR extensions below).</li>
					{/if}
					<li>Install PEAR extensions using <a class="external"
							href="http://pear.php.net/manual/en/guide.users.commandline.cli.php">
							command line interface</a> (requires ssh access),</li>
					<li>or install PEAR extensions in <a class="external"
							href="http://pear.php.net/manual/en/installation.shared.php">a
							shared environment</a> (requires ssh access or ftp access),</li>
					<li>or download a pre-packed set of <a class="external"
							href="http://www.bitweaver.org/downloads/file/11619">Bitweaver
							PEAR extensions</a> and extract this to<br />
						<kbd>{$smarty.const.UTIL_PKG_PATH}pear/</kbd></li>
				</ul>
			{else}
				<p class="alert alert-success">
					All recommended pear extensions are installed.
				</p>
			{/if}

			<br />
			<h2>Recommended Executables</h2>

			<p class="help">
				Here we test for a set of executable files on your server. These files
				are not mandatory but will enable you to perform certain tasks. We
				generally try to avoid using external applications, but sometimes it's
				the easiest and quickest way to achieve a certain goal.
			</p>

			<div class="control-group recommended">
				{formlabel label="Recommended executables"}
				{forminput}
					{foreach from=$executables item="check"}
						{if $check.passed}
							<p class="alert alert-success">{$check.note}</p>
						{else}
							{assign var=executableswarning value=1}
							<p class="alert alert-block">{$check.note}</p>
						{/if}
					{/foreach}
				{/forminput}
			</div>

			{if $executableswarning}
				<p class="alert alert-block">
					Please bear in mind that certain options will not be available to
					you due to the fact that some of the applications Bitweaver uses
					are not available. E.g., if <kbd>unzip</kbd> is not available, .zip files
					cannot be processed after uploading them.
				</p>
			{else}
				<p class="alert alert-success">
					All recommended executables are installed.
				</p>
			{/if}

		{/jstab}
		{jstab title="Other"}

			<h2>Settings worth knowing about</h2>

			<p class="help">
				The settings below are for your information, meant to
				help you work out problems that might occur.
			</p>

			<div class="control-group column-group gutters">
				{formlabel label="Settings worth knowing about"}
				{forminput}
					<ul>
						{foreach from=$show item="check"}
							<li>{$check}</li>
						{/foreach}
					</ul>
				{/forminput}
			</div>

		{/jstab}
	{/jstabs}

	{if !$error}
		<div class="control-group column-group gutters">
		{forminput}
			<input type="submit" class="ink-button" name="reload" value="Reload page" /> <input type="submit" class="btn btn-primary" name="continue" value="Continue install process" />
		{/forminput}
		</div>
	{/if}

{/form}
