<h1>Sample Data</h1>

{if (count($pumpedData) == 0) }
	{assign var="formlegend" value="Database Population has been skipped"}
{else}
	{assign var="formlegend" value="Your Database has been Populated"}	
{/if}
	
	{form legend=$formlegend}

	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			{if $error}
				<li class="error">
					{biticon ipackage=liberty iname=error iexplain=error}
					The following errors occurred during the addition of the data
					<br />
					{$error}
				</li>
			{else}
				<li class="success">
					{if count($pumpedData) == 0}
						{biticon ipackage=liberty iname=success iexplain=success}
						The Sample data was not added to your database
					{else}
						{biticon ipackage=liberty iname=success iexplain=success}
						The Sample data was successfully added to your database						
					{/if}
				</li>
			{/if}
		</ul>
	</div>

	{foreach from=$pumpedData item=pumped key=package}
		<div class="row">
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

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
