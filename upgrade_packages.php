<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/upgrade_packages.php,v 1.6 2006/01/24 11:27:55 squareing Exp $
 * @package install
 * @subpackage upgrade
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

$gBitSmarty->assign( 'next_step',$step );
$config_file = empty($_SERVER['CONFIG_INC']) ? '../kernel/config_inc.php' : $_SERVER['CONFIG_INC'];

// set the maximum execution time to very high
ini_set( "max_execution_time", "86400" );

/**
 * required setup
 */
include_once( $config_file ); // relative, but we know we are in the installer here...
$gBitInstaller->scanPackages( 'admin/upgrade_inc.php' );

$upgradePath = array (
	'TikiWiki 1.8' => array(
		'TIKIWIKI18' => 'BONNIE',
		'BONNIE' => 'BWR1',
		'BWR1' => 'BWR2',
	),
	'TikiWiki 1.9' => array(
		'TIKIWIKI19' => 'TIKIWIKI18',
		'TIKIWIKI18' => 'BONNIE',
		'BONNIE' => 'BWR1',
		'BWR1' => 'BWR2',
	),
	'BWR0' => array(
		'BONNIE' => 'BWR1',
		'BWR1' => 'BWR2',
	),
	'BWR1' => array(
		'BWR1' => 'BWR2',
	),
);

$gBitSmarty->assign( 'upgradeFrom', $gUpgradeFrom );
$gBitSmarty->assign( 'upgradeTo', $gUpgradeTo );

$upPackages = array();

if( !empty( $_REQUEST['upgrade'] ) ) {
	if( isset( $upgradePath[$_REQUEST['upgrade_from']] ) ) {
		if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
			$gBitInstaller->debug();
		}

		foreach( $upgradePath[$_REQUEST['upgrade_from']] as $from=>$to ) {
			global $gUpgradeFrom, $gUpgradeTo;
			$gUpgradeFrom = $from;
			$gUpgradeTo = $to;

			$gBitInstaller->scanPackages( 'admin/upgrade_inc.php', FALSE );
			$firstPackages = array_flip( array( 'kernel', 'users', 'categories', 'liberty', 'wiki', 'blogs' ) );
			$secondPackages = array_flip( array_keys( $gBitSystem->mUpgrades ) );

			// upgrade the ones that are order critical first
			foreach( array_keys( $firstPackages ) as $package ) {
				$gBitInstaller->upgradePackage( $package );
				unset( $secondPackages[$package] );
				array_push( $upPackages, $package );
			}

			// upgrade remaining packages
			foreach( array_keys( $secondPackages ) as $package ) {
				$gBitInstaller->upgradePackage( $package );
				array_push( $upPackages, $package );
			}
			unset( $gBitInstaller->mUpgrades );
		}
	}

	$gBitSmarty->assign( 'package_list', $upPackages );

	$app = '_done';
	$gBitSmarty->assign( 'next_step',$step + 1 );
}
?>
