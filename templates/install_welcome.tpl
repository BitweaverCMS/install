{strip}
<h1>Welcome to the Bitweaver Installer</h1>

{form id="install_welcome"}
	{legend legend=""}
		<input type="hidden" name="step" value="{$next_step}" />

		{if $gBitUser->isAdmin()}
			<p class="warning">Since this does not appear to be your first install, you can access various pages of the installer. To install new packages, please visit <strong><a href="install.php?step=3">Packages</a></strong>.</p>
		{/if}

		<p>Thank you for choosing Bitweaver. This web content management system offers an unparalleled consonance of simplicity, performance, and flexibility. For questions, comments, and support, please visit <a class="external" href="http://www.bitweaver.org">bitweaver.org</a>.  Help is available via <a class="external" href="http://www.bitweaver.org/">the forum</a> and via <a title="#bitweaver IRC Channel on freenode.net" class="external" href="http://www.bitweaver.org/wiki/Live+Support">#bitweaver chat</a>. Click to begin the install process:</p>

		<div class="row submit">
			<input type="submit" name="install" value="Begin the install process" />
			<p><strong>This installer will guide you through the installation or upgrade.</strong></p>
		</div>

		{*<p class="warning">If you want to <strong>upgrade</strong> from Bitweaver version 1, begin the install process now. You will find the upgrader on the <strong>Install Options</strong> page.</p>*}

		<table>
			<!-- thead>
				<tr>
					<th>you install:</th>
					<th>your get:</th>
				</tr>
			</thead -->
			<tbody>
				<tr>
					<td class="center">
						<img src="{$smarty.const.INSTALL_PKG_URL}style/images/bitweaver_logo-trans.png" width="121" height="121" />
					</td>
				</tr>
				<tr>
					<td class="center">
						<ul>
							<li>free, gratis, and open source</li>
							<li>modular, fast, and flexible</li>
							<li>easy to use, easy to extend</li>
							<li>many 1st class 3rd party components</li>
							<li>a community that supports you</li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>
	{/legend}
{/form}
{/strip}
