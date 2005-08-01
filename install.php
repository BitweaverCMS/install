<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install.php,v 1.5 2005/08/01 18:40:30 squareing Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// hide error ouptut on database connection settings page
if( isset( $_REQUEST['step'] ) && $_REQUEST['step'] == '3' ) {
	ini_set( 'display_errors', '0' );
}
/**
 * required setup
 */
require_once( 'install_inc.php' );

// this variable will be appended to the template file called - useful for displaying messages after data input
$app = '';

// work out where in the installation process we are
if( !isset( $_REQUEST['step'] ) ) {
	$_REQUEST['step'] = 0;
}
$step = $_REQUEST['step'];

// for pages that should only be shown during a first install
if( ( empty( $gBitDbType ) || !$gBitUser->isAdmin() ) || ( $_SESSION['first_install'] ) ) {
	$onlyDuringFirstInstall = TRUE;
} else {
	$onlyDuringFirstInstall = FALSE;
}

// updating $install_file name
$i = 0;
$install_file[$i]['file'] = 'welcome';
$install_file[$i++]['name'] = 'Welcome';
$install_file[$i]['file'] = 'checks';
$install_file[$i++]['name'] = 'bitweaver Settings Check';
// Upgrading of a database can only occur during a first install
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'upgrade';
	$install_file[$i++]['name'] = 'Database Upgrade';
}
// make it possible to reset the config_inc.php file if it's already filled with data
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'database';
	$install_file[$i++]['name'] = 'Database Connection';
} else {
	$install_file[$i]['file'] = 'database_reset';
	$install_file[$i++]['name'] = 'Database Connection';
}
// if the admin is already set up and we are not installing for the first time, we skip admin creation page
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'admin_inc';
	$install_file[$i++]['name'] = 'Admin Setup';
}
$install_file[$i]['file'] = 'packages';
$install_file[$i++]['name'] = 'Package Installation';
// these settings should only be present when we are installing for the first time
if( $onlyDuringFirstInstall ) {
	$install_file[$i]['file'] = 'bit_settings';
	$install_file[$i++]['name'] = 'bitweaver Settings';
	// only show db population page when we haven't just done an upgrade
	if( !isset( $_SESSION['upgrade'] ) ) {
		$install_file[$i]['file'] = 'data';
		$install_file[$i++]['name'] = 'Database Population';
	}
}
$install_file[$i]['file'] = 'final';
$install_file[$i]['name'] = 'Installation Complete';
//don't increment last $i since it's used later on

// if we have to log in, call login template and die
if( !empty( $gBitDbType ) && $gBitInstaller->isPackageActive( 'users' ) && !$gBitUser->isAdmin() && !$_SESSION['first_install'] ) {
	$install_file = 'login';
	$gBitSmarty->assign( 'install_file', INSTALL_PKG_PATH."templates/install_".$install_file.".tpl" );
	$gBitSmarty->display( INSTALL_PKG_PATH.'templates/install.tpl' );
	die;
}

// if the page has been renamed to anything else than 'install.php' we send it to the last installation stage
if( !strpos( $_SERVER['PHP_SELF'],'install/install.php' ) ) {
	$step = $i;
	$gBitSmarty->assign( 'renamed',basename( $_SERVER['PHP_SELF'] ) );
}

// finally we are ready to include the actual php file
include_once( 'install_'.$install_file[$step]['file'].'.php' );

// here we set up the menu
for( $done = 0; $done < $step; $done++ ) {
	$install_file[$done]['state'] = 'success';
}

// if the page is done, we can display the menu item as done and increase the progress bar
if( $failedcommands || !empty( $error ) ) {
	$install_file[$step]['state'] = 'error';
} elseif( !empty( $warning ) ) {
	$install_file[$step]['state'] = 'warning';
} elseif( $app == "_done" ) {
	$install_file[$step]['state'] = 'success';
	$done++;
} else {
	$install_file[$step]['state'] = 'current';
}

foreach( $install_file as $key => $menu_step ) {
	if( !isset( $menu_step['state'] ) ) {
		if( !empty( $gBitDbType ) && $gBitUser->isAdmin() && !$_SESSION['first_install'] ) {
			$install_file[$key]['state'] = 'success';
		} else {
			$install_file[$key]['state'] = 'spacer';
		}
	}
}
$gBitSmarty->assign( 'step', $step );
$gBitSmarty->assign( 'menu_steps', $install_file );

$steps = ( count( $install_file ) );
$progress = ( ceil( 100 / $steps * $done ) );
$gBitSmarty->assign( 'progress', $progress );

$gBitSmarty->assign( 'install_file', INSTALL_PKG_PATH."templates/install_".$install_file[$step]['file'].$app.".tpl" );
$gBitInstaller->display( INSTALL_PKG_PATH.'templates/install.tpl', $install_file[$step]['name'] );
?>
