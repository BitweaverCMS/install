<h1>Upgrade Process Completed</h1>

{form class="form-horizontal" legend="Select what you want to do next"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="control-group column-group gutters">
		{formlabel label="Migation Results"}
		{formfeedback hash=$results}
	</div>

	<div class="control-group column-group gutters">
		<ul class="result">
			{if $error}
				<li class="error">
					{$error}
				</li>
			{/if}
		</ul>
	</div>

	<div class="control-group column-group gutters">
		{forminput}
			<input type="submit" class="ink-button" value="Continue process" />
		{/forminput}
	</div>
{/form}
