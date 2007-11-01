<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_cleanup.php,v 1.14 2007/11/01 11:10:44 squareing Exp $
 * @package install
 * @subpackage functions
 */

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step );

$schema = $gBitInstaller->mPackages;
ksort( $schema );
$gBitSmarty->assign_by_ref( 'schema', $schema );



// ===================== Post install table check =====================
// $dbTables is the output of BitSystem::verifyInstalledPackages() in 
// install_inc.php and contains all tables that are not present in the database 
// - even tables of packages that are not installed
$dbIntegrity = install_check_database_integrity( $dbTables );



// ===================== Permissions =====================
// check all permissions, compare them to each other and see if there are old permissions and ones that need to be inserted
$query = "SELECT * FROM `".BIT_DB_PREFIX."users_permissions` ORDER BY `package` ASC";
$result = $gBitInstaller->mDb->query( $query );
while( !$result->EOF ) {
	foreach( $result->fields as $r ) {
		$bitPrefs[$result->fields['perm_name']][] = $r;
	}
	$bitPrefs[$result->fields['perm_name']]['sql'][] = "DELETE FROM `".BIT_DB_PREFIX."users_group_permissions` WHERE `perm_name`='".$result->fields['perm_name']."'";
	$bitPrefs[$result->fields['perm_name']]['sql'][] = "DELETE FROM `".BIT_DB_PREFIX."users_permissions` WHERE `perm_name`='".$result->fields['perm_name']."'";
	$result->MoveNext();
}

// compare both perm arrays and work out what needs to be done
$insPerms = $delPerms = array();
foreach( array_keys( $gBitInstaller->mPermHash ) as $perm ) {
	if( !in_array( $perm, array_keys( $bitPrefs ) ) ) {
		if( @$schema[$gBitInstaller->mPermHash[$perm][3]]['installed'] ) {
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



// ===================== Services =====================
// check if we have installed more than one service of any given type
$serviceList = array();
if( !empty( $gLibertySystem->mServices ) ) {
	foreach( $gLibertySystem->mServices as $service_name => $service ) {
		if( count( $service ) > 1 ) {
			$serviceList[$service_name] = $service;
		}
	}
}



// ===================== Process Form =====================
// create missing tables if possible
if( !empty(  $_REQUEST['create_tables'] ) && !empty( $dbIntegrity )) {
	$gBitInstallDb = &ADONewConnection( $gBitDbType );

	if( $gBitInstallDb->Connect( $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName )) {
		$dict = NewDataDictionary( $gBitInstallDb );

		if( !$gBitInstaller->mDb->getCaseSensitivity() ) {
			$dict->connection->nameQuote = '';
		}

		//$gBitInstaller->debug();
		//$gBitInstallDb->debug = 99;

		foreach( $dbIntegrity as $package => $info ) {
			foreach( $info['tables'] as $table ) {
				$tablePrefix = $gBitInstaller->getTablePrefix();
				$completeTableName = $tablePrefix.$table['name'];
				$sql = $dict->CreateTableSQL( $completeTableName, $gBitInstaller->mPackages[$package]['tables'][$table['name']], 'NEW' );
				// Uncomment this line to see the create sql
				//vd( $sql );
				if( $sql ) {
					$dict->ExecuteSQLArray( $sql );
				}
			}
		}

		//$gBitInstallDb->debug = FALSE;
		$dbTables = $gBitInstaller->verifyInstalledPackages( 'all' );
		$dbIntegrity = install_check_database_integrity( $dbTables );
	}
}

// if any of the serviceList items have been unchecked, disable the appropriate packages
if( !empty(  $_REQUEST['resolve_conflicts'] ) ) {
	if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
		$gBitInstaller->debug();
		$gBitInstallDb->debug = 99;
	}
	// === Permissions
	$fixedPermissions = array();
	$groupMap = array();
	$groupMap['basic'] = ANONYMOUS_GROUP_ID;
	$groupMap['registered'] = 3;
	$groupMap['editors'] = 2;
	$groupMap['admin'] = 1;
	if( !empty( $_REQUEST['perms'] ) ) {
		foreach( $_REQUEST['perms'] as $perm ) {
			if( !empty( $delPerms[$perm] )) {
				foreach( $delPerms[$perm]['sql'] as $sql ) {
					$gBitInstaller->mDb->query( $sql );
				}
				$fixedPermissions[] = $delPerms[$perm];
			}

			if( !empty( $insPerms[$perm] )) {
				$gBitInstaller->mDb->query( $insPerms[$perm]['sql'] );
				$fixedPermissions[] = $insPerms[$perm];
				if( !empty( $groupMap[$insPerms[$perm][2]] )) {
					$gBitUser->assignPermissionToGroup( $perm, $groupMap[$insPerms[$perm][2]] );
				}
			}
		}
	}
	$gBitSmarty->assign( 'fixedPermissions', $fixedPermissions );

	// === Services
	$deActivated = array();
	foreach( $serviceList as $service ) {
		foreach( array_keys( $service ) as $package ) {
			$packages = !empty( $_REQUEST['packages'] ) ? $_REQUEST['packages'] : array();
			if( !in_array( $package, $packages )) {
				$gBitSystem->storeConfig( 'package_'.$package, 'n', KERNEL_PKG_NAME );
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
$gBitSmarty->assign( 'dbIntegrity', $dbIntegrity );



/**
 * function - install_check_database_integrity
 */ 
function install_check_database_integrity( $pDbTables ) {
	global $gBitInstaller;
	$ret = array();
	if( !empty( $pDbTables['missing'] ) && is_array( $pDbTables['missing'] )) {
		foreach( array_keys( $pDbTables['missing'] ) as $package ) {
			// we can't use the 'installed' flag in $gBitInstaller->mPackages[$package] because that is set to 'not installed' as soon as a table is missing
			if( count( $gBitInstaller->mPackages[$package]['tables'] ) > count( $pDbTables['missing'][$package] )) {
				// at least one table is missing
				$ret[$package] = array(
					'name'     => ucfirst( $gBitInstaller->mPackages[$package]['name'] ),
					'required' => $gBitInstaller->mPackages[$package]['required'],
				);
				foreach( $pDbTables['missing'][$package] as $table ) {
					$ret[$package]['tables'][$table] = array(
						'name' => $table,
						'sql'  => $gBitInstaller->mPackages[$package]['tables'][$table],
					);
				}
			}
		}
	}
	return $ret;
}
?>
