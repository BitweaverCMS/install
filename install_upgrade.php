<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_upgrade.php,v 1.2 2005/06/28 07:45:45 spiderr Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

//$smarty->assign( 'next_step',$step );

if( isset( $_REQUEST['upgrade'] ) ) {
	$_SESSION['upgrade'] = TRUE;
	$_SESSION['first_install'] = TRUE;
	header( 'Location: '.INSTALL_PKG_URL.'upgrade.php' );
	die;
} elseif( isset( $_REQUEST['continue_install'] ) ) {
	header( 'Location: '.INSTALL_PKG_URL.'install.php?step='.( $step + 1 ) );
	die;
} else {
	$smarty->assign( 'next_step',$step );
}
?>
