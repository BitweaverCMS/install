<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/migrate.php,v 1.1.2.1 2005/09/26 09:42:09 wolff_borg Exp $
 * @package install
 * @subpackage migrate
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

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

// updating $install_file name
$i = 0;
$install_file[$i]['file'] = 'welcome';
$install_file[$i++]['name'] = 'Welcome';
$install_file[$i]['file'] = 'database';
$install_file[$i++]['name'] = 'Migration Options';
$install_file[$i]['file'] = 'final';
$install_file[$i]['name'] = 'Migration Complete';

// currently i can't think of a better way to secure the migrate pages
// redirect to the installer if we aren't sent here by the installer and the migrate session variable hasn't been set
if( !isset( $_SESSION['migrate'] ) || $_SESSION['migrate'] != TRUE ||
	!isset( $_SERVER['HTTP_REFERER'] ) || 
	isset( $_SERVER['HTTP_REFERER'] ) &&
	( ( !strpos( $_SERVER['HTTP_REFERER'],'install/install.php' ) ) && ( !strpos( $_SERVER['HTTP_REFERER'],'install/upgrade.php' ) ) && ( !strpos( $_SERVER['HTTP_REFERER'],'install/migrate.php' ) ) ) 
) {
	header( 'Location: '.INSTALL_PKG_URL.'install.php' );
	die;
}

// finally we are ready to include the actual php file
include_once( 'migrate_'.$install_file[$step]['file'].'.php' );

$install_file = set_menu( $install_file, $step );

$gBitSmarty->assign( 'menu_file', 'migrate.php' );
$gBitSmarty->assign( 'section', 'Upgrade' );

$gBitSmarty->assign( 'install_file', INSTALL_PKG_PATH."templates/migrate_".$install_file[$step]['file'].$app.".tpl" );
$gBitInstaller->display( INSTALL_PKG_PATH.'templates/install.tpl', $install_file[$step]['name'] );

?>
