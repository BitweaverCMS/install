<h1>Sample Data</h1>

{form legend="Populating the database with useful information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>It's recommended to select this option to add sample data to your installation of Bitweaver. The sample data contains useful information on how to use and navigate the appropriate packages. You will enter the site with a feel for what it might look like later, when populated with actual content. This simplifies theme selection and allows you to evaluate the product more easily.</p>

	<div class="form-group">
		{formlabel label="Packages that can be populated"}
		{foreach from=$pumpList item=file key=package}
		{forminput label="checkbox"}
			<input type="checkbox" name="pump_package[]" value="{$package}" checked="checked"/> {$package}
		{/forminput}
		{foreachelse}
			No packages with prepared data have been installed.
		{/foreach}
	</div>

	<div class="form-group">
		{forminput}
			{if $pumpList}
				<input type="submit" class="btn btn-default" value="Populate my site" name="fSubmitDataPump" /> 
			{/if}
			<input type="submit" class="btn btn-default" value="Skip" name="skip" />
		{/forminput}
	</div>
{/form}
