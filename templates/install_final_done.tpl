<h1>Installation Complete</h1>

{form action="`$smarty.const.BIT_ROOT_URL`index.php" legend="Installation has been completed sucessfully"}
	<p class="success">
		{biticon ipackage="icons" iname="dialog-ok" iexplain=success}
		Your system is ready for use now.
	</p>
	<p>bitweaver features useful helpnotes throughout. However, should you require more help, you can always contact us by any of the means mentioned below.</p>
	<p>Since we are still working hard on improving usability and stability of bitweaver, we haven't had time to translate bitweaver into various languages. If you are interested in helping us translate parts of bitweaver, please feel free to contact us.</p>
	<p>If you want to find out more about existing packages and how to install them, you can find information at <a class="external" href="http://www.bitweaver.org/wiki/index.php?page=bitweaverFeatures">bitweaverFeatures</a>.</p>
	<p>Best methods to get in contact with us:</p>
	<ul>
		<li>IRC (<a class="external" href="http://www.bitweaver.org/wiki/index.php?page=ConnectingToIrc">instructions</a> on connecting to irc)</li>
		<li><a class="external" href="http://sourceforge.net/mail/?group_id=141358">Sourceforge mailing list</a></li>
		<li>If you wish to report any bugs, we urge you to do this at <a class="external" href="http://sourceforge.net/tracker/?atid=749176&amp;group_id=1413589&amp;func=browse">Sourceforge</a></li>
		<li>the <a class="external" href="http://www.bitweaver.org/forums/viewforum.php?f=5">bitweaver Forums</a> might contain useful information.</li>
		<li><a class="external" href="http://www.bitweaver.org/">bitweaver</a> currently contains all the documentation we have.</li>
	</ul>
	<p>If you think you could contribute to bitweaver in any way, please feel free to contact us. we appreciate all the help we can get.</p>

	<hr />
	<h2>Some final notes</h2>
	<ul>
		<li>
			<strong>Security</strong>
			<ul>
				<li>
					<strong>Linux</strong>
					<br />Change the directory permission with '<span class="highlight">chmod 000 install/</span>'. If need to run the installer again, you will have to revert the permissions with '<span class="highlight">chmod 755 install/</span>'.
				</li>
				<li>
					<strong>Windows</strong>
					<br />Rename '<span class="highlight">install/install_inc.php</span>' to something like '<span class="highlight">install/install_inc.php.done</span>'
				</li>
				<li>
					<strong>bitweaver Configuration</strong>
					<br />We urge you to look at your <span class="highlight">kernel/config_inc.php</span> file. It has various useful settings for sites in production. One of these is the <strong>IS_LIVE</strong> parameter. Setting this to <strong>TRUE</strong> will prevent any visible bug reports and will therefore not display sensitive information to the user.
				</li>
			</ul>
		</li>
		<li>
			<strong>Performance</strong>
			<ul>
				<li>For production sites, we recommond you visit our <a class="external" href="http://www.bitweaver.org/wiki/bitweaverPerformance">bitweaverPerformance</a> page on how to optimise your bitweaver install.</li>
				<li>Please also have a look at your <span class="highlight">kernel/config_inc.php</span> file. It contains various settings that cannot be set elsewhere and which might be of interest to you.</li>
			</ul>
		</li>
	</ul>

	<br />
	<p class="help" style="text-align:center;">Finally, we thank you again for trying bitweaver.</p>
	<br />

	<div class="row submit">
		<input type="submit" size="20" value="Enter Your bitweaver Site" />
	</div>
{/form}
