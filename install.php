<?php
/**
 * @version $Header$
 * @package install
 * @subpackage functions
 */

// hide errors when trying to connect to the database. very unsettling when you
// have pages of errors to scroll through
if( !empty( $_REQUEST['submit_db_info'] ) && !empty( $_REQUEST['step'] ) && $_REQUEST['step'] == 3 ) {
	ini_set( 'display_errors', '0' );
}

// here we force the use of adodb during installation
$gForceAdodb = TRUE;

// If we are jumping to start over reset the session
if( !empty( $_REQUEST['step'] ) && $_REQUEST['step'] == 0 ) {
	unset( $_REQUEST['BWSESSION'] );
}

// Early check of memory limit just to be sure we can run.
// Set the number '15' to a lower value if you know that the install process can handle it.
if( get_cfg_var( 'memory_limit' ) !== FALSE && preg_replace( '/M/i','',get_cfg_var( 'memory_limit' )) < 15 ) {
	$dir = dirname( $_SERVER['SCRIPT_NAME'] );
	// We don't use smarty to avoid using any memory since we already know there is a problem.
	echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title>Install Bitweaver - Not enough memory!</title>
		<style type="text/css">
			<!-- @import url( '.$dir.'/style/install.css ); -->
		</style>
	</head>
	<body>
		<div id="container">
			<div id="header"></div>
			<div id="wrapper">
				<div id="content">
					<div class="bittop"><h1>Bitweaver Installer</h1></div>
					<h1>Not enough memory!</h1>
					<form action="'.$dir.'/install.php">
						<fieldset>
							<legend>Unable to run installer</legend>
							<p class="alert alert-error">The memory limit of <strong>"'.get_cfg_var( 'memory_limit' ).'"</strong> is not high enough to run the bitweaver installer. Please up the memory limit in you php.ini to at least 16M to install and run bitweaver.</p>
						</fieldset>
						<div class="row submit">
							<input type="submit" value="Reload" size="20"/>
						</div>
					</form>
				</div>
			</div>
		</div>
	</body>
</html>';
die;
}

/**
 * required setup
 */
require_once( 'install_inc.php' );

// this variable will be appended to the template file called - useful for displaying messages after data input
$app = '';

// work out where in the installation process we are
if( !isset( $_REQUEST['step'] )) {
	$_REQUEST['step'] = 0;
}
$step = $_REQUEST['step'];

if( !empty( $_REQUEST['reload'] )) {
	header( "Location: ".$_SERVER['HTTP_REFERER'] );
}

// for pages that should only be shown during a first install
if( ( empty( $gBitDbType ) || !$gBitUser->isAdmin() ) || ( $_SESSION['first_install'] ) ) {
	$onlyDuringFirstInstall = TRUE;
} else {
	$onlyDuringFirstInstall = FALSE;
}

// For MySql only, and if server supports InnoDB Engine
// we catch here if it was selected as storage type and
// set a session var for use in install_packages.php
if( isset( $_REQUEST['use_innodb'] ) ) {
	$_SESSION['use_innodb'] = TRUE;
}

// updating $install_file name
$i = 0;
$install_file[$i]['file'] = 'welcome';
$install_file[$i++]['name'] = 'Welcome';
$install_file[$i]['file'] = 'checks';
$install_file[$i++]['name'] = 'Server';
// Upgrading of a database can only occur during a first install
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'options';
	$install_file[$i++]['name'] = 'Options';
}
// make it possible to reset the config/kernel/config_inc.php file if it's already filled with data
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'database';
	$install_file[$i++]['name'] = 'Database';
} else {
	$install_file[$i]['file'] = 'database_reset';
	$install_file[$i++]['name'] = 'Database';
}
// if the admin is already set up and we are not installing for the first time, we skip admin creation page
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'admin_inc';
	$install_file[$i++]['name'] = 'Admin';
}
$install_file[$i]['file'] = 'packages';
$install_file[$i++]['name'] = 'Packages';
if( !$onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'upgrade';
	$install_file[$i++]['name'] = 'Upgrade';
}
$install_file[$i]['file'] = 'cleanup';
$install_file[$i++]['name'] = 'Cleanup';
// these settings should only be present when we are installing for the first time
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'bit_settings';
	$install_file[$i++]['name'] = 'Settings';
	// only show db population page when we haven't just done an upgrade
	if( !isset( $_SESSION['upgrade'] ) ) {
		$install_file[$i]['file'] = 'datapump';
		$install_file[$i++]['name'] = 'Content';
	}
} else {
	$install_file[$i]['file'] = 'version';
	$install_file[$i++]['name'] = 'Update';
}
$install_file[$i]['file'] = 'final';
$install_file[$i]['name'] = 'Done';
//don't increment last $i since it's used later on

// Needed for version number
$gBitSmarty->assign_by_ref( 'gBitSystem', $gBitSystem );

// if we have to log in, call login template and die
if( !empty( $gBitDbType ) && !empty( $gBitInstaller->mPackages['users']['installed'] ) && !$gBitUser->isAdmin() && !$_SESSION['first_install'] ) {
	$install_file = 'login';
	$gBitSmarty->assign( 'install_file', INSTALL_PKG_PATH."templates/install_".$install_file.".tpl" );
	$gBitSmarty->assign( 'progress', 0 );
	$gBitSmarty->display( INSTALL_PKG_PATH.'templates/install.tpl' );
	die;
}

// if the page has been renamed to anything else than 'install.php' we send it to the last installation stage
if( !strpos( $_SERVER['SCRIPT_NAME'],'install/install.php' ) ) {
	$step = $i;
	$gBitSmarty->assign( 'renamed',basename( $_SERVER['SCRIPT_NAME'] ) );
}

// finally we are ready to include the actual php file
include_once( 'install_'.$install_file[$step]['file'].'.php' );

$install_file = set_menu( $install_file, $step );

$gBitSmarty->assign( 'install_file', INSTALL_PKG_PATH."templates/install_".$install_file[$step]['file'].$app.".tpl" );
$gBitInstaller->in_display( $install_file[$step]['name'], INSTALL_PKG_PATH.'templates/install.tpl' );
?>
