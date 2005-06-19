{* $Header: /cvsroot/bitweaver/_bit_install/templates/install_login.tpl,v 1.1 2005/06/19 04:51:19 bitweaver Exp $ *}

<h1>You must be logged in as an administrator to run the installer.</h1>

<form name="loginbox" action="{$login_url}" method="post" {if $gBitSystemPrefs.feature_challenge eq 'y'}onsubmit="doChallengeResponse()"{/if}>
	{if $gBitSystemPrefs.feature_challenge eq 'y'}
		<script language="javascript" type="text/javascript" src="lib/md5.js"></script>
		{literal}
			<script language="Javascript" type="text/javascript">
			<!--
			function doChallengeResponse() {
			hashstr = document.loginbox.user.value +
			document.loginbox.pass.value +
			document.loginbox.email.value;
			str = document.loginbox.user.value +
			MD5(hashstr) +
			document.loginbox.challenge.value;
			document.loginbox.response.value = MD5(str);
			document.loginbox.pass.value='';
			/*
			document.login.password.value = "";
			document.logintrue.username.value = document.login.username.value;
			document.logintrue.response.value = MD5(str);
			document.logintrue.submit();
			*/
			document.loginbox.submit();
			return false;
			}
			// -->
			</script>
		{/literal}
		<input type="hidden" name="challenge" value="{$challenge|escape}" />
		<input type="hidden" name="response" value="" />
	{/if}

	{legend legend="Please log in"}
		<div class="row">
			{formlabel label="Username" for="login-user"}
			{forminput}
				<input type="text" name="user" id="login-user" size="15" />
			{/forminput}
		</div>

		{if $gBitSystemPrefs.feature_challenge eq 'y'}
		<div class="row">
			{formlabel label="email" for="login-email"}
			{forminput}
				<input type="text" name="email" id="login-email" size="15" />
			{/forminput}
		</div>
		{/if}

		<div class="row">
			{formlabel label="Password" for="login-pass"}
			{forminput}
				<input type="password" name="pass" id="login-pass" size="15" />
			{/forminput}
		</div>

		<div class="row submit">
			<input type="submit" name="login" value="{tr}login{/tr}" />
		</div>

		{if $http_login_url ne '' or $https_login_url ne ''}
			<a href="{$http_login_url}" title="{tr}Click here to login using the default security protocol{/tr}">{tr}standard{/tr}</a> |
			<a href="{$https_login_url}" title="{tr}Click here to login using a secure protocol{/tr}">{tr}secure{/tr}</a>
		{/if}
		{if $show_stay_in_ssl_mode eq 'y'}
			<label for="login-stayssl">{tr}stay in ssl mode{/tr}:</label>
			<input type="checkbox" name="stay_in_ssl_mode" id="login-stayssl" {if $stay_in_ssl_mode eq 'y'}checked="checked"{/if} />
		{/if}
		{if $show_stay_in_ssl_mode ne 'y'}
			<input type="hidden" name="stay_in_ssl_mode" value="{$stay_in_ssl_mode|escape}" />
		{/if}
	{/legend}
</form>
