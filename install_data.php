<?php
// $Header: /cvsroot/bitweaver/_bit_install/Attic/install_data.php,v 1.1 2005/06/19 04:51:19 bitweaver Exp $

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$smarty->assign( 'next_step',$step );

$pumpList = false;
foreach( array_keys( $gBitSystem->mPackages ) as $package ) {
	if( $gBitInstaller->isPackageActive( $package ) ) {
		if( file_exists( 'pump_'.$package.'_inc.php' ) ) {
			$pumpList[] = $package;
		}
	}
}
$smarty->assign( 'pumpList',$pumpList );

if( isset( $_REQUEST['fSubmitDataPump'] ) ) {
	foreach( $pumpList as $pump ) {
		include_once( 'pump_'.$pump.'_inc.php' );
	}
	$smarty->assign( 'pumpedData',$pumpedData );
	$app = '_done';
	$smarty->assign( 'next_step',$step + 1 );
	$gBitSystem->storePreference( 'wikiHomePage',$pumpedData['Wiki'][0] );
} elseif( isset( $_REQUEST['skip'] ) ) {
	$goto = $step + 1;
	header( "Location: install.php?step=$goto" );
}
?>