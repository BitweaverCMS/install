<h1>Bitweaver Settings</h1>

{form legend="Some Preliminary Settings"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="row">
		<ul class="result">
			<li class="success">
				All setting have been stored successfully
			</li>
		</ul>
	</div>

	<div class="row">
		{formlabel label="Browser Title"}
		{forminput}
			{$gBitSystem->getConfig('site_title')}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Slogan"}
		{forminput}
			{$gBitSystem->getConfig('site_slogan')}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Home Page"}
		{forminput}
			{$gBitSystem->getConfig('bit_index')}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Style"}
		{forminput}
			{$gBitSystem->getConfig('style')}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Language"}
		{forminput}
			{$siteLanguage.full_name}
		{/forminput}
	</div>

	{if $gBitSystem->isFeatureActive('image_processor')}
		<div class="row">
			{formlabel label="Image Processor"}
			{forminput}
				{$gBitSystem->getConfig('image_processor')}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" value="Continue install process" />
	</div>
{/form}
