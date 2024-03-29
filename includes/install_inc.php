<?php
/**
 * @version $Header$
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See below for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

/**
 * set_menu function
 */
function set_menu( $pInstallFiles, $pStep ) {
	global $gBitSmarty, $gBitUser, $gBitDbType, $done, $failedcommands, $app;

	// here we set up the menu
	for( $done = 0; $done < $pStep; $done++ ) {
		$pInstallFiles[$done]['state'] = 'complete';
		$pInstallFiles[$done]['icon'] = 'fa-check';
	}

	// if the page is done, we can display the menu item as done and increase the progress bar
	if( $failedcommands || !empty( $error ) ) {
		$pInstallFiles[$pStep]['state'] = 'error';
		$pInstallFiles[$pStep]['icon'] = 'fa-octagon-exclamation';
	} elseif( !empty( $warning ) ) {
		$pInstallFiles[$pStep]['state'] = 'warning';
		$pInstallFiles[$pStep]['icon'] = 'fa-triangle-exclamation';
	} elseif( $app == "_done" ) {
		$pInstallFiles[$pStep]['state'] = 'complete';
		$pInstallFiles[$pStep]['icon'] = 'fa-check';
		$done++;
	} else {
		$pInstallFiles[$pStep]['state'] = 'current';
		$pInstallFiles[$pStep]['icon'] = 'fa-angle-right';
	}

	foreach( $pInstallFiles as $key => $menu_step ) {
		if( !isset( $menu_step['state'] ) ) {
			if( !empty( $gBitDbType ) && $gBitUser->isAdmin() && !$_SESSION['first_install'] ) {
				$pInstallFiles[$key]['state'] = 'complete';
				$pInstallFiles[$key]['icon'] = 'fa-check';
			} else {
				$pInstallFiles[$key]['state'] = 'uncompleted';
			}
		}
	}

	// assign all this work to the template
	$gBitSmarty->assign( 'step', $pStep );
	$gBitSmarty->assign( 'menu_steps', $pInstallFiles );

	return $pInstallFiles;
}

/**
 * Global flag to indicate we are installing
 */
define( 'BIT_INSTALL', 'TRUE' );
// Uncomment to switch to role team model ...
//define( 'ROLE_MODEL', 'TRUE' );
global $gBitSmarty;

// use relative path if no CONFIG_INC path specified - we know we are in installer here...
$config_file = empty($_SERVER['CONFIG_INC']) ? '../config/kernel/config_inc.php' : $_SERVER['CONFIG_INC'];
// We can't call clean_file_path here even though we would like to.
$config_file = (strpos($_SERVER["SERVER_SOFTWARE"],"IIS") ? str_replace( "/", "\\", $config_file) : $config_file);

// DO THIS FIRST! Before we include any kernel stuff to avoid duplicate defines
if( isset( $_REQUEST['submit_db_info'] ) ) {
	if ( $_REQUEST['db'] == "firebird" && empty( $gBitDbName ) ) {
		{
			//	Should only be called when creating the datatabse
			require_once("create_firebird_database.php");
			FirebirdCreateDB($_REQUEST['host'], $_REQUEST['user'], $_REQUEST['pass'], $_REQUEST['name'], $_REQUEST['fbpath']);
		}
	}
	if ( empty( $gBitDbType ) ) {
		$tmpHost = $_REQUEST['host'];
		require_once( 'create_config_inc.php' );
		$createHash = array(
			"gBitDbType"            => $_REQUEST['db'],
			"gBitDbHost"            => $tmpHost,
			"gBitDbUser"            => $_REQUEST['user'],
			"gBitDbPassword"        => $_REQUEST['pass'],
			"gBitDbName"            => $_REQUEST['name'],
			"gBitDbCaseSensitivity" => $_REQUEST['dbcase'],
			"bit_db_prefix"         => $_REQUEST['prefix'],
			"bit_root_url"          => $_REQUEST['baseurl'],
			"auto_bug_submit"       => !empty( $_REQUEST['auto_bug_submit'] ) ? 'TRUE' : 'FALSE',
			"is_live"               => !empty( $_REQUEST['is_live'] ) ? 'TRUE' : 'FALSE',
		);
		create_config( $createHash );
		include( $config_file );
	}
}
require_once( '../kernel/includes/setup_inc.php' );
require_once( INSTALL_PKG_CLASS_PATH.'BitInstaller.php' );

if ( defined( 'ROLE_MODEL' ) ) {
	require_once( USERS_PKG_CLASS_PATH.'RoleUser.php' );
} else {
	require_once( USERS_PKG_CLASS_PATH.'BitUser.php' );
}

// set some preferences during installation
global $gBitInstaller, $gBitSystem, $gBitThemes;
$gBitInstaller = new BitInstaller();

// IF DB has not been created yet, then packages will not have been scanned yet.
// and even if they have been scanned, then they will only include active packages,
// not all packages. So we scan again here including all packages.
$gBitSystem->scanPackages( 'bit_setup_inc.php', TRUE, 'all', TRUE, TRUE );

$gBitInstaller->mPackages = $gBitSystem->mPackages;

// we need this massive array available during install to work out if bitweaver has already been installed
// this array is so massive that it will kill system with too little memory allocated to php
$dbTables = $gBitInstaller->verifyInstalledPackages( 'all' );

// set prefs to display help during install
$gBitSystem->setConfig( 'site_online_help', 'y' );
$gBitSystem->setConfig( 'site_form_help', 'y' );
$gBitSystem->setConfig( 'site_help_popup', 'n' );

$commands = array();
global $failedcommands;
$failedcommands = array();
global $gBitLanguage;
$gBitLanguage->mLanguage = 'en';

// Empty SCRIPT_NAME and incorrect SCRIPT_NAME due to php-cgiwrap - wolff_borg
if( empty( $_SERVER['SCRIPT_NAME'] )) {
	$_SERVER['SCRIPT_NAME'] = $_SERVER['SCRIPT_URL'];
}

if( empty( $_REQUEST['baseurl'] )) {
	$bit_root_url = substr( $_SERVER['SCRIPT_NAME'], 0, strpos( $_SERVER['SCRIPT_NAME'], 'install/' ));
} else {
	$bit_root_url = BIT_ROOT_URL;
}

global $gBitUser;

if( !empty( $_POST['signin'] ) ) {
	$gBitInstaller->login( $_REQUEST['user'], $_REQUEST['pass'] );	
} elseif( is_object( $gBitUser ) && !empty( $_COOKIE[$gBitUser->getSiteCookieName()] ) && ( $gBitUser->mUserId = $gBitUser->getUserIdFromCookieHash( $_COOKIE[$gBitUser->getSiteCookieName()] ))) {
	$userInfo = $gBitUser->getUserInfo( array( 'user_id' => $gBitUser->mUserId ) );

	if( $userInfo['user_id'] != ANONYMOUS_USER_ID ) {
		// User is valid and not due to change pass..
		$gBitUser->mInfo = $userInfo;
		$gBitUser->loadPermissions( TRUE );
	}
}

// if we came from anywhere appart from some installer page, nuke all settings in the _SESSION and set first_install FALSE
if(
	( !isset( $_SESSION['first_install'] )
	|| $_SESSION['first_install'] != TRUE )
	|| ( isset( $_SESSION['upgrade'] ) && $_SESSION['upgrade'] != TRUE )
	|| !isset( $_SERVER['HTTP_REFERER'] )
	|| isset( $_SERVER['HTTP_REFERER'] ) && (
		( !strpos( $_SERVER['HTTP_REFERER'],'install/install.php' ))
		&& ( !strpos( $_SERVER['HTTP_REFERER'],'install/upgrade.php' ))
		&& ( !strpos( $_SERVER['HTTP_REFERER'],'install/migrate.php' ))
	)
) {
	if( empty( $gBitUser ) || !$gBitUser->isAdmin() ) {
		$_SESSION = NULL;
	}
	unset( $_SESSION['upgrade'] );
	$_SESSION['first_install'] = FALSE;
}

// this is needed because some pages display some additional information during a first install
$gBitSmarty->assign( 'first_install', $_SESSION['first_install'] );
?>
