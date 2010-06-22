<h1>Database Connection Information</h1>

{form legend="Your database connection information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			{if $error}
				<li class="error">
					{$error}
				</li>
			{else}
				<li class="success">
					A connection to your database was sucessfully established
				</li>
			{/if}
		</ul>
	</div>

	<div class="row">
		{formlabel label="Database type"}
		{forminput}
			{$gBitDbType}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Host"}
		{forminput}
			{$gBitDbHost}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="User"}
		{forminput}
			{$gBitDbUser}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Password"}
		{forminput}
			{$gBitDbPassword_print}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Database name"}
		{forminput}
			{$gBitDbName}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Database prefix"}
		{forminput}
			{$db_prefix_bit|replace:"`":""}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site base URL"}
		{forminput}
			{$bit_root_url}
		{/forminput}
	</div>

	<div class="row">
		<p class="success">
			This information was stored in the file:<br />
			<strong>{$smarty.const.CONFIG_PKG_PATH}kernel_config.php</strong>
		</p>
		{if substr( PHP_OS, 0, 3 ) == 'WIN'}
			<p class="warning">
				Your server seems to run under Microsoft Windows. Please set the PHP_MAGIC_PATH constant in the configuration file.
			</p>
		{/if}
		<p>
			If you are interested in debugging or developing Bitweaver, please view this file, as there are important additional options that can not be set elsewhere. Web designers can also find some settings that helps with theme creation.
		</p>
	</div>

	{if isset( $has_innodb_support )}
		<div class="row">
			{formlabel label="Use InnoDB tables" for="use_innodb"}
			{forminput}
				<input type="checkbox" name="use_innodb" id="use_innodb" {if $has_innodb_support eq 'DEFAULT'}checked="checked"{/if} />
				{formhelp note="Your database server supports InnoDB which provides MySQL with a transaction-safe storage engine that has commit, rollback, and crash recovery capabilities. You usually want this for safest possible data storage. Otherwise the standard MyIsam engine is used."}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue {$section|default:"install"} process" />
	</div>
{/form}
