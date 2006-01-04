<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_cleanup.php,v 1.1.2.1 2006/01/04 12:11:29 squareing Exp $
 * @package install
 * @subpackage functions
 */

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step );

$schema = $gBitInstaller->mPackages;
ksort( $schema );
$gBitSmarty->assign_by_ref( 'schema', $schema );

// check all permissions, compare them to each other and see if there are old permissions and ones that need to be inserted
$query = "SELECT * FROM `".BIT_DB_PREFIX."users_permissions` ORDER BY `package` ASC";
$result = $gBitInstaller->mDb->query( $query );
while( !$result->EOF ) {
	foreach( $result->fields as $r ) {
		$bitPrefs[$result->fields['perm_name']][] = $r;
	}
	$bitPrefs[$result->fields['perm_name']]['sql'] = "DELETE FROM `".BIT_DB_PREFIX."users_permissions` WHERE `perm_name`='".$result->fields['perm_name']."'";
	$result->MoveNext();
}

// compare both perm arrays and work out what needs to be done
$insPerms = $delPerms = array();
foreach( array_keys( $gBitInstaller->mPermHash ) as $perm ) {
	if( !in_array( $perm, array_keys( $bitPrefs ) ) ) {
		if( $schema[$gBitInstaller->mPermHash[$perm][3]]['installed'] ) {
			$insPerms[$perm] = $gBitInstaller->mPermHash[$perm];
		}
	}
}

foreach( array_keys( $bitPrefs ) as $perm ) {
	if( !in_array( $perm, array_keys( $gBitInstaller->mPermHash ) ) ) {
		$delPerms[$perm] = $bitPrefs[$perm];
	}
}
$gBitSmarty->assign( 'delPerms', $delPerms );
$gBitSmarty->assign( 'insPerms', $insPerms );

// check if we have installed more than one service of any given type
$serviceList = array();
if( !empty( $gLibertySystem->mServices ) ) {
	foreach( $gLibertySystem->mServices as $service_name => $service ) {
		if( count( $service ) > 1 ) {
			$serviceList[$service_name] = $service;
		}
	}
}

// if any of the serviceList items have been unchecked, disable the appropriate packages
if( !empty(  $_REQUEST['resolve_conflicts'] ) ) {
	if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
		$gBitInstaller->debug();
		$gBitInstallDb->debug = 99;
	}
	$fix = array_merge( $delPerms, $insPerms );
	if( !empty( $_REQUEST['perms'] ) ) {
		foreach( $_REQUEST['perms'] as $perm ) {
			$gBitInstaller->mDb->query( $fix[$perm]['sql'] );
			$fixedPermissions[] = $fix[$perm];
		}
	}
	$gBitSmarty->assign( 'fixedPermissions', $fixedPermissions );

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
