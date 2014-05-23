{strip}
<div class="row">
	<div class="col-md-8">
		<h1>Welcome to the Bitweaver Installer</h1>

		{if $gBitUser->isAdmin()}
			<p class="alert alert-block">Since this does not appear to be your first install, you can access various pages of the installer. To install new packages, please visit <strong><a href="install.php?step=3">Packages</a></strong>.</p>
		{/if}

		<p>Thank you for choosing Bitweaver. This web content management system offers an unparalleled consonance of simplicity, performance, and flexibility. For questions, comments, and support, please visit <a class="external" href="http://www.bitweaver.org">bitweaver.org</a>.  Help is available via <a class="external" href="http://www.bitweaver.org/">the forum</a> and via <a title="#bitweaver IRC Channel on freenode.net" class="external" href="http://www.bitweaver.org/wiki/Live+Support">#bitweaver chat</a>. Click to begin the install process:</p>

		{form class="" id="install_welcome"}

		<div class="control-group">
			{forminput}
				{if $gBitUser->isAdmin()}
					<a class="btn btn-default" href="{$smart.const.INSTALL_PKG_URL}?step=4">Upgrade</a> <a class="btn" href="{$smart.const.INSTALL_PKG_URL}?step=3">Install Packages</a>
					<a class="btn btn-danger pull-right" href="{$smart.const.INSTALL_PKG_URL}?step=1">Restart Installation</a>
				{else}
					<input type="hidden" name="step" value="{$next_step}" />
					<input type="submit" class="btn btn-primary" name="install" value="Begin the install process" />
				{/if}
			{/forminput}
		</div>
		{/form}
	</div>
	<div class="col-md-3">
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
