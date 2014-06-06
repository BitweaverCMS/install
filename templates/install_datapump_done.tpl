<h1>Sample Data</h1>

{if (count($pumpedData) == 0) }
	{assign var="formlegend" value="Database Population has been skipped"}
{else}
	{assign var="formlegend" value="Your Database has been Populated"}	
{/if}
	
	{form legend=$formlegend}

	<input type="hidden" name="step" value="{$next_step}" />

	<div class="form-group">
		<ul class="result">
			{if $error}
				<li class="error">
					The following errors occurred during the addition of the data
					<br />
					{$error}
				</li>
			{else}
				<li class="success">
					{if count($pumpedData) == 0}
						The Sample data was not added to your database
					{else}
						The Sample data was successfully added to your database						
					{/if}
				</li>
			{/if}
		</ul>
	</div>

	{foreach from=$pumpedData item=pumped key=package}
		<div class="form-group">
			{formlabel label=$package}
			{forminput}
				<ul>
					{foreach from=$pumped item=page}
						<li>{$page}</li>
					{/foreach}
				</ul>
			{/forminput}
		</div>
	{/foreach}

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Continue install process" />
		{/forminput}
	</div>
{/form}
