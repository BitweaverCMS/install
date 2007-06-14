<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_welcome.php,v 1.5 2007/06/14 06:55:13 squareing Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
if( !empty( $_REQUEST['install'] ) ) {
	header( 'Location: http://'.$_SERVER['HTTP_HOST'].INSTALL_PKG_URL.'install.php?step='.( $step + 1 ) );
	die;
}
$gBitSmarty->assign( 'next_step',$step );
?>
