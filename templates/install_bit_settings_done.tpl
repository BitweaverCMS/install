<h1>Bitweaver Settings</h1>

{form legend="Some Preliminary Settings"}
	<input type="hidden" name="step" value="{$next_step}" />

	<div class="form-group">
		<ul class="result">
			<li class="success">
				All setting have been stored successfully
			</li>
		</ul>
	</div>

	<div class="form-group">
		{formlabel label="Browser Title"}
		{forminput}
			{$gBitSystem->getConfig('site_title')}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Site Slogan"}
		{forminput}
			{$gBitSystem->getConfig('site_slogan')}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Home Page"}
		{forminput}
			{$gBitSystem->getConfig('bit_index')}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Site Style"}
		{forminput}
			{$gBitSystem->getConfig('style')}
		{/forminput}
	</div>

	<div class="form-group">
		{formlabel label="Language"}
		{forminput}
			{$siteLanguage.full_name}
		{/forminput}
	</div>

	{if $gBitSystem->isFeatureActive('image_processor')}
		<div class="form-group">
			{formlabel label="Image Processor"}
			{forminput}
				{$gBitSystem->getConfig('image_processor')}
			{/forminput}
		</div>
	{/if}

	<div class="form-group">
		{forminput}
			<input type="submit" class="btn btn-primary" value="Continue install process" />
		{/forminput}
	</div>
{/form}
