{if ($gBrowserInfo.browser neq 'ie') or ($gBrowserInfo.browser eq 'ie' and $gBrowserInfo.maj_ver gt 7) }
<?xml version="1.0" encoding="utf-8"?>
{/if}
{strip}
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<style type="text/css">
		{* hidden from 4.x browsers: *}
		@import "{$smarty.const.CONFIG_PKG_URL}themes/bootstrap/bootstrap.css";
		@import "{$smarty.const.INSTALL_PKG_URL}css/install.css";
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
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.1/jquery.js"></script>
	<script type="text/javascript" src="{$smarty.const.CONFIG_PKG_URL}themes/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="{$smarty.const.BIT_ROOT_URL}util/javascript/bitweaver.js"></script>
	{* if $gBrowserInfo.browser eq 'ie'}
		<!--[if lt IE 7]>
			<script type="text/javascript" src="{$smarty.const.BIT_ROOT_URL}util/javascript/fixes/ie7/IE8.js"></script>
		<![endif]-->
	{/if *}
</head>
<body id="step{$smarty.request.step}">
	<header class="container">
		<nav class="navbar navbar-default" role="navigation">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bit-install-navbar-collapse">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<div class="navbar-brand">Install Bitweaver {$gBitSystem->getBitVersion()} </div>
			</div>

				<nav class="pull-right width60p" style="padding:10px 20px 0 0;">
					<div class="pull-right">
						<a href="http://www.bitweaver.org/wiki/index.php?page={$section|default:"Install"}bitweaverDoc"><i class="icon-question-sign"></i> Help</a>
					</div>

					<div class="pull-right width50p" style="padding:0 10px;">
						<div class="progress">
						  <div class="bar bar-success" style="width: {$progress|default:0}%;"></div>
						</div>
					</div>
					<div class="pull-right">
						<em>{$section|default:"Install"} Progress</em>
					</div>
				</nav>
			</div>
			<div class="collapse navbar-collapse" id="bit-install-navbar-collapse">
				<ul class="nav navbar-nav">
					{foreach from=$menu_steps item=step key=key}
						<li class="{if $smarty.request.step == $key}active{/if}">
							<a href="{$menu_path|default:$smarty.const.INSTALL_PKG_URL}{$menu_file|default:"install.php"}?step={$key}" {if $step.state eq 'uncompleted'}onclick="return false;"{/if}>
							{if $step.icon}<i class="{$step.icon}"></i> {/if} {$step.name}
							</a>
						</li>
					{/foreach}
				</ul>
			</div>
		</nav>
	</header>

	<div class="container">
		<section class="row maincontent">
			<div class="col-xs-12">
			{include file=$install_file}
			</div>
		<section>
	</div>

	<footer class="container content-center">
		{include file="bitpackage:kernel/bot_bar.tpl"}
	</footer>
</body>
</html>
{/strip}
