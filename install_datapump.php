<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_datapump.php,v 1.7 2009/10/01 14:17:00 wjames5 Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See below for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step );

$gBitUser->mUserId = ROOT_USER_ID;

$pumpList = array();
foreach( array_keys( $gBitSystem->mPackages ) as $package ) {
	if( $gBitInstaller->isPackageActive( $package ) ) {
		$file = constant( strtoupper( $package ).'_PKG_PATH' ).'pump_'.$package.'_inc.php';
		if( file_exists( $file )) {
			$pumpList[$package] = $file;
		}
	}
}
$gBitSmarty->assign( 'pumpList', $pumpList );

/**
 * datapump setup
 */
if( isset( $_REQUEST['fSubmitDataPump'] ) ) {
	foreach( $pumpList as $file ) {
		include_once( $file );
	}
	$gBitSmarty->assign( 'pumpedData',$pumpedData );
	$app = '_done';
	$gBitSmarty->assign( 'next_step',$step + 1 );

	if( $gBitSystem->isPackageActive( 'wiki' ) && !empty( $pumpedData['Wiki'] )) {
		$gBitSystem->storeConfig( 'wiki_home_page', $pumpedData['Wiki'][0], WIKI_PKG_NAME );
	}
} elseif( isset( $_REQUEST['skip'] )) {
	$app = '_done';
	$goto = $step + 1;
	$gBitSmarty->assign( 'next_step',$goto );
	header( "Location: ".INSTALL_PKG_URL."install.php?step=$goto" );
	die;
}
?>
