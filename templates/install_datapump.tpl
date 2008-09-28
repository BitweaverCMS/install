<h1>Sample Data</h1>

{form legend="Populating the database with useful information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>
		It's recommended to select this option to add sample data to your installation of Bitweaver. The sample data contains useful information on how to use and navigate the appropriate packages. You will enter the site with a feel for what it might look like later, when populated with actual content. This simplifies theme selection and allows you to evaluate the product more easily.
	</p>
	{*
	<p>
		This page is only available during the first installation as it can cause problems when applied more than once.
	</p>
	so? *}

	<div class="row">
		{formlabel label="Packages that can be populated"}
		{forminput}
			{if $pumpList}
				<ul>
					{foreach from=$pumpList item=file key=package}
						<li>{$package}</li>
					{/foreach}
				</ul>
			{else}
				No packages with prepared data have been installed.
			{/if}
		{/forminput}
	</div>

	<div class="row submit">
		{if $pumpList}
			<input type="submit" value="Populate my site" name="fSubmitDataPump" /> 
		{/if}
		<input type="submit" value="Skip" name="skip" />
	</div>
{/form}
