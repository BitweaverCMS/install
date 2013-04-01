{* $Header$ *}

<h1>{$title|default:"You must be logged in as an administrator to run the installer."}</h1>

{form name="login" legend="Please sign in to continue" secure=$gBitSystem->isFeatureActive("site_https_login_required")}
	<div class="row">
		{formfeedback error="$error"}
		{formlabel label="Username or Email" for="user"}
		{forminput}
			<input type="text" name="user" id="user" size="25" />
			{formhelp note=""}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Password" for="pass"}
		{forminput}
			<input type="password" name="pass" id="pass" size="25" />
		{/forminput}
	</div>

	<div class="row submit">
		<input type="submit" name="login" value="{tr}Log in to {$gBitSystem->getConfig('site_title')|default:"this site"}{/tr}" />
		{if $gBitSystem->isFeatureActive('site_https_login_required') || $smarty.server.HTTPS=='on'}
			{biticon iname="emblem-readonly" ipackage="icons" iexplain="Secure Login"}
		{/if}
	</div>
{/form}


<div class="center">
	<a href="http://www.bitweaver.org/">
		<img src="{$smarty.const.INSTALL_PKG_URL}style/images/bitweaver_logo-trans.png" width="121" height="121" alt="bitweaver logo" title="Click here to visit the upgrade instructions" />
	</a>
</div>
