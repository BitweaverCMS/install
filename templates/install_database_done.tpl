<h1>Database Connection Information</h1>

	{if substr( PHP_OS, 0, 3 ) == 'WIN'}
		<p class="alert alert-info">
			Your server seems to run under Microsoft Windows. Please set the PHP_MAGIC_PATH constant in the configuration file.
		</p>
	{/if}
	<div class="alert alert-success">
		Your configuration was successfully created at <strong>{$smarty.const.CONFIG_PKG_PATH}kernel/config_inc.php</strong>
		<p>If you are interested in debugging or developing Bitweaver, please view this file, as there are important additional options that can not be set elsewhere. Web designers can also find some settings that helps with theme creation.</p>
	</div>

{form legend="Your database connection information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="form-group">
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

	<div class="form-group">
		{formlabel label="Database type"}
		{forminput}
			{$gBitDbType}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Host"}
		{forminput}
			{$gBitDbHost}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="User"}
		{forminput}
			{$gBitDbUser}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Password"}
		{forminput}
			{$gBitDbPassword_print}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Database name"}
		{forminput}
			{$gBitDbName}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Database prefix"}
		{forminput}
			{$db_prefix_bit|replace:"`":""}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Site base URL"}
		{forminput}
			{$bit_root_url}
		{/forminput}
	</div>

	{if isset( $has_innodb_support )}
		<div class="form-group">
			{forminput label="checkbox"}
				<input type="checkbox" name="use_innodb" id="use_innodb" {if $has_innodb_support eq 'DEFAULT'}checked="checked"{/if} />Use InnoDB tables
				{formhelp note="Your database server supports InnoDB which provides MySQL with a transaction-safe storage engine that has commit, rollback, and crash recovery capabilities. You usually want this for safest possible data storage. Otherwise the standard MyIsam engine is used."}
			{/forminput}
		</div>
	{/if}

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Continue {$section|default:"install"} process" />
		{/forminput}
	</div>
{/form}
