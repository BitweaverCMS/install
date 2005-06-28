<h1>Database Connection Information</h1>

{form legend="Your database connection information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			{if $error}
				<li class="error">
					{biticon ipackage=liberty iname=error iexplain=error}
					{$error}
				</li>
			{else}
				<li class="success">
					{biticon ipackage=liberty iname=success iexplain=success}
					A connection to your database was sucessfully established
				</li>
			{/if}
		</ul>
	</div>

	<div class="row">
		{formlabel label="Database type"}
		{forminput}
			{formfeedback note=$gBitDbType}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Host"}
		{forminput}
			{formfeedback note=$gBitDbHost}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="User"}
		{forminput}
			{formfeedback note=$gBitDbUser}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Password"}
		{forminput}
			{formfeedback note=$gBitDbPassword_print}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Database name"}
		{forminput}
			{formfeedback note=$gBitDbName}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Database Prefix"}
		{forminput}
			{formfeedback note=$db_prefix_bit|replace:"`":""}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Base Url"}
		{forminput}
			{formfeedback note=$root_url_bit}
		{/forminput}
	</div>

	<div class="row">
		<p>
			This information was stored in the file '<strong>{$gBitLoc.KERNEL_PKG_PATH}config_inc.php</strong>'. if you should have to modify the settings at some point, you can use this installer, or modify that file directly.
		</p>
		<p>
			If you are interested in debugging bitweaver, please view this file, as there are some additional debugging options that can't be set elsewhere.
		</p>
	</div>

	<div class="row submit">
		<input type="submit" value="Continue {$section|default:"Install"} Process" />
	</div>
{/form}
