<h1>bitweaver Upgrade Tool</h1>

{form legend="Begin the upgrade process"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>Welcome to the new and improved bitweaver upgrade process. Our upgrade scripts are currently still in development and we cannot take any reponsibility for any loss of data that occurs due to the use of these scripts. Having said this, we are doing our best to make this upgrade process as reliable and complete as we possibly can. Due to this, we urge you to follow the instructions here carefully before you proceed.</p>
	<p>Initial steps before beginning the actual upgrade stages.</p>
	<p class="warning"><strong>Make a Backup</strong><br />You should have a spare dump of your database before you run this. (Of course, you already have a nightly cron job making nightly backups and scp'ing them to another host? right? right.)</p>
	<br />
	<p class="warning"><strong>Do a Trial Run first</strong><br />You should run a trial upgrade on an offline server, personal machine, etc. before you do this on your live site.</p>
	<br />
	<p class="warning">Upgrades can <strong>take a long time</strong><br />Make sure your max_execution_time in your php.ini is large enough for your site.</p>
	<strong>{formfeedback warning=$dbWarning}</strong>
	<p>We have done our best to make sure all situations are handled. However, your install might have the one case we haven't run into yet.</p>

	<div class="row submit">
		<input type="submit" name="fSubmitWelcome" value="{$warningSubmit|default:"Begin the Upgrade process!"}" />
	</div>
{/form}
