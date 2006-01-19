<h1>Installation Complete</h1>

{form action="`$smarty.const.BIT_ROOT_URL`index.php" legend="Installation has been completed sucessfully"}
	<p class="success">
		{biticon ipackage=liberty iname=success iexplain=success}
		Your system is ready for use now.
	</p>
	{if $script eq 'no_kill'}
		<p class="error">
			{biticon ipackage=liberty iname=error iexplain=error}
			We were unable to rename the install file to 'install.php.done'. Please rename the file yourself.
		</p>
	{/if}
	{if $renamed}
		<p class="warning">
			{biticon ipackage=liberty iname=warning iexplain=warning}
			The install file has been renamed. The installer will <strong>not</strong> work until this file has been renamed back from<br />'<strong>install/{$renamed}</strong>' to '<strong>install/install.php</strong>'
		</p>
	{else}
		<p class="warning">
			{biticon ipackage=liberty iname=warning iexplain=warning}
			We have made sure that the installer cannot be accessed without being logged in as administrator. If you feel this is not secure enough, you can rename the file from <br />'<strong>install/install.php</strong>' to <a href="install.php?kill=yes">'<strong>install/install.php.done</strong>'</a>. Or change the directory permission with 'chmod -R 000 {$smarty.const.INSTALL_PKG_PATH}'. You will need to run the installer again, you will have to revert the permissions with ''chmod -R 755 {$smarty.const.INSTALL_PKG_PATH}'.
		</p>
	{/if}
	<p>bitweaver features useful helpnotes throughout. However, should you require more help, you can always contact us by any of the means mentioned below.</p>
	<p>Since we are still wroking hard on improving usability and stability of bitweaver, we haven't had time to translate bitweaver into various languages. If you are interested in helping us translate parts of bitweaver, please feel free to contact us.</p>
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
	<br />
	<p class="help" style="text-align:center;">Finally, we thank you again for trying bitweaver.</p>

	<div class="row submit">
		<input type="submit" size="20" value="Enter Your bitweaver Site" />
	</div>
{/form}
