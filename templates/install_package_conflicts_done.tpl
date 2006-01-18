<h1>Deactivated Packages</h1>

{form legend="Installed Packages"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			<li class="success">
				{biticon ipackage=liberty iname=success iexplain=success}
				The Packages were successfully deactivated.
			</li>
		</ul>
	</div>

	<div class="row">
		{formlabel label="Packages that were deactivated"}
		{forminput}
			{foreach from=$deActivated item=package}
				{formfeedback note=$package}
			{/foreach}
		{/forminput}
	</div>

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
