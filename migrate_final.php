<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/migrate_final.php,v 1.3 2009/10/01 13:45:42 wjames5 Exp $
 * @package install
 * @subpackage upgrade
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
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
