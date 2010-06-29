{strip}

<h1>Administrator Information</h1>

{form legend="Administrator Information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			{if $warning}
				{foreach from=$warning item=warn}
					<li class="warning">
						{biticon ipackage="icons" iname="dialog-warning" iexplain=warning}
						&nbsp;
						{$warn}
					</li>
				{/foreach}
			{else}
				<li class="success">
					Administrator configured successfully
				</li>
			{/if}
		</ul>
	</div>

	<div class="row">
		{formlabel label="Admin name"}
		{forminput}
			{$real_name}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Admin login"}
		{forminput}
			{$login}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Password"}
		{forminput}
			{$pass_disp}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Email"}
		{forminput}
			{$email}
		{/forminput}
	</div>

	{if $mail}
		<div class="row">
			{formlabel label="Email transport"}
			{forminput}
				{if $mail.warning}
					{formfeedback error=$mail.warning}
					{tr}You will have to consult your server adminstrator to fix this issue.{/tr}
				{else}
					{formfeedback success=$mail.success}		
					{tr}Please check your inbox to confirm that the email was sent.{/tr}
				{/if}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue install process" />
	</div>
{/form}

{/strip}
