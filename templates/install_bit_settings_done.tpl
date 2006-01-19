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

	<div class="row">
		{formlabel label="Browser title"}
		{forminput}
			{$gBitSystemPrefs.siteTitle}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Slogan"}
		{forminput}
			{$gBitSystemPrefs.site_slogan}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Home page"}
		{forminput}
			{$gBitSystemPrefs.bitIndex}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Language"}
		{forminput}
			{$siteLanguage.full_name}
		{/forminput}
	</div>

	{if $gBitSystemPrefs.image_processor}
		<div class="row">
			{formlabel label="Image Processor"}
			{forminput}
				{$gBitSystemPrefs.image_processor}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue Install Process" />
	</div>
{/form}
