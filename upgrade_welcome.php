<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/upgrade_welcome.php,v 1.2 2005/06/28 07:45:45 spiderr Exp $
 * @package install
 * @subpackage upgrade
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

if( preg_match( '/mysql/', $gBitDbType ) ) {
	$smarty->assign( 'dbWarning', 'MySQL 4.1 or greater is required to run the installer. bitweaver will support MySQL 3.23 and above, however, the upgrade process currently uses "sub-selects" which are only supported in MySQL 4.1 and higher and all other real databases.' );
	$smarty->assign( 'warningSubmit', 'Click if MySQL 4.1 is installed' );
}

// assign next step in installation process
$smarty->assign( 'next_step',$step + 1 );
?>
