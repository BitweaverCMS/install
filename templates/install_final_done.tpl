<h1>Installation Complete</h1>

{form action="`$smarty.const.BIT_ROOT_URL`index.php" legend="Installation has been completed sucessfully"}
	<p class="success">
		Your system is ready for use now.
	</p>
	<p>Bitweaver offers helpnotes throughout. Should you require more help, you can always contact Bitweaver's developers by any of the means mentioned below. To find out more about existing packages and how to install them, visit <a class="external" href="http://www.bitweaver.org/wiki/index.php?page=bitweaverFeatures">Bitweaver Features</a>.</p>
	<p>To get in contact with Bitweaver developers:</p>
	<ul>
		<li><a class="external" href="http://www.bitweaver.org/wiki/Live+Support">chat:</a> #bitweaver on freenode.net</li>
		<li><a class="external" href="http://sourceforge.net/mail/?group_id=141358">mailing list at sourceforge.net</a></li>
		<li><a class="external" href="http://www.bitweaver.org/forums/viewforum.php?f=5">bitweaver.org Forums</a></li>
		<li><a class="external" href="http://www.bitweaver.org/">bitweaver.org</a> contains all available documentation</li>
		<li>submit bugs to Bitweaver's <a class="external" href="http://sourceforge.net/tracker/?group_id=141358&atid=749176">bug tracker at sourceforge.net</a></li>
	</ul>
	<p>If you feel like contributing to Bitweaver, contact us! Bitweaver is free and Open Source to all. Translators, testers, admins, release managers, developers, programmers, designers, <em>we want you!</em> :)</p>

	<h2>Some final notes</h2>
	<ul>
		<li>
			<strong>Security</strong>
			<ul>
				<li>
					<strong>Linux</strong>
					<br />Change the directory permission with <kbd>chmod 000 install/</kbd>. If need to run the installer again, you will have to revert the permissions with <kbd>chmod 755 install/</kbd>.
				</li>
				<li>
					<strong>Windows</strong>
					<br />Rename <kbd>install/install_inc.php</kbd> to something like <kbd>install/install_inc.php.done</kbd>
				</li>
				<li>
					<strong>bitweaver Configuration</strong>
					<br />We urge you to look at your <kbd>kernel/config_inc.php</kbd> file. It has various useful settings for sites in production. One of these is the <strong>IS_LIVE</strong> parameter. Setting this to <strong>TRUE</strong> will prevent any visible bug reports and will therefore not display sensitive information to the user.
				</li>
			</ul>
		</li>
		<li>
			<strong>Performance</strong>
			<ul>
				<li>For production sites, we recommond you visit our <a class="external" href="http://www.bitweaver.org/wiki/Bitweaver+Performance">Bitweaver Performance</a> page on how to optimise your Bitweaver install.</li>
				<li>Please also have a look at your <kbd>kernel/config_inc.php</kbd> file. It contains various settings that cannot be set elsewhere and which might be of interest to you.</li>
			</ul>
		</li>
	</ul>

	<br />
	<p class="help" style="text-align:center;">Finally, we thank you again for trying Bitweaver.</p>
	<br />

	<div class="row submit">
		<input type="submit" size="20" value="Enter your Bitweaver site" />
	</div>
{/form}
