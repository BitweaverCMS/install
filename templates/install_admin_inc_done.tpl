{strip}

<h1>Administrator Information</h1>

{form legend="Administrator Information"}
	<input type="hidden" name="step" value="{$next_step}" />

	{if $warning}
		<div class="alert alert-warning">
			<ul class="result">
			{foreach from=$warning item=warn}
				<li class="warning">
					{booticon iname="icon-warning-sign"  ipackage="icons"  iexplain=warning}
					&nbsp;
					{$warn}
				</li>
			{/foreach}
			</div>
		</ul>
	{else}
		<div class="alert alert-success">
			Administrator configured successfully
		</div>
	{/if}

	<div class="form-group">
		{formlabel label="Admin name"}
		{forminput}
			{$real_name}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Admin login"}
		{forminput}
			{$login}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Password"}
		{forminput}
			{$pass_disp}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Email"}
		{forminput}
			{$email}
		{/forminput}
	</div>

	{if $mail}
		<div class="form-group">
			{formlabel label="Email transport"}
			{forminput}
				{if $mail.warning}
					{formfeedback error=$mail.warning}
					{tr}You will have to consult your server adminstrator to fix this issue.{/tr}
				{else}
					{formfeedback note="`$mail.success` Please check your inbox to confirm that the email was sent."}
				{/if}
			{/forminput}
		</div>
	{/if}

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Continue install process" />
		{/forminput}
	</div>
{/form}

{/strip}
