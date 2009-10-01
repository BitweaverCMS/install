<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_welcome.php,v 1.9 2009/10/01 14:17:00 wjames5 Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See below for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

// assign next step in installation process
if( !empty( $_REQUEST['install'] ) ) {
	// Added check for IIS $_SERVER['HTTPS'] uses 'off' value - wolff_borg
	header( 'Location: http'.((!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS'] != 'off')?'s':'').'://'.$_SERVER['HTTP_HOST'].INSTALL_PKG_URL.'install.php?step='.( $step + 1 ) );
	die;
}
$gBitSmarty->assign( 'next_step',$step );
?>
