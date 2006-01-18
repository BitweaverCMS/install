<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/Attic/install_package_conflicts.php,v 1.1.2.1 2005/09/15 21:32:00 squareing Exp $
 * @package install
 * @subpackage functions
 */

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step );

$schema = $gBitInstaller->mPackages;
ksort( $schema );
$gBitSmarty->assign_by_ref( 'schema', $schema );

// check if we have installed more than one service of any given type
$serviceList = array();
foreach( $gLibertySystem->mServices as $service_name => $service ) {
	if( count( $service ) > 1 ) {
		$serviceList[$service_name] = $service;
	}
}

// if any of the serviceList items have been unchecked, disable the appropriate packages
if( !empty(  $_REQUEST['deactivate_packages'] ) ) {
	$deActivated = array();
	foreach( $serviceList as $service ) {
		foreach( array_keys( $service ) as $package ) {
			if( !in_array( $package, $_REQUEST['packages'] ) ) {
				$gBitSystem->storePreference( 'package_'.$package, 'n' );
				$deActivated[] = $package;
			}
		}
	}

	$gBitSmarty->assign( 'next_step', $step + 1 );
	$gBitSmarty->assign( 'deActivated', $deActivated );
	// display the confirmation page
	$app = '_done';
} elseif( !empty(  $_REQUEST['skip'] ) ) {
	// if there were no conflicts, we move on to the next page
	header( "Location: ".$_SERVER['PHP_SELF']."?step=".++$step );
}

$gBitSmarty->assign( 'serviceList', $serviceList );
?>
