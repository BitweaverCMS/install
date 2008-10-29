<?php
require_once( 'install_inc.php' );
// load up all available package upgrades that we have
foreach( array_keys( $gBitInstaller->mPackages ) as $pkg ) {
	$gBitInstaller->loadUpgradeFiles( $pkg );
}
$gBitInstaller->drawDependencyGraph( 'png', ( !empty( $_REQUEST['command'] ) ? $_REQUEST['command'] : 'dot' ));
?>
