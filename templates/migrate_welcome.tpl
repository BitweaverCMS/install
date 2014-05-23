<h1>Bitweaver migrate tool</h1>

{form legend="Begin the migrate process"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>Welcome to the new and improved Bitweaver migrate process. Our migrate scripts are currently still in development and we cannot take any reponsibility for any loss of data that occurs due to the use of these scripts. Having said this, we are doing our best to make this migrate process as reliable and complete as we possibly can. Due to this, we urge you to follow the instructions here carefully before you proceed. We have done our best to make sure all situations are handled. However, your install might have the one case we haven't run into yet. Initial steps before beginning the actual migrate stages:</p>
	
	<p class="alert alert-block"><strong>Make a backup</strong><br />You should have a spare dump of your database before you run this. (Of course, you already have a cron job making nightly backups and scp'ing them to another host? Right? Right.)</p>

	<p class="alert alert-block"><strong>Do a trial run first</strong><br />You should run a trial migrate on an offline server, personal machine, etc. before you do this on your live site.</p>

	<p class="alert alert-block">Migrates can <strong>take a long time</strong><br />Make sure your max_execution_time in your php.ini is large enough for your site.</p>

	<strong>{formfeedback warning=$dbWarning}</strong>

	<div class="control-group">
		{forminput}
			<input type="submit" class="btn btn-default" name="fSubmitWelcome" value="{$warningSubmit|default:"Begin the migrate process!"}" />
		{/forminput}
	</div>
{/form}
