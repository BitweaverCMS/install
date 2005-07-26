<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/Attic/install_data.php,v 1.1.1.1.2.2 2005/07/26 15:50:07 drewslater Exp $
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
	$gBitSystem->storePreference( 'wikiHomePage',$pumpedData['Wiki'][0] );
} elseif( isset( $_REQUEST['skip'] ) ) {
	$goto = $step + 1;
	header( "Location: install.php?step=$goto" );
}
?>