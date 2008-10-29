<?php
$gBitSmarty->assign( 'next_step', $step );

$errors = $success = array();

// load up all available package upgrades that we have
foreach( array_keys( $gBitInstaller->mPackages ) as $pkg ) {
	$gBitInstaller->loadUpgradeFiles( $pkg );
}

if( !empty( $_REQUEST['upgrade_packages'] )) {
	if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
		$gBitInstaller->debug();
		$gBitInstallDb->debug = 99;
	}

	if( !empty( $_REQUEST['packages'] ) && is_array( $_REQUEST['packages'] )) {
		// ensure all packages are in the right order before we start applying upgrades
		uasort( $_REQUEST['packages'], 'upgrade_package_sort' );

		foreach( $_REQUEST['packages'] as $package ) {
			if( $error = $gBitInstaller->upgradePackageVersions( $package )) {
				$errors[$package] = $error;
			} elseif( !empty( $gBitInstaller->mPackageUpgrades[$package] )) {
				// copy the upgrade hash to success. next round this isn't available anymore from mPackageUpgrades since the package is up to date and the upgrade files aren't loaded anymore.
				$success[$package] = $gBitInstaller->mPackageUpgrades[$package];
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

if( include_once( 'Image/GraphViz.php' )) {
	$gBitSmarty->assign( 'depgraph', TRUE );
}
$gBitSmarty->assign( 'dependencies', $gBitInstaller->calculateDependencies() );
$gBitSmarty->assign( 'packageUpgrades', $gBitInstaller->mPackageUpgrades );
$gBitSmarty->assign( 'schema', $gBitInstaller->mPackages );
$gBitSmarty->assign( 'success', $success );
$gBitSmarty->assign( 'errors', $errors );
?>
