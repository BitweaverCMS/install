<h1>Upgrade Process Completed</h1>

{form legend="Select what you want to do next"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="control-group">
		{formlabel label="Migation Results"}
		{formfeedback hash=$results}
	</div>

	<div class="control-group">
		<ul class="result">
			{if $error}
				<li class="error">
					{$error}
				</li>
			{/if}
		</ul>
	</div>

	<div class="control-group submit">
		<input type="submit" value="Continue process" />
	</div>
{/form}
