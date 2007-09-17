<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/upgrade_final.php,v 1.4 2007/09/17 11:15:00 squareing Exp $
 * @package install
 * @subpackage upgrade
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// this is set to tell the progress meter to include this page --> 100% completed
$app = '_done';
$gBitSmarty->assign( 'next_step', $step );

if( isset( $_REQUEST['enter_bitweaver'] ) ) {
	$_SESSION = NULL;
	bit_redirect( BIT_ROOT_URL );
} elseif( isset( $_REQUEST['continue_install'] ) ) {
	bit_redirect( INSTALL_PKG_URL.'install.php?step=5' );
} elseif( isset( $_REQUEST['resolve_conflicts'] ) ) {
	bit_redirect( INSTALL_PKG_URL.'install.php?step=6' );
} else {
	$gBitSmarty->assign( 'next_step',$step );
}
?>
