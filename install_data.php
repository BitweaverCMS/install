<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/Attic/install_data.php,v 1.6 2006/02/08 21:51:13 squareing Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step );

$pumpList = false;
foreach( array_keys( $gBitSystem->mPackages ) as $package ) {
	if( $gBitInstaller->isPackageActive( $package ) ) {
		if( file_exists( 'pump_'.$package.'_inc.php' ) ) {
			$pumpList[] = $package;
		}
	}
}
$gBitSmarty->assign( 'pumpList',$pumpList );

/**
 * datapump setup
 */
if( isset( $_REQUEST['fSubmitDataPump'] ) ) {
	foreach( $pumpList as $pump ) {
		include_once( 'pump_'.$pump.'_inc.php' );
	}
	$gBitSmarty->assign( 'pumpedData',$pumpedData );
	$app = '_done';
	$gBitSmarty->assign( 'next_step',$step + 1 );
	$gBitSystem->storePreference( 'wiki_home_page', $pumpedData['Wiki'][0], WIKI_PKG_NAME );
} elseif( isset( $_REQUEST['skip'] ) ) {
	$app = '_done';
	$goto = $step + 1;
	$gBitSmarty->assign( 'next_step',$goto );
	header( "Location: install.php?step=$goto" );
}
?>
