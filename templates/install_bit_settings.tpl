<h1>Bitweaver Settings</h1>

{form legend="Some Preliminary Settings"}
	<input type="hidden" name="step" value="{$next_step}" />

	<p>Since Bitweaver has so many settings and features, it might be useful to set some of the key settings on this screen already, to simplify the initial stages. These settings can be found later in the administration panel.</p>

	{foreach from=$formInstallToggles key=feature item=output}
		<div class="row">
			{formlabel label=`$output.label` for=$feature}
			{forminput}
				{html_checkboxes name="$feature" values="y" checked=$gBitSystem->getConfig($feature) labels=false id=$feature}
				{formhelp note=`$output.note` page=`$output.page`}
			{/forminput}
		</div>
	{/foreach}

	<div class="row">
		{formlabel label="Browser Title" for="site_title"}
		{forminput}
			<input size="40" type="text" name="site_title" id="site_title" value="{$gBitSystem->getConfig('site_title')|escape}" />
			{formhelp note="Enter the text that should appear in the title bar of the user's browser when visiting your site."}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Slogan" for="site_slogan"}
		{forminput}
			<input size="40" type="text" name="site_slogan" id="site_slogan" value="{$gBitSystem->getConfig('site_slogan')|escape}" />
			{formhelp note="This slogan is (usually) shown below the site title."}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Home Page" for="bit_index"}
		{forminput}
			<select name="bit_index" id="bit_index">
				<option value="my_home"{if $bit_index eq 'my_home'} selected="selected"{/if}>{tr}My home{/tr}</option>
				<option value="group_home"{if $bit_index eq 'group_home'} selected="selected"{/if}>{tr}Group home{/tr}</option>
				{foreach key=name item=package from=$schema }
					{if $package.homeable && $package.installed}
						<option {if $package.name=='wiki'}selected="selected"{/if} value="{$package.name}">{$package.name}</option>
					{/if}
				{/foreach}
				{if $gBitSystem->isFeatureActive( 'users_custom_home' )}
					<option value="users_custom_home"{if $bit_index eq $gBitSystem->getConfig('site_url_index')} selected="selected"{/if}>{tr}Custom home{/tr}</option>
				{/if}
			</select>
			{formhelp note="Pick your site's homepage. This is where users will be redirected, when they access a link to your homepage.
				<dl>
					<dt>My Home</dt><dd>This page contains all links the user can access with his/her current permissions. It's like a personal administration screen.</dd>
					<dt>Group Home</dt><dd>You can define an individual home page for a group of users using this option. To define home pages, please access the <br /><strong>Administration --> Users --> Groups and Permissions</strong> page.</dd>
					<dt>Other Home Pages</dt><dd>Here you can set a particular package that will serve as your home page. If you want to select an individual home page from the exisiting ones, please access the <br /><strong>Administration --> 'Package' --> 'Package' Settings</strong> page.</dd>
				</dl>"}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Site Style" for="site_style"}
		{forminput}
			<select name="site_style" id="site_style">
				{foreach from=$stylesList item=s}
						<option value="{$s.style}" {if $s.style eq "basic"}selected="selected"{/if}>{$s.style}</option>
				{/foreach}
			</select>
			{formhelp note="Pick the look and feel style you wish to use. Custom styles can be added to the themes/styles/ directory and then selected in the themes administration panel."}
		{/forminput}
	</div>

	<div class="row">
		{formlabel label="Language" for="language"}
		{forminput}
			<select name="bitlanguage" id="bitlanguage">
				{foreach from=$languages key=langCode item=lang}
						<option value="{$langCode}" {if $langCode eq "en"}selected="selected"{/if}>{$lang.full_name|escape}</option>
				{/foreach}
			</select>
			{formhelp note="Select the default language of your site. Choosing a language other than English will cause the language to be installed, which might take some time depending on your setup."}
		{/forminput}
	</div>

	{if $processors}
		<div class="row">
			{formlabel label="Image Processor"}
			{forminput}
				{foreach name=iprocs from=$processors key=val item=print}
					<label><input type="radio" name="image_processor" value="{$val}" {if $smarty.foreach.iprocs.last}checked="checked"{/if} /> {$print}</label><br />
				{/foreach}
			{/forminput}
		</div>
	{/if}

	<div class="row submit">
		<input type="submit" name="bit_settings" value="{tr}Set Preferences{/tr}" />
	</div>
{/form}
