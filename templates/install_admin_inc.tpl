<h1>Administrator Setup</h1>

{strip}
{form legend="Please enter administrator information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="form-group">
		{formfeedback error=$errors.real_name}
		{formlabel label="Full Name" for="real_name"}
		{forminput}
			<input type="text" class="form-control" name="real_name" id="real_name" value="{$smarty.session.real_name|default:'Administrator'}" />
			{formhelp note="Administrator full name."}
		{/forminput}
	</div>

	<div class="form-group">
		{formfeedback error=$errors.login}
		{formlabel label="Admin login" for="login"}
		{forminput}
			<input type="text" class="form-control" name="login" id="login" value="{$smarty.session.login|default:'admin'}" />
			{formhelp note="Administrator login username."}
		{/forminput}
	</div>

	<div class="form-group">
		{formfeedback error=$errors.password}
		{formlabel label="Password" for="password"}
		{forminput}
			<input type="password" class="form-control" name="password" id="password" maxlength="32" value="{$smarty.session.password}" />
			{formhelp note="The administrator's password should be at least 4 characters in length."}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Re-enter password" for="pass_confirm"}
		{forminput}
			<input type="password" class="form-control" name="pass_confirm" id="pass_confirm" maxlength="32" value="{$smarty.session.password}" />
			{formhelp note="Please confirm the administrators password."}
		{/forminput}
	</div>

	<div class="form-group">
		{formfeedback error=$errors.email}
		{formlabel label="Email" for="email"}
		{forminput}
			<input type="text" class="form-control" name="email" id="email" value="{$smarty.session.email}" />
			{formhelp note="Administrator email address, in case of site malfunction this email will be showen to users."}
		{/forminput}
	</div>

	<div class="form-group">
		{forminput}
			{forminput label="checkbox"}
				<input type="checkbox" name="testemail" id="testemail" value="y" checked="checked" />
				{tr}Test Email Transport{/tr}
			{/forminput}
			{formhelp note="Check this box to send a test email to the above address. This will let you know if the mailing system is working."}
		{/forminput}
	</div>

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" name="admin_submit" value="Submit Admin Information" />
		{/forminput}
	</div>
{/form}
{/strip}
