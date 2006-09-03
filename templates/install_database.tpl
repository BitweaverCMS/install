<h1>Database Connection Information</h1>

{form legend="Please Enter your Database Connection Information"}
	<input type="hidden" name="step" value="{$next_step}" />
	<input type="hidden" name="gBitDbPassword_hash" value="{$gBitDbPassword_hash}" />

	<div class="row">
		{if $warning or $error or $success}
			{if $warning}
				<p class="warning">
					{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
					We have already set up a working connection with your db. Change these settings at your own peril.
				</p>
			{elseif $error}
				<div class="error">
					<p>
						{biticon ipackage="icons" iname="dialog-error" iexplain=error}
						Database connection could not be established.
					</p>

					{if $errorMsg}
						<p>
							The returned error message is:
							<br />
							<strong>{$errorMsg}</strong>
						</p>
					{/if}

					<ul>
						<li>Perhaps your database is not available</li>
						<li>or the server cannot connect to it</li>
						<li>or you have made a typo</li>
						<li>Please double check the following settings:
							<ul>
								<li><strong>database name</strong></li>
								<li><strong>database username</strong></li>
								<li><strong>database password</strong></li>
							</ul>
						</li>
					</ul>
				</divi>
			{/if}
		{/if}
	</div>

	<div class="row">
		{formlabel label="Database type" for="db"}
		{forminput}
			{if $section eq 'Upgrade'}
				<p class="warning">If you intend to upgrade an existing MySQL database, the required server version is greater than 4.1.</p>
			{/if}
			{if $dbservers}
				{html_options name='db' options=$dbservers id=db selected=$gBitDbType}
			{else}
				<p class="warning">You currently have no Database installed that works here. If you feel this is wrong, please contact the <a class="external" href="http://www.bitweaver.org/">bitweaver Team</a>.</p>
			{/if}
			{formhelp note="The type of database you intend to use."}
			<p class="warning">If the database you wish to use is not listed above, the version of PHP on this server does not have support for that database installed or compiled in.</p>
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Host" for="host"}
		{forminput}
			<input type="text" size="25" name="host" id="host" value="{if $gBitDbHost ne '' }{$gBitDbHost}{/if}" />
			{formhelp note="Hostname or IP for your MySQL database, example:<br />
				Use 'localhost' if your database is on the same machine as your server.<br />
				If you use Oracle, insert your TNS Name here<br />
				If you use SQLite, insert the path and filename to your database file<br />
				If you are not sure what to put in here, try using localhost."}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="User" for="user"}
		{forminput}
			<input type="text" size="25" name="user" id="user" value="{$gBitDbUser}" />
			{formhelp note="Database user"}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Password" for="pass"}
		{forminput}
			<input type="password" size="25" name="pass" id="pass" value="{$gBitDbPassword_input}" />
			{formhelp note="Database password"}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Database name" for="name"}
		{forminput}
			<input type="text" size="25" name="name" id="name" value="{$gBitDbName}" />
			{ if ( $fbpath ) }
				{formhelp note="The name of the database where bitweaver will create tables. You can
					create a Firebird alias for the bitweaver database in aliases.conf and then use that
					aliase as the database name, or provide a full path and file name to create
					the database in an existing directory."}
			{else}
				{formhelp note="The name of the database where bitweaver will create tables. You can
					create the database using mysqladmin, or PHPMyAdmin or ask your
					hosting service to create a MySQL database.
					Normally bitweaver tables won't conflict with other product names."}
			{/if}
		{/forminput}
	</div>

	<div class="row">
	{ if ( $fbpath ) }
		{formhelp note="<strong>Do not use Prefix with Firebird, as the field and table names are already up to 30 characters.</strong>"}
	{/if}
		{formlabel label="Database Prefix" for="prefix"}
		{forminput}
			<input type="text" size="25" name="prefix" id="prefix" value="{$db_prefix_bit|replace:'`':''}" />
			{formhelp note="This prefix will be prepended to the begining of every table name to allow multiple
				independent install to share a single database. To ensure problem free usage of bitweaver with other
				applications in the same database, <strong>we highly recommend using a prefix</strong>.
				If you are NOT running MySQL (i.e. Postgres, Oracle, etc.) you can end the prefix string with
				a '.' (period) to use a schema in systems that support it.
				<strong>MySQL does NOT support schemas.</strong>"}
		{/forminput}
	</div>

	{ if ( $fbpath ) }
	<div class="row">
		{formlabel label="Firebird Installation Path" for="fbpath"}
		{forminput}
			<input type="text" size="50" name="fbpath" id="fbpath" value="{$fbpath}" />
			{formhelp note="If you have modified your Firebird installation from the default please enter the correct
				path to the base firebird directory. This is used to find isql in order to create the initial blank
				database and should be maintained in the correct format for your OS."}
		{/forminput}
	</div>
	{/if}

	<div class="row">
		{formlabel label="Site Base Url" for="baseurl"}
		{forminput}
			<input type="text" size="25" name="baseurl" id="baseurl" value="{$root_url_bit}" />
			{formhelp note="This is the path from the server root to your bitweaver location.<br />
				i.e. if you access bitweaver as 'http://MyServer.com/applications/new/wiki/index.php' you should enter '/applications/new/'"}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Automatically submit bugs" for="auto_bug_submit"}
		{forminput}
			<input type="checkbox" name="auto_bug_submit" id="auto_bug_submit"{if $auto_bug_submit} checked="checked"{/if} />
			{formhelp note="Checking this box will automatically submit fatal database errors to the bitweaver team. If you are running a live site, we recommend you check this box, as it will also avoid horrible error messages from appearing in such cases."}
		{/forminput}
	</div>

	<div class="row submit">
		<input type="hidden" name="dbcase" value="{$gBitDbCaseSensitivity}" />
		<input type="hidden" name="resetdb" value="{$resetdb}" />
		<input type="submit" value="Confirm Settings" name="fSubmitDbInfo" />
	</div>
{/form}
