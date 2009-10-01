<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/migrate_final.php,v 1.4 2009/10/01 14:17:00 wjames5 Exp $
 * @package install
 * @subpackage upgrade
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See below for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

// this is set to tell the progress meter to include this page --> 100% completed
$app = '_done';
$gBitSmarty->assign( 'next_step',$step );

if( isset( $_REQUEST['enter_bitweaver'] ) ) {
	$_SESSION = NULL;
	header( 'Location: '.BIT_ROOT_URL );
	die;
} elseif( isset( $_REQUEST['continue_install'] ) ) {
	header( 'Location: '.INSTALL_PKG_URL.'install.php?step=4' );
	die;
} else {
	$gBitSmarty->assign( 'next_step',$step );
}
?>
