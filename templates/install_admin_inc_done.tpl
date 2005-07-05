{strip}

<h1>Administrator Information</h1>

{form legend="Administrator Information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			{if $warning}
				{foreach from=$warning item=warn}
					<li class="warning">
						{biticon ipackage=liberty iname=warning iexplain=warning}
						{$warn}
					</li>
				{/foreach}
			{else}
				<li class="success">
					{biticon ipackage=liberty iname=success iexplain=success}
					Administrator configured successfully
				</li>
			{/if}
		</ul>
	</div>

	<div class="row">
		{formlabel label="Admin name"}
		{forminput}
			{formfeedback note=$real_name}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Admin login"}
		{forminput}
			{formfeedback note=$login}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Password"}
		{forminput}
			{formfeedback note=$pass_disp}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Email"}
		{forminput}
			{formfeedback note=$email}
		{/forminput}
	</div>

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}

{/strip}
