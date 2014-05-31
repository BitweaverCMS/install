<h1>Sample Data</h1>

{form class="form-horizontal" legend="Populating the database with useful information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>
		It's recommended to select this option to add sample data to your installation of Bitweaver. The sample data contains useful information on how to use and navigate the appropriate packages. You will enter the site with a feel for what it might look like later, when populated with actual content. This simplifies theme selection and allows you to evaluate the product more easily.
	</p>
	{*
	<p>
		This page is only available during the first installation as it can cause problems when applied more than once.
	</p>
	so? *}

	<div class="control-group column-group gutters">
		{formlabel label="Packages that can be populated"}
		{forminput}
			{foreach from=$pumpList item=file key=package}
			<label class="checkbox">
				<input type="checkbox" name="pump_package[]" value="{$package}" checked="checked"/>{$package}
			</label>
			{foreachelse}
				No packages with prepared data have been installed.
			{/foreach}
		{/forminput}
	</div>

	<div class="control-group column-group gutters">
		{forminput}
			{if $pumpList}
				<input type="submit" class="ink-button" value="Populate my site" name="fSubmitDataPump" /> 
			{/if}
			<input type="submit" class="ink-button" value="Skip" name="skip" />
		{/forminput}
	</div>
{/form}
