{strip}
<div class="row">
	<div class="span8">
		<h1>Welcome to the Bitweaver Installer</h1>

		{if $gBitUser->isAdmin()}
			<p class="alert alert-block">Since this does not appear to be your first install, you can access various pages of the installer. To install new packages, please visit <strong><a href="install.php?step=3">Packages</a></strong>.</p>
		{/if}

		<p>Thank you for choosing Bitweaver. This web content management system offers an unparalleled consonance of simplicity, performance, and flexibility. For questions, comments, and support, please visit <a class="external" href="http://www.bitweaver.org">bitweaver.org</a>.  Help is available via <a class="external" href="http://www.bitweaver.org/">the forum</a> and via <a title="#bitweaver IRC Channel on freenode.net" class="external" href="http://www.bitweaver.org/wiki/Live+Support">#bitweaver chat</a>. Click to begin the install process:</p>

		{form class="" id="install_welcome"}
		<input type="hidden" name="step" value="{$next_step}" />

		<div class="control-group">
			{forminput}
				<input type="submit" class="btn btn-primary" name="install" value="Begin the install process" />
			{/forminput}
			<p><strong>This installer will guide you through the installation or upgrade.</strong></p>
		</div>
		{/form}
	</div>
	<div class="span3">
		<div class="aligncenter"><img src="{$smarty.const.INSTALL_PKG_URL}css/images/bitweaver_logo-trans.png" alt="logo" /></div>
		<ul>
			<li>free, gratis, and open source</li>
			<li>modular, fast, and flexible</li>
			<li>easy to use, easy to extend</li>
			<li>many 1st class 3rd party components</li>
		</ul>
	</div>
</div>
{/strip}
