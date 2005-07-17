<h1>bitweaver Settings</h1>

{form legend="Some Preliminary Settings"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			<li class="success">
				{biticon ipackage=liberty iname=success iexplain=success}
				All setting have been stored successfully
			</li>
		</ul>
	</div>

	{foreach from=$formInstallToggles key=feature item=output}
		<div class="row">
			{formlabel label=`$output.label`}
			{forminput}
				{if $gBitSystemPrefs.$feature eq 'n'}
					{assign var=note value="No"}
				{elseif $gBitSystemPrefs.$feature eq 'y'}
					{assign var=note value="Yes"}
				{/if}
				{formfeedback note=$note}
			{/forminput}
		</div>
	{/foreach}

	<div class="row">
		{formlabel label="Browser title"}
		{forminput}
			{formfeedback note=`$gBitSystemPrefs.siteTitle`}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Slogan"}
		{forminput}
			{formfeedback note=`$gBitSystemPrefs.site_slogan`}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Home page"}
		{forminput}
			{formfeedback note=`$gBitSystemPrefs.bitIndex`}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Language"}
		{forminput}
			{formfeedback note=`$siteLanguage.full_name`}
		{/forminput}
	</div>

	{if $gBitSystemPrefs.image_processor}
		<div class="row">
			{formlabel label="Image Processor"}
			{forminput}
				{formfeedback note=`$gBitSystemPrefs.image_processor`}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
