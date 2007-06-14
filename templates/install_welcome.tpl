<h1>Welcome to the bitweaver installer</h1>

{form}
	{legend legend="Begin the installation process"}
		<input type="hidden" name="step" value="{$next_step}" />

		{if $gBitUser->isAdmin()}
			<p class="warning">Since this does not appear to be your first
			install, you can use the navigation on the right to access various
			pages of the installer.  To install new packages, please visit the
			<strong>Package Installation</strong> page.</p>
		{/if}

		<p> Thank you for choosing bitweaver. This web application offers an
		unparalled combination of flexibility, performance, and simplicity.</p>

		<p> For questions, comments, or support, please don't hesitate to visit <a
		class="external"
		href="http://www.bitweaver.org">http://www.bitweaver.org</a>.  Help is
		available via <a class="external"
		href="http://www.bitweaver.org/forums/viewforum.php?f=5">the forums</a> or
		come and visit us at <a class="external"
		href="irc://irc.freenode.net:6667/bitweaver">#bitweaver</a> on irc (if the
		irc link doesn't work, there are <a class="external"
		href="http://www.bitweaver.org/wiki/index.php?page=ConnectingToIrc">detailed
		directions</a> on how to meet up with us on irc).</p>

		<p>This installer will guide you through the installation of bitweaver.
		</p>

		<div class="row submit">
			<input type="submit" name="install" value="Begin the Install process" />
		</div>
	{/legend}
{/form}
