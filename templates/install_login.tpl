{* $Header: /cvsroot/bitweaver/_bit_install/templates/install_login.tpl,v 1.3 2008/10/03 09:19:40 squareing Exp $ *}

<h1>{$title|default:"You must be logged in as an administrator to run the installer."}</h1>

{include file="bitpackage:users/login_inc.tpl"}

<div class="center">
	<a href="http://www.bitweaver.org/">
		<img src="{$smarty.const.INSTALL_PKG_URL}style/images/bitweaver_logo-trans.png" width="121" height="121" alt="bitweaver logo" title="Click here to visit the upgrade instructions" />
	</a>
</div>
