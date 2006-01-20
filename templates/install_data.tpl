<h1>Sample Data</h1>

{form legend="Populate Your Database With Useful Information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>
		Here we provide you with the option to add some sample data to your installation of bitweaver.
		If this is your first installation, we recommend that you take advantage of this option,
		since the information added contains useful information on how to use and navigate the appropriate packages.
	</p>
	<p>
		Also, by adding this data to your database you will enter the site with a feel for what it will look like when populated with your own data.
		This simplifies theme selection and allows you to evaluate the product more easily.
	</p>
	<p>
		This page is only available during the first installation as it can cause problems when applied more than once.
	</p>

	<div class="row">
		{formlabel label="Packages that can be populated"}
		{forminput}
			{if $pumpList}
				<ul>
					{foreach from=$pumpList item=pump}
						<li>{$pump}</li>
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
		<input type="submit" value="skip" name="skip" />
	</div>
{/form}
