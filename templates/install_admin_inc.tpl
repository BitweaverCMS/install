<h1>Administrator Information</h1>

{strip}
{form legend="Please enter administrator information"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		{formfeedback error=`$errors.real_name`}
		{formlabel label="Full Name" for="real_name"}
		{forminput}
			<input type="text" name="real_name" id="real_name" value="Administrator" />
			{formhelp note="Administrator full name."}
		{/forminput}
	</div>

	<div class="row">
		{formfeedback error=`$errors.login`}
		{formlabel label="Admin login" for="login"}
		{forminput}
			<input type="text" name="login" id="login" value="admin" />
			{formhelp note="Administrator login username."}
		{/forminput}
	</div>

	<div class="row">
		{formfeedback error=`$errors.password`}
		{formlabel label="Password" for="password"}
		{forminput}
			<input type="password" name="password" id="password" maxlength="32" value="{$password}" />
			{formhelp note="The administrator's password should be at least 4 characters in length."}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Re-enter password" for="pass_confirm"}
		{forminput}
			<input type="password" name="pass_confirm" id="pass_confirm" maxlength="32" value="{$pass_confirm}" />
			{formhelp note="Please confirm the administrators password."}
		{/forminput}
	</div>

	<div class="row">
		{formfeedback error=`$errors.email`}
		{formlabel label="Email" for="email"}
		{forminput}
			<input type="text" name="email" id="email" value="{$email}" />
			{formhelp note="Administrator email address, in case of site malfunction this email will be showen to users."}
		{/forminput}
	</div>

	<div class="row submit">
		<input type="submit" name="fSubmitAdmin" value="Submit Admin Information" />
	</div>
{/form}
{/strip}
