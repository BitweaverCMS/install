{* $Header$ *}

<h1>{$title|default:"You must be logged in as an administrator to run the installer."}</h1>

{form name="login" legend="Please sign in to continue"}
	<div class="form-group">
		{formfeedback error="$error"}
		{formlabel label="Username or Email" for="user"}
		{forminput}
			<input type="text" class="form-control" name="user" id="user" />
			{formhelp note=""}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Password" for="pass"}
		{forminput}
			<input type="password" class="form-control" name="pass" id="pass" />
		{/forminput}
	</div>

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" name="signin" value="{tr}Log in to {$gBitSystem->getConfig('site_title')|default:"this site"}{/tr}" />
		{/forminput}
	</div>
{/form}


<div class="center">
	<a href="http://www.bitweaver.org/">
		<img src="{$smarty.const.INSTALL_PKG_URL}css/images/bitweaver_logo-trans.png" width="121" height="121" alt="bitweaver logo" title="Click here to visit the upgrade instructions" />
	</a>
</div>
