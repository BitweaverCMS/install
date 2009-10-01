<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_options.php,v 1.7 2009/10/01 14:17:00 wjames5 Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See below for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

//$gBitSmarty->assign( 'next_step',$step );
if( isset( $_REQUEST['upgrade'] ) ) {
	$_SESSION['upgrade'] = TRUE;
	$_SESSION['first_install'] = TRUE;
	header( 'Location: '.INSTALL_PKG_URL.'upgrade.php' );
	die;
} elseif( !empty( $_REQUEST['upgrade_r1'] ) ) {
	$_SESSION['upgrade'] = TRUE;
	$_SESSION['upgrade_r1'] = TRUE;
	$_SESSION['first_install'] = TRUE;
	// Added check for IIS $_SERVER['HTTPS'] uses 'off' value - wolff_borg
	header( 'Location: http'.((!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS'] != 'off')?'s':'').'://'.$_SERVER['HTTP_HOST'].INSTALL_PKG_URL.'upgrade.php' );
	die;
} elseif( isset( $_REQUEST['migrate'] ) ) {
	$_SESSION['migrate'] = TRUE;
	$_SESSION['first_install'] = TRUE;
	header( 'Location: '.INSTALL_PKG_URL.'migrate.php' );
	die;
} elseif( isset( $_REQUEST['continue_install'] ) ) {
	// Added check for IIS $_SERVER['HTTPS'] uses 'off' value - wolff_borg
	header( 'Location: http'.((!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS'] != 'off')?'s':'').'://'.$_SERVER['HTTP_HOST'].INSTALL_PKG_URL.'install.php?step='.( $step + 1 ) );
	die;
} else {
	$gBitSmarty->assign( 'next_step',$step );
}
?>
