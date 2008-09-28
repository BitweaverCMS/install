<h2>Here you can migrate your database from one system to another</h2>
{form}
	<input type="hidden" name="step" value="{$next_step}" />
	<input type="hidden" name="gBitDbPassword_hash" value="{$gBitDbPassword_hash}" />

	{jstabs}
		{jstab title="Source Database"}
			{legend legend="Source Database Information"}
				<div class="row">
					{if $error_src}
						<ul class="result">
							<li class="error">
								Database connection could not be established.
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
							</li>
						</ul>
					{/if}
				</div>

				<div class="row">
					{formlabel label="Source database type" for="db_src"}
					{forminput}
						{if $dbservers}
							{html_options name='db_src' options=$dbservers id=db_src selected=$db_src}
						{else}
							{formfeedback warning='You currently have no database installed that works here. If you feel this is wrong, please contact the <a class="external" href="http://www.bitweaver.org/">Bitweaver Team</a>.'}
						{/if}
						{formhelp note="The type of database you intend to use."}
						{formfeedback warning="If the database you wish to use is not listed above, the version of PHP on this server does not have support for that database installed or compiled in."}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Source host" for="host_src"}
					{forminput}
						<input type="text" size="25" name="host_src" id="host_src" value="{if $host_src ne '' }{$host_src}{/if}" />
						{formhelp note="Hostname or IP for your MySQL database, example:<br />
							Use 'localhost' if your database is on the same machine as your server.<br />
							If you use Oracle, insert your TNS name here<br />
							If you use SQLite, insert the path and filename to your database file<br />
							If you are not sure what to put in here, try using localhost."}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Source user" for="user_src"}
					{forminput}
						<input type="text" size="25" name="user_src" id="user_src" value="{$user_src}" />
						{formhelp note="Database user"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Source Password" for="pass_src"}
					{forminput}
						<input type="password" size="25" name="pass_src" id="pass_src" value="{$pass_src}" />
						{formhelp note="Database password"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Source database name" for="name_src"}
					{forminput}
						<input type="text" size="25" name="name_src" id="name_src" value="{$name_src}" />
						{ if ( $fbpath ) }
							{formhelp note="The name of the database where Bitweaver will create tables. You can
								create a Firebird alias for the Bitweaver database in aliases.conf and then use that
								aliase as the database name, or provide a full path and file name to create
								the database in an existing directory."}
						{else}
							{formhelp note="The name of the database where Bitweaver will create tables. You can
								create the database using mysqladmin, or PHPMyAdmin or ask your
								hosting service to create a MySQL database.
								Normally Bitweaver tables won't conflict with other product names."}
						{/if}
					{/forminput}
				</div>

				<div class="row">
				{ if ( $fbpath ) }
					{formhelp note="<strong>Do not use prefix with Firebird, as the field and table names are already up to 30 characters.</strong>"}
				{/if}
					{formlabel label="Source Database Prefix" for="prefix_src"}
					{forminput}
						<input type="text" size="25" name="prefix_src" id="prefix_src" value="{$prefix_src}" />
						{formhelp note="This prefix will be prepended to the begining of every table name to allow multiple
							independent install to share a single database. All Bitweaver tables begin with 'bit_' or 'users_',
							so you rarely need to enter a prefix. If you are NOT running MySQL (i.e. Postgres, Oracle, etc.)
							you can end the prefix string with a '.' (period) to use a schema in systems that support it.
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
			{/legend}
		{/jstab}

		{jstab title="Destination Database"}
			{legend legend="Destination Database Information"}
				<div class="row">
					{if $error_dst}
						<li class="error">
							Database connection could not be established.
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
						</li>
						</li>
					{/if}
				</div>

				<div class="row">
					{formlabel label="Destination Database type" for="db_dst"}
					{forminput}
						{if $dbservers}
							{html_options name='db_dst' options=$dbservers id=db_dst selected=$gBitDbType}
						{else}
							{formfeedback warning='You currently have no Database installed that works here. If you feel this is wrong, please contact the <a class="external" href="http://www.bitweaver.org/">Bitweaver Team</a>.'}
						{/if}
						{formhelp note="The type of database you intend to use."}
						{formfeedback warning="If the database you wish to use is not listed above, the version of PHP on this server does not have support for that database installed or compiled in."}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Destination Host" for="host_dst"}
					{forminput}
						<input type="text" size="25" name="host_dst" id="host_dst" value="{if $gBitDbHost ne '' }{$gBitDbHost}{/if}" />
						{formhelp note="Hostname or IP for your MySQL database, example:<br />
							Use 'localhost' if your database is on the same machine as your server.<br />
							If you use Oracle, insert your TNS Name here<br />
							If you use SQLite, insert the path and filename to your database file<br />
							If you are not sure what to put in here, try using localhost."}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Destination user" for="user_dst"}
					{forminput}
						<input type="text" size="25" name="user_dst" id="user_dst" value="{$gBitDbUser}" />
						{formhelp note="Database user"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Destination password" for="pass_dst"}
					{forminput}
						<input type="password" size="25" name="pass_dst" id="pass_dst" value="{$gBitDbPassword_input}" />
						{formhelp note="Database password"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Destination database name" for="name_dst"}
					{forminput}
						<input type="text" size="25" name="name_dst" id="name_dst" value="{$gBitDbName}" />
						{ if ( $fbpath ) }
							{formhelp note="The name of the database where Bitweaver will create tables. You can
								create a Firebird alias for the Bitweaver database in aliases.conf and then use that
								aliase as the database name, or provide a full path and file name to create
								the database in an existing directory."}
						{else}
							{formhelp note="The name of the database where Bitweaver will create tables. You can
								create the database using mysqladmin, or PHPMyAdmin or ask your
								hosting service to create a MySQL database.
								Normally Bitweaver tables won't conflict with other product names."}
						{/if}
					{/forminput}
				</div>

				<div class="row">
				{ if ( $fbpath ) }
					{formhelp note="<strong>Do not use prefix with Firebird, as the field and table names are already up to 30 characters.</strong>"}
				{/if}
					{formlabel label="Destination Database Prefix" for="prefix_dst"}
					{forminput}
						<input type="text" size="25" name="prefix_dst" id="prefix_dst" value="{$db_prefix_bit}" />
						{formhelp note="This prefix will be prepended to the begining of every table name to allow multiple
							independent install to share a single database. All Bitweaver tables begin with 'bit_' or 'users_',
							so you rarely need to enter a prefix. If you are NOT running MySQL (i.e. Postgres, Oracle, etc.)
							you can end the prefix string with a '.' (period) to use a schema in systems that support it.
							<strong>MySQL does NOT support schemas.</strong>"}
					{/forminput}
				</div>

				{ if ( $fbpath ) }
				<div class="row">
					{formlabel label="Firebird installation path" for="fbpath"}
					{forminput}
						<input type="text" size="50" name="fbpath" id="fbpath" value="{$fbpath}" />
						{formhelp note="If you have modified your Firebird installation from the default please enter the correct
							path to the base firebird directory. This is used to find isql in order to create the initial blank
							database and should be maintained in the correct format for your OS."}
					{/forminput}
				</div>
				{/if}

				<div class="row">
					{formlabel label="Site Base URL" for="baseurl"}
					{forminput}
						<input type="text" size="25" name="baseurl" id="baseurl" value="{$bit_root_url}" />
						{formhelp note="This is the path from the server root to your Bitweaver location, i.e., if you access Bitweaver as <kbd>http://MyServer.com/applications/new/wiki/index.php</kbd> you should enter <kbd>/applications/new/</kbd>"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Automatically submit bugs" for="auto_bug_submit"}
					{forminput}
						<input type="checkbox" name="auto_bug_submit" id="auto_bug_submit"{if $auto_bug_submit} checked="checked"{/if} />
						{formhelp note="Checking this box will automatically submit fatal database errors to the Bitweaver team. If you are running a live site, we recommend you check this box, as it will also avoid horrible error messages from appearing in such cases."}
					{/forminput}
				</div>
			{/legend}
		{/jstab}

		{jstab title="Options"}
			{legend legend="Migration options"}
				<div class="row">
					{formlabel label="Tables to be skipped" for="skip_tables"}
					{forminput}
						<select name="skip_tables[]" id="skip_tables" multiple="multiple" size="10">
						{foreach from=$skip_tables item=table}
							<option value="{$table}"{foreach from=$skip_tables_select item=select}
								{if $select eq $table} selected="selected"{/if}
							{/foreach}>{$table}</option>
						{/foreach}
						</select>
						<br />
						<input type="submit" value="Update Tables List" name="fUpdateTables" />
						{formhelp note="Please select all talbes that are not supposed to be migrated at all. You can pick some tables
							here, if you prefer to migrate specific tables separately at a later timepoint. Use Ctrl+click to select
							more than one, or Ctrl+A to select all tables."}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="DROP tables" for="empty_tables"}
					{forminput}
						<input type="checkbox" name="empty_tables" id="empty_tables"{if $empty_tables} checked="checked"{/if} />
						{formhelp note="Checking this box DROP's tables before new data is migrated"}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Convert Blobs" for="convert_blobs"}
					{forminput}
						<input type="checkbox" name="convert_blobs" id="convert_blobs"{if $convert_blobs} checked="checked"{/if} />
						{formhelp note="Checking this box converts blobs from a MySQL type blob to a PgSQL encoded blob."}
					{/forminput}
				</div>

				<div class="row">
					{formlabel label="Stop on Errors" for="stop_on_errors"}
					{forminput}
						<input type="checkbox" name="stop_on_errors" id="stop_on_errors"{if $stop_on_errors} checked="checked"{/if} />
						{formhelp note="Checking this box will cause the script to stop on the first error."}
					{/forminput}
				</div>

				<div class="row">
					{forminput}
						<label><input type="checkbox" name="debug" id="debug"{if $debug} checked="checked"{/if} /> Debug mode</label>
						{formhelp note="Display SQL statements."}
					{/forminput}
				</div>
			{/legend}
		{/jstab}
	{/jstabs}

	<div class="row submit">
		<input type="submit" value="Execute Migration" name="fSubmitDatabase" />
	</div>
{/form}
