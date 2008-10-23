<?php
// load up all available package upgrades that we have
foreach( array_keys( $gBitInstaller->mPackages ) as $pkg ) {
	$gBitInstaller->loadUpgradeFiles( $pkg );
}
$gBitSmarty->assign( 'packageUpgrades', $gBitInstaller->mPackageUpgrades );
?>
