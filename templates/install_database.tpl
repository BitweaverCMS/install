<h1>Database Connection</h1>

{form class="form-horizontal" legend="Please enter your database connection information"}
	<input type="hidden" name="step" value="{$next_step}" />
	<input type="hidden" name="gBitDbPassword_hash" value="{$gBitDbPassword_hash}" />

	<div class="control-group">
		{if $warning or $error or $success}
			{if $warning}
				<p class="alert alert-block">
					We have already set up a working connection with your database. Change these settings at your own peril.
				</p>
			{elseif $error}
				<div class="error">
					<p>
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
						{if $fbpath}
							<li>and check that the Firebird tool path is set corrently.</li>
						{/if}
					</ul>
				</divi>
			{/if}
		{/if}
	</div>

	<div class="control-group">
		{formlabel label="Database type" for="db"}
		{forminput}
			{if $section eq 'Upgrade'}
				<p class="alert alert-block">If you intend to upgrade an existing MySQL database, the required server version is greater than 4.1.</p>
			{/if}
			{if $dbservers}
				{html_options name='db' options=$dbservers id=db selected=$gBitDbType style="width:50%"}
				{formhelp note="The type of database you intend to use."}
				{if $mysqlWarning}
					<p class="alert alert-block">
						Versions of MySQL less than 4.1 are not supported by some packages due to the <a href="http://dev.mysql.com/doc/refman/4.1/en/subqueries.html">lack of subquery support</a>. Notable among these are the <a href="http://www.bitweaver.org/wiki/BoardsPackage">Boards</a> and <a href="http://www.bitweaver.org/wiki/MessagesPackage">Messages</a> packages. Other packages may also have issues. It is recommended that you use MySQL version 4.1 or higher for the best experience with Bitweaver. It <em>may</em> be possible to use a lower versions of MySQL if you do not install these packages.
					</p>
				{/if}
			{else}
				<p class="alert alert-block">You currently have no database installed that works here. If you feel this is wrong, please contact the <a class="external" href="http://www.bitweaver.org/">Bitweaver team</a>.</p>
			{/if}
			<p class="alert alert-block">If the database you wish to use is not listed above, the version of PHP on this server does not have support for that database installed or compiled in.</p>
		{/forminput}
	</div>

	<div class="control-group">
		{formlabel label="Host" for="host"}
		{forminput}
			<input type="text" size="25" name="host" id="host" value="{if $gBitDbHost ne '' }{$gBitDbHost}{/if}" />
			{formhelp note="Hostname or IP for your MySQL database, example:<br />
				Use 'localhost' if your database is on the same machine as your server.<br />
				If you use Oracle, insert your TNS name here.<br />
				If you use SQLite, insert the path and filename to your database file.<br />
				If you are not sure what to put in here, try using localhost."}
		{/forminput}
	</div>

	<div class="control-group">
		{formlabel label="User" for="user"}
		{forminput}
			<input type="text" size="25" name="user" id="user" value="{$gBitDbUser}" />
			{formhelp note="Database user"}
		{/forminput}
	</div>

	<div class="control-group">
		{formlabel label="Password" for="pass"}
		{forminput}
			<input type="password" size="25" name="pass" id="pass" value="{$gBitDbPassword_input}" />
			{formhelp note="Database password"}
		{/forminput}
	</div>

	<div class="control-group">
		{formlabel label="Database name" for="name"}
		{forminput}
			<input type="text" size="25" name="name" id="name" value="{$gBitDbName}" />
			{if $fbpath}
				{formhelp note="The name of the database where Bitweaver will create tables. You can create a Firebird alias for the Bitweaver database in aliases.conf and then use that aliase as the database name, or provide a full path and file name to create the database in an existing directory."}
			{else}
				{formhelp note="The name of the database where Bitweaver will create tables. You can create the database using mysqladmin, or PHPMyAdmin or ask your hosting service to create a MySQL database.  Normally, Bitweaver tables won't conflict with other product names."}
			{/if}
		{/forminput}
	</div>

	<div class="control-group">
	{if $fbpath}
		{formhelp note="<strong>Do not use Prefix with Firebird, as the field and table names are already up to 30 characters.</strong>"}
	{/if}
		{formlabel label="Database prefix" for="prefix"}
		{forminput}
			<input type="text" size="25" name="prefix" id="prefix" value="{$db_prefix_bit|replace:'`':''}" />
			{formhelp note="This prefix will be prepended to the begining of every table name to allow multiple independent install to share a single database. To ensure problem free usage of Bitweaver with other applications in the same database, <strong>we highly recommend using a prefix</strong>.  If you are NOT running MySQL (i.e. Postgres, Oracle, etc.) you can end the prefix string with a '.' (period) to use a schema in systems that support it.  <strong>MySQL does NOT support schemas.</strong>"}
		{/forminput}
	</div>

	{if $fbpath}
	<div class="control-group">
		{formlabel label="Firebird installation path" for="fbpath"}
		{forminput}
			<input type="text" size="50" name="fbpath" id="fbpath" value="{$fbpath}" />
			{formhelp note="If you have modified your Firebird installation from the default please enter the correct path to the base Firebird directory. This is used to find isql in order to create the initial blank database and should be maintained in the correct format for your operating system."}
		{/forminput}
	</div>
	{/if}

	<div class="control-group">
		{formlabel label="Site base URL" for="baseurl"}
		{forminput}
			<input type="text" size="25" name="baseurl" id="baseurl" value="{$bit_root_url}" />
			{formhelp note="This is the path from the server root to your Bitweaver location.<br />
				i.e. if you access Bitweaver as <kbd>http://MyServer.com/applications/new/wiki/index.php</kbd> you should enter <kbd>/applications/new/</kbd>"}
		{/forminput}
	</div>

	<div class="control-group">
		<label class="checkbox">
			<input type="checkbox" name="auto_bug_submit" id="auto_bug_submit"{if $auto_bug_submit} checked="checked"{/if} />Auto submit bugs
			{formhelp note="Checking this box will automatically submit fatal database errors to the Bitweaver team. If you are running a live site, consider checking this box, as it will also avoid fatal error messages from appearing to the user."}
		</label>
	</div>

	<div class="control-group">
		<label class="checkbox">
			<input type="checkbox" name="is_live" id="is_live" />Site is live
			{formhelp note="Checking this will make debugging quite difficult as it will hide errors. Only check if your site is being used in a live environment right after installation."}
		</label>
	</div>

	<div class="control-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Confirm Settings" name="submit_db_info" />
		{/forminput}
	</div>

	<input type="hidden" name="dbcase" value="{$gBitDbCaseSensitivity}" />
	<input type="hidden" name="resetdb" value="{$resetdb}" />
{/form}
