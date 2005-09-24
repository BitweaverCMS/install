<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_inc.php,v 1.2.2.7 2005/09/24 10:16:32 squareing Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

function set_menu( $pInstallFiles, $pStep ) {
	global $gBitSmarty, $gBitUser, $gBitDbType, $done, $failedcommands, $app;

	// here we set up the menu
	for( $done = 0; $done < $pStep; $done++ ) {
		$pInstallFiles[$done]['state'] = 'success';
	}

	// if the page is done, we can display the menu item as done and increase the progress bar
	if( $failedcommands || !empty( $error ) ) {
		$pInstallFiles[$pStep]['state'] = 'error';
	} elseif( !empty( $warning ) ) {
		$pInstallFiles[$pStep]['state'] = 'warning';
	} elseif( $app == "_done" ) {
		$pInstallFiles[$pStep]['state'] = 'success';
		$done++;
	} else {
		$pInstallFiles[$pStep]['state'] = 'current';
	}

	foreach( $pInstallFiles as $key => $menu_step ) {
		if( !isset( $menu_step['state'] ) ) {
			if( !empty( $gBitDbType ) && $gBitUser->isAdmin() && !$_SESSION['first_install'] ) {
				$pInstallFiles[$key]['state'] = 'success';
			} else {
				$pInstallFiles[$key]['state'] = 'spacer';
			}
		}
	}

	// assign all this work to the template
	$gBitSmarty->assign( 'step', $pStep );
	$gBitSmarty->assign( 'menu_steps', $pInstallFiles );
	$gBitSmarty->assign( 'progress', ( ceil( 100 / ( count( $pInstallFiles ) ) * $done ) ) );

	return $pInstallFiles;
}

/**
 * Global flag to indicate we are installing
 */
define( 'BIT_INSTALL', 'TRUE' );
global $gBitSmarty;

// use relative path if no CONFIG_INC path specified - we know we are in installer here...
$config_file = empty($_SERVER['CONFIG_INC']) ? '../kernel/config_inc.php' : $_SERVER['CONFIG_INC'];
// We can't call clean_file_path here even though we would like to.
$config_file = (strpos($_SERVER["SERVER_SOFTWARE"],"IIS") ? str_replace( "/", "\\", $config_file) : $config_file);

// DO THIS FIRST! Before we include any kernel stuff to avoid duplicate defines
if( isset( $_REQUEST['fSubmitDbInfo'] ) ) {
	if ( $_REQUEST['db'] == "firebird" && empty( $gBitDbName ) ) {
		{
			//	Should only be called when creating the datatabse
			require_once("create_firebird_database.php");
			FirebirdCreateDB($_REQUEST['host'], $_REQUEST['user'], $_REQUEST['pass'], $_REQUEST['name'], $_REQUEST['fbpath']);
		}
	}
	if ( empty( $gBitDbType ) ) {
		require_once( 'create_config_inc.php' );
		create_config($_REQUEST['db'], $_REQUEST['host'], $_REQUEST['user'], $_REQUEST['pass'], $_REQUEST['name'], $_REQUEST['prefix'], $_REQUEST['baseurl'], isset( $_REQUEST['auto_bug_submit'] ) ? 'TRUE' : 'FALSE' );
		include( $config_file );
	}
}

require_once("../bit_setup_inc.php");
require_once( 'BitInstaller.php' );
require_once( USERS_PKG_PATH.'BitUser.php' );

// set some preferences during installation
global $gBitInstaller, $gBitSystem;
$gBitInstaller = new BitInstaller();
$gBitInstaller->setStyle( DEFAULT_THEME );
// this is important! since bit_setup_inc's are only included_once, and $gBitSystem has already scanned them, we need to make a copy - spiderr
if( !empty( $gBitSystem->mPackages ) ) {
	$gBitInstaller->mPackages = $gBitSystem->mPackages;
} else {
	$gBitInstaller->scanPackages();
}
// we need this massive array available during install to work out if bitweaver has already been installed
$gBitInstaller->verifyInstalledPackages();

// After install. This should remove this script.
if (isset($_REQUEST['kill'])) {
	$gBitSmarty->assign( 'script',kill_script() );
}

// set prefs to display help during install
$gBitSystem->mPrefs['feature_help'] = 'y';
$gBitSystem->mPrefs['feature_helpnotes'] = 'y';
$gBitSystem->mPrefs['feature_helppopup'] = 'n';

$commands = array();
global $failedcommands;
$failedcommands = array();
global $gBitLanguage;
$gBitLanguage->mLanguage = 'en';

if( empty( $_REQUEST['baseurl'] ) ) {
	$root_url_bit = substr( $_SERVER['PHP_SELF'], 0, strpos( $_SERVER['PHP_SELF'], 'install/' ) );
} else {
	$root_url_bit = BIT_ROOT_URL;
}

$errors = '';

// do some session stuff
// check_session_save_path();
if( !isset($_SESSION) ) {
// 	session_start();
// 	vd( "session start" );
}

// if we came from anywhere appart from some installer page, nuke all settings in the _SESSION and set first_install FALSE
if( ( !isset( $_SESSION['first_install'] ) || $_SESSION['first_install'] != TRUE ) ||
	( isset( $_SESSION['upgrade'] ) && $_SESSION['upgrade'] != TRUE ) ||
	!isset( $_SERVER['HTTP_REFERER'] ) ||
	isset( $_SERVER['HTTP_REFERER'] ) &&
	( ( !strpos( $_SERVER['HTTP_REFERER'],'install/install.php' ) ) && ( !strpos( $_SERVER['HTTP_REFERER'],'install/upgrade.php' ) ) )
) {
	if( !$gBitUser->isAdmin() ) {
		$_SESSION = NULL;
	}
	unset( $_SESSION['upgrade'] );
	$_SESSION['first_install'] = FALSE;
}
// this is needed because some pages display some additional information during a first install
$gBitSmarty->assign( 'first_install',$_SESSION['first_install'] );
?>
