<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/upgrade_final.php,v 1.1.1.1.2.1 2005/06/27 12:49:50 lsces Exp $
 * @package install
 * @subpackage upgrade
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// this is set to tell the progress meter to include this page --> 100% completed
$app = '_done';
$smarty->assign( 'next_step',$step );

if( isset( $_REQUEST['enter_bitweaver'] ) ) {
	$_SESSION = NULL;
	header( 'Location: '.BIT_ROOT_URL );
	die;
} elseif( isset( $_REQUEST['continue_install'] ) ) {
	header( 'Location: '.INSTALL_PKG_URL.'install.php?step=5' );
	die;
} else {
	$smarty->assign( 'next_step',$step );
}
?>
