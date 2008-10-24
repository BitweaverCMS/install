<?php
$gBitSmarty->assign( 'next_step', $step );

$errors = $success = array();

//$gBitSystem->storeVersion( 'wiki', '0.1.0' );

// load up all available package upgrades that we have
foreach( array_keys( $gBitInstaller->mPackages ) as $pkg ) {
	$gBitInstaller->loadUpgradeFiles( $pkg );
}
$gBitSmarty->assign( 'packageUpgrades', $gBitInstaller->mPackageUpgrades );
$gBitSmarty->assign( 'schema', $gBitInstaller->mPackages );

if( !empty( $_REQUEST['upgrade_packages'] )) {
	if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
		$gBitInstaller->debug();
		$gBitInstallDb->debug = 99;
	}

	if( !empty( $_REQUEST['packages'] ) && is_array( $_REQUEST['packages'] )) {
		foreach( $_REQUEST['packages'] as $package ) {
			if( $error = $gBitInstaller->upgradePackageVersions( $package )) {
				$errors[$package] = $error;
			} else {
				$success[] = $package;
			}
		}
	}

	if( empty( $errors )) {
		// display success page when done
		$app = '_done';
		$gBitSmarty->assign( 'next_step', $step + 1 );
	} else {
		$gBitSmarty->assign( 'errors', $errors );
	}
}

$gBitSmarty->assign( 'errors', $errors );
$gBitSmarty->assign( 'success', $success );
?>
