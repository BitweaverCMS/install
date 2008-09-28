{strip}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<style type="text/css">
		@import url({$smarty.const.INSTALL_PKG_URL}style/install.css);
	</style>
	<title>Install Bitweaver - {$browserTitle}</title>
	<link rel="shortcut icon" href="{$smarty.const.INSTALL_PKG_URL}favicon.ico" type="image/x-icon" />
	<link rel="icon" href="{$smarty.const.INSTALL_PKG_URL}favicon.ico" type="image/x-icon" />

	<script type="text/javascript">/* <![CDATA[ */
		var bitCookiePath = "{$smarty.const.BIT_ROOT_URL}";
		var bitCookieDomain = "";
		var bitIconDir = "{$smarty.const.LIBERTY_PKG_URL}icons/";
		var bitRootUrl = "{$smarty.const.BIT_ROOT_URL}";
	/* ]]> */</script>
	<script type="text/javascript" src="{$smarty.const.BIT_ROOT_URL}util/javascript/libs/tabpane.js"></script>
	<script type="text/javascript" src="{$smarty.const.BIT_ROOT_URL}util/javascript/bitweaver.js"></script>
	{if $gBrowserInfo.browser eq 'ie'}
		<!--[if lt IE 7]>
			<script type="text/javascript" src="{$smarty.const.BIT_ROOT_URL}util/javascript/fixes/ie7/IE8.js"></script>
		<![endif]-->
	{/if}
</head>
<body id="step{$smarty.request.step}">
	<div id="container">
		<div id="header">
			<a href="http://www.bitweaver.org/" title="bitweaver.org" id="bitweaver_logo">
				<em>bitweaver.org</em>
			</a>
			<h1 id="title">
				<strong>Bitweaver {$smarty.const.BIT_MAJOR_VERSION}.{$smarty.const.BIT_MINOR_VERSION}.{$smarty.const.BIT_SUB_VERSION} {$smarty.const.BIT_LEVEL}</strong>
				<em>{$section|default:"Install"}</em>
			</h1>
			<div class="bittop">
				<ul id="stepmenu">
					{foreach from=$menu_steps item=step key=key}
						<li class="{$step.state}">
							{if $step.state ne 'uncompleted'}
								<a href="{$menu_path|default:$smarty.const.INSTALL_PKG_URL}{$menu_file|default:"install.php"}?step={$key}">
							{/if}
							{$step.name}
							{if $step.state ne 'uncompleted'}
								</a>
							{/if}
						</li>
					{/foreach}				
				</ul>
			</div>
		</div>

		<div id="wrapper">
			<div id="content">
				{include file=$install_file}
			</div>
		</div>

		<div id="navigation">
			<div class="progressbar">
				<em>{$section|default:"Install"} Progress</em>
				<div class="bar">
					<div class="progress progress{$progress}" style="width:{$progress|default:0}%;"><strong>{$progress}%</strong></div>
				</div>
				<span class="clear"><!-- --></span>
			</div>
		</div>

		<div id="extra">
			<ul>
				<li class="help">
					<a class="external" href="http://www.bitweaver.org/wiki/index.php?page={$section|default:"Install"}bitweaverDoc">{$section|default:"Install"} Help</a>
				</li>
				<li class="help">
					<a href="{$smarty.const.INSTALL_PKG_URL}{$menu_file|default:"install.php"}?step=0">Start over</a>
				</li>
				{if $section}
					<li class="help">
						<a href="{$smarty.const.INSTALL_PKG_URL}install.php?step=2">Return to Installer</a>
					</li>
				{/if}
				<li class="warning" title="Please don't use your browser's back button during this install process.">
					Please don't use the browser back button
				</li>
			</ul>
		</div>

		<div id="footer">
			<p>
				<a href="http://bitweaver.org">
					Bitweaver.&nbsp;&nbsp;It's the one
					<br />
					www.bitweaver.org
				</a>
			</p>
		</div>
	</div>
</body>
</html>
{/strip}
