<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_cleanup.php,v 1.24 2008/10/13 19:08:32 squareing Exp $
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



// ===================== Meta table update =====================
// We have a special case: we need to remove the old meta tables in the 
// database and replace them with the new meta schema. simply check for the 
// original set, if they exist, we'll add a button to the page and allow users 
// to upgrade.
$metaTables = array();
if( in_array( 'liberty_meta_content_map', $dbTables['unused'] ) || ( !empty( $dbTables['missing']['liberty'] ) && in_array( 'liberty_meta_titles', $dbTables['missing']['liberty'] ))) {
	// we have established that we have the liberty_meta_content_map table in the database.
	// this means that we need to remove the 3 old meta tables before we can proceede.
	$metaTables = array(
		'old' => array(
			'tables' => array(
				'liberty_meta_content_map',
				'liberty_meta_data',
				'liberty_meta_types',
			),
		),
		'new' => array(
			'tables' => array(
				'liberty_meta_types',
				'liberty_meta_titles',
				'liberty_attachment_meta_data',
			),
			'sequences' => array(
				'liberty_meta_types_id_seq',
				'liberty_meta_titles_id_seq',
			),
		),
	);
}



// ===================== Permissions =====================
// check all permissions, compare them to each other and see if there are old 
// permissions and ones that need to be inserted
$query = "SELECT * FROM `".BIT_DB_PREFIX."users_permissions` ORDER BY `package` ASC";
$result = $gBitInstaller->mDb->query( $query );
while( !$result->EOF ) {
	foreach( $result->fields as $r ) {
		$bitPerms[$result->fields['perm_name']][] = $r;
	}
	$bitPerms[$result->fields['perm_name']]['sql'][] = "DELETE FROM `".BIT_DB_PREFIX."users_group_permissions` WHERE `perm_name`='".$result->fields['perm_name']."'";
	$bitPerms[$result->fields['perm_name']]['sql'][] = "DELETE FROM `".BIT_DB_PREFIX."users_permissions` WHERE `perm_name`='".$result->fields['perm_name']."'";
	$result->MoveNext();
}

// we will make sure all the permission levels are what they should be. we will 
// update these without consulting the user. this is purely backend stuff, has 
// no outcome on the site itself but determines what the default permission 
// level is. the user can never modify these settings.
foreach( array_keys( $gBitInstaller->mPermHash ) as $perm ) {
	// permission level is stored in [2]
	$bindVars = array();
	if( !empty( $bitPerms[$perm] ) && $gBitInstaller->mPermHash[$perm][2] != $bitPerms[$perm][2] ) {
		$query = "UPDATE `".BIT_DB_PREFIX."users_permissions` SET `perm_level` = ? WHERE `perm_name` = ?";
		$bindVars[] = $gBitInstaller->mPermHash[$perm][2];
		$bindVars[] = $perm;
		$gBitInstaller->mDb->query( $query, $bindVars );
	}
}

// compare both perm arrays with each other and work out what permissions need 
// to be added and which ones removed
$insPerms = $delPerms = array();
foreach( array_keys( $gBitInstaller->mPermHash ) as $perm ) {
	if( !in_array( $perm, array_keys( $bitPerms ))) {
		if( $gBitInstaller->isInstalled( $gBitInstaller->mPermHash[$perm][3] )) {
			$insPerms[$perm] = $gBitInstaller->mPermHash[$perm];
		}
	}
}

foreach( array_keys( $bitPerms ) as $perm ) {
	if( !in_array( $perm, array_keys( $gBitInstaller->mPermHash ) ) ) {
		$delPerms[$perm] = $bitPerms[$perm];
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

		if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] )) {
			$gBitInstaller->debug();
			$gBitInstallDb->debug = 99;
		}

		// If we use MySql check which storage engine to use
		if( isset( $_SESSION['use_innodb'] ) ){
			if( $_SESSION['use_innodb'] == TRUE ) {
				$build = array('NEW', 'MYSQL' => 'ENGINE=INNODB');
			} else {
				$build = array('NEW', 'MYSQL' => 'ENGINE=MYISAM');
			}
		} else {
			$build = 'NEW';
		}

		$tablePrefix = $gBitInstaller->getTablePrefix();
		foreach( $dbIntegrity as $package => $info ) {
			foreach( $info['tables'] as $table ) {
				$completeTableName = $tablePrefix.$table['name'];
				$sql = $dict->CreateTableSQL( $completeTableName, $gBitInstaller->mPackages[$package]['tables'][$table['name']], $build );
				// Uncomment this line to see the create sql
				//vd( $sql );
				if( $sql ) {
					$dict->ExecuteSQLArray( $sql );
				}
			}
		}
	}
}

// update old meta schema to new one
if( !empty(  $_REQUEST['update_tables'] ) && !empty( $metaTables )) {
	$gBitInstallDb = &ADONewConnection( $gBitDbType );

	if( $gBitInstallDb->Connect( $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName )) {
		$dict = NewDataDictionary( $gBitInstallDb );

		if( !$gBitInstaller->mDb->getCaseSensitivity() ) {
			$dict->connection->nameQuote = '';
		}

		if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] )) {
			$gBitInstaller->debug();
			$gBitInstallDb->debug = 99;
		}

		// If we use MySql check which storage engine to use
		if( isset( $_SESSION['use_innodb'] ) ){
			if( $_SESSION['use_innodb'] == TRUE ) {
				$build = array('NEW', 'MYSQL' => 'ENGINE=INNODB');
			} else {
				$build = array('NEW', 'MYSQL' => 'ENGINE=MYISAM');
			}
		} else {
			$build = 'NEW';
		}

		$tablePrefix = $gBitInstaller->getTablePrefix();

		// first we remove the old tables
		foreach( $metaTables['old']['tables'] as $table ) {
			$completeTableName = $tablePrefix.$table;
			if( $sql = $dict->DropTableSQL( $completeTableName )) {
				$dict->ExecuteSQLArray( $sql );
			}
		}

		// then we create the new tables and sequences
		foreach( $metaTables['new']['tables'] as $table ) {
			$completeTableName = $tablePrefix.$table;
			if( $sql = $dict->CreateTableSQL( $completeTableName, $gBitInstaller->mPackages['liberty']['tables'][$table], $build )) {
				$dict->ExecuteSQLArray( $sql );
			}
		}

		foreach( $metaTables['new']['sequences'] as $sequenceIdx ) {
			$schemaQuote = strrpos( BIT_DB_PREFIX, '`' );
			$sequencePrefix = ( $schemaQuote ? substr( BIT_DB_PREFIX,  $schemaQuote + 1 ) : BIT_DB_PREFIX );
			$result = $gBitInstallDb->CreateSequence( $sequencePrefix.$sequenceIdx, $gBitInstaller->mPackages['liberty']['sequences'][$sequenceIdx]['start'] );
		}

		// inform the template that the old tables have been sorted
		$metaTables = array();
	}

	// make sure plugins are up to date.
	$gLibertySystem->scanAllPlugins();
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

// make sure everything is up to date after the above changes
$dbTables = $gBitInstaller->verifyInstalledPackages( 'all' );
$dbIntegrity = install_check_database_integrity( $dbTables );
$gBitSmarty->assign( 'dbIntegrity', $dbIntegrity );

$gBitSmarty->assign( 'serviceList', $serviceList );
$gBitSmarty->assign( 'metaTables', $metaTables );



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
