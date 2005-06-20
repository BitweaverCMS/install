<h1>Installation Complete</h1>

{form ipackage='root' legend="Installation has been completed sucessfully"}
	<div class="row">
		<ul class="result">
			<li class="success">
				{biticon ipackage=liberty iname=success iexplain=success}
				Your system is ready for use now.
			</li>
			{if $script eq 'no_kill'}
				<li class="error">
					{biticon ipackage=liberty iname=error iexplain=error}
					We were unable to rename the install file to 'install.done.php'. Please rename the file yourself.
				</li>
			{/if}
			{if $renamed}
				<li class="warning">
					{biticon ipackage=liberty iname=warning iexplain=warning}
					The install file has been renamed. The installer will <strong>not</strong> work until this file has been renamed back from<br />'<strong>install/{$renamed}</strong>' to '<strong>install/install.php</strong>'
				</li>
			{else}
				<li class="warning">
					{biticon ipackage=liberty iname=warning iexplain=warning}
					We have made sure that the installer cannot be accessed without being logged in as administrator. If you feel this is not secure enough, you can rename the file from <br />'<strong>install/install.php</strong>' to <a href="install.php?kill=yes">'<strong>install/install.done.php</strong>'</a>.
				</li>
			{/if}
			<li>bitweaver features useful helpnotes throughout. However, should you require more help, you can always contact us by any of the means mentioned below.</li>
			<li>Since we are still wroking hard on improving usability and stability of bitweaver, we haven't had time to translate bitweaver into various languages. If you are interested in helping us translate parts of bitweaver, please feel free to contact us.</li>
			<li>If you want to find out more about existing packages and how to install them, you can find information at <a class="external" href="http://www.bitweaver.org/wiki/index.php?page=bitweaverFeatures">bitweaverFeatures</a>.</li>
			<li>Best methods to get in contact with us
				<ul>
					<li>IRC (<a class="external" href="http://www.bitweaver.org/wiki/index.php?page=ConnectingToIrc">instructions</a> on connecting to irc)</li>
					<li><a class="external" href="http://sourceforge.net/mail/?group_id=141358">Sourceforge mailing list</a></li>
					<li>If you wish to report any bugs, we urge you to do this at <a class="external" href="http://sourceforge.net/tracker/?atid=749176&amp;group_id=1413589&amp;func=browse">Sourceforge</a></li>
					<li>the <a class="external" href="http://www.bitweaver.org/forums/viewforum.php?f=5">bitweaver Forums</a> might contain useful information.</li>
					<li><a class="external" href="http://www.bitweaver.org/">bitweaver</a> currently contains all the documentation we have.</li>
				</ul>
			</li>
			<li>If you think you could contribute to bitweaver in any way, please feel free to contact us. we appreciate all the help we can get.</li>
			<li>&nbsp;</li>
			<li class="help" style="text-align:center;">Finally, we thank you again for trying bitweaver.</li>
		</ul>
	</div>

	<div class="row submit">
		<input type="submit" size="20" value="Enter Your bitweaver Site" />
	</div>
{/form}
