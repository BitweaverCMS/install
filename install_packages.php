<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_packages.php,v 1.3.2.3 2005/06/30 00:22:01 spiderr Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// we set this variable since || admin >> kernel >> packages || uses this file as well
if( !isset( $step ) ) {
	$step = NULL;
}

// set the maximum execution time to very high
ini_set("max_execution_time", "86400");

// assign next step in installation process
$smarty->assign( 'next_step',$step );

// pass all package data to template
$schema = $gBitInstaller->mPackages;
ksort( $schema );
$smarty->assign_by_ref( 'schema', $schema );

// confirm that we have all the admin data in the session before proceeding
if( !$gBitInstaller && (empty( $_SESSION['login'] ) || empty( $_SESSION['password'] ) || empty( $_SESSION['email'] )) ) {
	$smarty->assign( 'error', $error = TRUE );
}

if( isset( $_REQUEST['fSubmitDbCreate'] ) ) {
	if( $gBitDbType == 'sybase' ) {
		// avoid database change messages
		ini_set('sybct.min_server_severity', '11');
	}

	$gBitInstallDb = &ADONewConnection($gBitDbType);

	if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
		$gBitInstaller->debug();
		$gBitInstallDb->debug = 99;
	}

	if( $gBitInstallDb->Connect($gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName) ) {
		$tablePrefix = $gBitInstaller->getTablePrefix();

		$dict = NewDataDictionary( $gBitInstallDb, $gBitDbType );
		// SHOULD HANDLE INNODB so foreign keys are cool - XOXO spiderr
		// $tableOptions = array('mysql' => 'TYPE=INNODB', 'REPLACE');
		$sqlArray = array();
		if (isset($_REQUEST['PACKAGE'])) {
			error_reporting( E_ALL );
			// packages are sorted alphabetically. but we really need a /etc/rc.d/rc.3 style loading precidence!
			// We perform several loops through mPackages due to foreign keys, and some packages may insert
			// value into other packages tables - typically users_permissions, bit_preferences, etc...
			sort( $_REQUEST['PACKAGE'] );
			// 1. let's generate all the tables's
			if ( $_SESSION['first_install'] ) {
				$build = array( 'NEW' );
			} else {
				$build = array( 'REPLACE' );
			}

			foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
				if( in_array( $package, $_REQUEST['PACKAGE'] ) || ( empty( $gBitInstaller->mPackages[$package]['installed'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] ) ) ) {
					// Install tables
					if( !empty( $gBitInstaller->mPackages[$package]['tables'] ) && is_array( $gBitInstaller->mPackages[$package]['tables'] ) ) {
						foreach( array_keys( $gBitInstaller->mPackages[$package]['tables'] ) as $tableName ) {
							$completeTableName = $tablePrefix.$tableName;
/*
							if( ($sql = $dict->DropTableSQL( $completeTableName ))
								&& @$dict->ExecuteSQLArray( $sql )
							) {
							} else {
								print '<dd><font color="red">Failed to create '.$completeTableName.'</font>';
							}
*/
							$sql = $dict->CreateTableSQL( $completeTableName, $gBitInstaller->mPackages[$package]['tables'][$tableName], $build );
// Uncomment this line to see the create sql
//vd( $sql );
							if( $sql && ($dict->ExecuteSQLArray( $sql ) > 0 ) ) {
							} else {
								print '<span class="error">Failed to create '.$completeTableName.'</span>';
								array_push( $failedcommands, $sql );
							}
						}
					}
				}
			}

			// 2. let's generate all the indexes, and sequences
			foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
				$schemaQuote = strrpos( BIT_DB_PREFIX, '`' );
				$sequencePrefix = ( $schemaQuote ? substr( BIT_DB_PREFIX,  $schemaQuote + 1 ) : BIT_DB_PREFIX );
				if( in_array( $package, $_REQUEST['PACKAGE'] ) || ( empty( $gBitInstaller->mPackages[$package]['installed'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] ) ) ) {
					// Install Indexes
					if( isset( $gBitInstaller->mPackages[$package]['indexes'] ) && is_array( $gBitInstaller->mPackages[$package]['indexes'] ) ) {
						foreach( array_keys( $gBitInstaller->mPackages[$package]['indexes'] ) as $tableIdx ) {
							$completeTableName = $sequencePrefix.$gBitInstaller->mPackages[$package]['indexes'][$tableIdx]['table'];

							$sql = $dict->CreateIndexSQL( $tableIdx, $completeTableName, $gBitInstaller->mPackages[$package]['indexes'][$tableIdx]['cols'], $gBitInstaller->mPackages[$package]['indexes'][$tableIdx]['opts'] );
							if( $sql && ($dict->ExecuteSQLArray( $sql ) > 0 ) ) {
							} else {
								print '<span class="error">Failed to create '.$completeTableName.'</span>';
								array_push( $failedcommands, $sql );
							}
						}
					}
					if( isset( $gBitInstaller->mPackages[$package]['sequences'] ) && is_array( $gBitInstaller->mPackages[$package]['sequences'] ) ) {
						foreach( array_keys( $gBitInstaller->mPackages[$package]['sequences'] ) as $sequenceIdx ) {
							$sql = $gBitInstallDb->CreateSequence( $sequencePrefix.$sequenceIdx, $gBitInstaller->mPackages[$package]['sequences'][$sequenceIdx]['start'] );
						}
					}
				}
			}

			// Force a reload of all our preferences
			$gBitInstaller->mPrefs = '';
			$gBitInstaller->loadPreferences();

			// 3. activate all selected & required packages
			foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
				if( in_array( $package, $_REQUEST['PACKAGE'] ) || !empty( $gBitInstaller->mPackages[$package]['required'] ) ) {
					$gBitInstaller->storePreference( 'package_'.strtolower( $package ), 'y', $package );
					// we'll default wiki to the home page
					if( $package == 'wiki' ) {
						$gBitSystem->storePreference( "bitIndex", WIKI_PKG_NAME );
					}
				}
			}

			// and let's turn on phpBB so people can find it easily.
			if( defined( 'PHPBB_PKG_NAME' ) ) {
				$gBitInstaller->storePreference( 'package_phpbb', 'y' );
			}

			// and let's turn OFF tinymce cause it is annoying if you want to use the wiki
			if( defined( 'TINYMCE_PKG_NAME' ) ) {
				$gBitInstaller->storePreference( 'package_tinymce', 'n' );
			}

			// 4. run the defaults through afterwards so we can be sure all tables needed have been created
			foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
				if( in_array( $package, $_REQUEST['PACKAGE'] ) || ( empty( $gBitInstaller->mPackages[$package]['installed'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] ) ) ) {

					// this list of installed packages is used to show newly installed packages
					$package_list[] = $package;
					if( !empty( $gBitInstaller->mPackages[$package]['defaults'] ) ) {
						foreach( $gBitInstaller->mPackages[$package]['defaults'] as $def ) {
							$gBitInstaller->query( $def );
						}
					}
				}
			}

			// only install modules during the first install
			if( isset( $_SESSION['first_install'] ) && $_SESSION['first_install'] == TRUE ) {
				/**
				 * Some packages have some special things to take care of here.
				 */
				require_once( KERNEL_PKG_PATH.'mod_lib.php' );
				foreach( $gBitInstaller->mInstallModules as $mod ) {
					$mod['user_id'] = ROOT_USER_ID;
					if( !isset( $mod['layout'] ) ) {
						$mod['layout'] = DEFAULT_PACKAGE;
					}
					$modlib->storeModule( $mod );
					$modlib->storeLayout( $mod );
				}
			}

			// Installing users has some special things to take care of here and needs a separate check.
			if( in_array( 'users', $_REQUEST['PACKAGE'] ) || empty( $gBitInstaller->mPackages['users']['installed'] ) ) {
				// now let's set up some default data. Group_id's are hardcoded in users/schema_inc defaults
				$gBitUser->assign_level_permissions( ANONYMOUS_GROUP_ID, 'basic' );
				$gBitUser->assign_level_permissions( 3, 'registered' );
				$gBitUser->assign_level_permissions( 2, 'editors' );
				$gBitUser->assign_level_permissions( 1, 'admin' );

				// Create 'Anonymous' user has id= -1 just like phpBB
				$anonUser = new BitPermUser();
				$storeHash = array( 'real_name' => 'Guest', 'login' => 'guest', 'password' => $_SESSION['password'], 'email' =>'guest@localhost', 'pass_due' => FALSE, 'user_id' => ANONYMOUS_USER_ID );
				if( $anonUser->store( $storeHash ) ) {

					// Remove anonymous from registered group
					$regGroupId = $anonUser->groupExists( 'Registered', ROOT_USER_ID );
					$anonUser->removeUserFromGroup( ANONYMOUS_USER_ID, $regGroupId );
					$anonUser->addUserToGroup( ANONYMOUS_USER_ID, ANONYMOUS_GROUP_ID);
				}

				// Creating 'root' user has id=1. phpBB starts with user_id=2, so this is a hack to keep things in sync
				$rootUser = new BitPermUser();
				$storeHash = array( 'real_name' => 'root', 'login' => 'root', 'password' => $_SESSION['password'], 'email' => 'root@localhost', 'pass_due' => FALSE, 'user_id' => ROOT_USER_ID );
				if( $rootUser->store( $storeHash ) ) {
					$rootUser->addUserToGroup( ROOT_USER_ID, 1 );
				}

				$adminUser = new BitPermUser();
				$storeHash = array( 'real_name' => $_SESSION['real_name'], 'login' => $_SESSION['login'], 'password' => $_SESSION['password'], 'email' =>$_SESSION['email'], 'pass_due' => FALSE );
				if( $adminUser->store( $storeHash ) ) {
					$adminUser->addUserToGroup($adminUser->mUserId, 1 );
				}

				// kill admin info in $_SESSION
				unset( $_SESSION['real_name'] );
				unset( $_SESSION['login'] );
				unset( $_SESSION['password'] );
				unset( $_SESSION['email'] );
			}
			
			/** 
			 * setup categories
			 */
			if( in_array( 'categories', $_REQUEST['PACKAGE'] ) ) {
				// Installing categories has some special things to take care of here and needs a separate check.
				require_once( CATEGORIES_PKG_PATH.'categ_lib.php' );
				$categlib->add_category( NULL, 'TOP', NULL, 0 );
			}
		}
		$smarty->assign( 'next_step', $step + 1 );
		$smarty->assign( 'package_list', $package_list );
		$smarty->assign( 'failedcommands', !empty( $failedcommands ) ? $failedcommands : NULL );
		// display the confirmation page
		$app = '_done';
	} else {
		// if we can't connect to the db, move back 2 steps
		header( "Location: ".$_SERVER['PHP_SELF']."?step=".$step - 2 );
	}
}
?>
