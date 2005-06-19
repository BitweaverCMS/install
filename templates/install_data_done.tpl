<h1>Sample Data</h1>

{form legend="Your Database has been Populated"}
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
					{biticon ipackage=liberty iname=success iexplain=success}
					The Sample data was successfully added to your database
				</li>
			{/if}
		</ul>
	</div>

	{foreach from=$pumpedData item=pumped key=package}
		<div class="row">
			{formlabel label=$package}
			{forminput}
				{foreach from=$pumped item=page}
					{formfeedback note=$page}
				{/foreach}
			{/forminput}
		</div>
	{/foreach}

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
