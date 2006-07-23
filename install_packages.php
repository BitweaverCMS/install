<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_packages.php,v 1.38 2006/07/23 00:56:01 jht001 Exp $
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
ini_set( "max_execution_time", "86400" );

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step );

// pass all package data to template
$schema = $gBitInstaller->mPackages;
ksort( $schema );
$gBitSmarty->assign_by_ref( 'schema', $schema );

// confirm that we have all the admin data in the session before proceeding
if( !empty( $_REQUEST['packages'] ) && in_array( 'users', $_REQUEST['packages'] ) && ( empty( $_SESSION['login'] ) || empty( $_SESSION['password'] ) || empty( $_SESSION['email'] ) ) ) {
	// we have lost our session password and we are not installed
	header( 'Location: install.php?step=1' );
	die;
}

if( !empty( $_REQUEST['cancel'] ) ) {
	header( 'Location: install.php?step='.( $step + 1 ) );
} elseif( !empty( $_REQUEST['packages'] ) && is_array( $_REQUEST['packages'] ) && !empty( $_REQUEST['method'] ) && !empty( $_REQUEST['submit_packages'] ) ) {
	// make sure that required pkgs are only present when we are installing
	if( ( $method = ( $_REQUEST['method'] ) ) == 'install' && !$_SESSION['first_install'] ) {
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] ) ) {
				$gBitSmarty->assign( 'warning', "There was a problem with the package selection. we just caught it in time before your system got destroyed." );
				$method = FALSE;
			}
		}
	}

	if( $gBitDbType == 'sybase' ) {
		// avoid database change messages
		ini_set('sybct.min_server_severity', '11');
	}

	$gBitInstallDb = &ADONewConnection( $gBitDbType );

	if( !empty( $gDebug ) || !empty( $_REQUEST['debug'] ) ) {
		$gBitInstaller->debug();
		$gBitInstallDb->debug = 99;
	}

	// by now $method should be populated with something
	if( $gBitInstallDb->Connect( $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName ) && !empty( $method ) ) {
		if ( $_SESSION['first_install'] && $gBitDbType == 'firebird' ) {
			$result = $gBitInstallDb->Execute( "DECLARE EXTERNAL FUNCTION LOWER CSTRING(80) RETURNS CSTRING(80) FREE_IT ENTRY_POINT 'IB_UDF_lower' MODULE_NAME 'ib_udf'" );
			$result = $gBitInstallDb->Execute( "DECLARE EXTERNAL FUNCTION RAND RETURNS DOUBLE PRECISION BY VALUE ENTRY_POINT 'IB_UDF_rand' MODULE_NAME 'ib_udf'" );
		}
		$tablePrefix = $gBitInstaller->getTablePrefix();

		$dict = NewDataDictionary( $gBitInstallDb, $gBitDbType );

		if( !$gBitInstaller->mDb->getCaseSensitivity() ) {
			// set nameQuote to blank
			$dict->connection->nameQuote = '';
		}

		// SHOULD HANDLE INNODB so foreign keys are cool - XOXO spiderr
		// $tableOptions = array('mysql' => 'TYPE=INNODB', 'REPLACE');
		$sqlArray = array();

		//error_reporting( E_ALL );
		// packages are sorted alphabetically. but we really need a /etc/rc.d/rc.3 style loading precidence!
		// We perform several loops through mPackages due to foreign keys, and some packages may insert
		// value into other packages tables - typically users_permissions, bit_preferences, etc...
		sort( $_REQUEST['packages'] );

		// 1. let's generate all the tables's
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) ) {
				// work out what we're going to do with this package
				if ( $method == 'install' && $_SESSION['first_install'] ) {
					$build = array( 'NEW' );
				} elseif( $method == "install" && empty( $gBitInstaller->mPackages[$package]['installed'] ) ) {
					$build = array( 'NEW' );
				} elseif( $method == "reinstall" && !empty( $gBitInstaller->mPackages[$package]['installed'] ) ) {
					$build = array( 'REPLACE' );
				} elseif( $method == "uninstall" && $gBitInstaller->mPackages[$package]['installed'] == 1 ) {
					$build = array( 'DROP' );
				}

				// Install tables
				if( !empty( $gBitInstaller->mPackages[$package]['tables'] ) && is_array( $gBitInstaller->mPackages[$package]['tables'] ) ) {
					foreach( array_keys( $gBitInstaller->mPackages[$package]['tables'] ) as $tableName ) {
						$completeTableName = $tablePrefix.$tableName;
						$sql = $dict->CreateTableSQL( $completeTableName, $gBitInstaller->mPackages[$package]['tables'][$tableName], $build );
						// Uncomment this line to see the create sql
						//vd( $sql );
						if( $sql && ( $dict->ExecuteSQLArray( $sql ) > 0 ) ) {
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
			if( in_array( $package, $_REQUEST['packages'] ) ) {
				if( $method == 'install' || $method == 'reinstall' ) {
					$schemaQuote = strrpos( BIT_DB_PREFIX, '`' );
					$sequencePrefix = ( $schemaQuote ? substr( BIT_DB_PREFIX,  $schemaQuote + 1 ) : BIT_DB_PREFIX );

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
				} elseif( $method == 'uninstall' ) {
					if( isset( $gBitInstaller->mPackages[$package]['sequences'] ) && is_array( $gBitInstaller->mPackages[$package]['sequences'] ) ) {
						foreach( array_keys( $gBitInstaller->mPackages[$package]['sequences'] ) as $sequenceIdx ) {
							$sql = $gBitInstallDb->DropSequence( $sequencePrefix.$sequenceIdx );
						}
					}
				}
			}
		}
		// Force a reload of all our preferences
		$gBitInstaller->mPrefs = '';
		$gBitInstaller->loadConfig();

		// 3. activate all selected & required packages
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) ) {
				if( $method == 'install' || $method == 'reinstall' ) {
					$gBitSystem->storeConfig( 'package_'.strtolower( $package ), 'y', $package );
					$gBitInstaller->mPackages[strtolower( $package )]['installed'] = TRUE;
					$gBitInstaller->mPackages[strtolower( $package )]['active_switch'] = TRUE;
					// we'll default wiki to the home page
					if( defined( 'WIKI_PKG_NAME' ) && $package == WIKI_PKG_NAME ) {
						$gBitSystem->storeConfig( "bit_index", WIKI_PKG_NAME, WIKI_PKG_NAME );
					}
				} elseif( $method == 'uninstall' ) {
					// TODO: allow option to remove related content from liberty_content and liberty_structures
					// should be possible using $gLibertySystem->mContentTypes and the appropriate GUIDs
					// Cascade user_preferences if necessary
// this has to be done using the individual content_ids from liberty_content
//					$delete = "DELETE FROM `".$tablePrefix."liberty_content_prefs` " .
//						"WHERE `pref_name` IN ( SELECT `name` FROM `kernel_prefs` WHERE `package` = '".$package."')";
//					$gBitInstaller->mDb->query( $delete );
					// Delete user_permissions ( need to ensure package is set in table )
					$delete = "DELETE FROM `".$tablePrefix."users_permissions`
						WHERE `package` = '".$package."'";
					$gBitInstaller->mDb->query( $delete );
					// Delete preferences ( need to ensure package is set in table )
					$delete = "DELETE FROM `".$tablePrefix."kernel_config`
						WHERE `package` = '".$package."'";
					$gBitInstaller->mDb->query( $delete );
				}
			}
		}

# this is bad if phpBB isn't being used...
#		// and let's turn on phpBB so people can find it easily.
#		if( defined( 'PHPBB_PKG_NAME' ) ) {
#			$gBitSystem->storeConfig( 'package_phpbb', 'y', PHPBB_PKG_NAME );
#		}

		// 4. run the defaults through afterwards so we can be sure all tables needed have been created
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if (!empty($package)) {
				if( in_array( $package, $_REQUEST['packages'] ) || ( empty( $gBitInstaller->mPackages[$package]['installed'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] ) ) ) {
					if( $method == 'install' || $method == 'reinstall' ) {
						// this list of installed packages is used to show newly installed packages
						if( !empty( $gBitInstaller->mPackages[$package]['defaults'] ) ) {
							foreach( $gBitInstaller->mPackages[$package]['defaults'] as $def ) {
							if ($gBitInstaller->mDb->mType == 'firebird' ) $def = preg_replace("/\\\'/","''", $def );
								$gBitInstaller->mDb->query( $def );
							}
						}
					} else {
						// This is where any links to clear data not in the current package will be processed
					}
					// this is to list any processed packages
					$packageList[$method][] = $package;
				}
			}
		}

		// Do first install stuff only
		if( isset( $_SESSION['first_install'] ) && $_SESSION['first_install'] == TRUE ) {
			/**
			* Some packages have some special things to take care of here.
			*/
			foreach( $gBitInstaller->mInstallModules as $mod ) {
				$mod['user_id'] = ROOT_USER_ID;
				if( !isset( $mod['layout'] ) ) {
					$mod['layout'] = DEFAULT_PACKAGE;
				}
				$gBitThemes->storeModule( $mod );
				$gBitThemes->storeLayout( $mod );
			}

			// Installing users has some special things to take care of here and needs a separate check.
			if( in_array( 'users', $_REQUEST['packages'] ) ) {
				// These hardcoded queries need to go in here to avoid constraint violations
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."liberty_plugins` (`plugin_guid`, `plugin_type`, `is_active`, `plugin_description`) VALUES ( 'tikiwiki', 'format', 'y', 'TikiWiki Syntax Format Parser' )" );
				// Creating 'root' user has id=1. phpBB starts with user_id=2, so this is a hack to keep things in sync
				$rootUser = new BitPermUser();
				$storeHash = array( 'real_name' => 'root', 'login' => 'root', 'password' => $_SESSION['password'], 'email' => 'root@localhost', 'pass_due' => FALSE, 'user_id' => ROOT_USER_ID );
				if( $rootUser->store( $storeHash ) ) {
					$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`) VALUES ( ".ROOT_USER_ID.", 1, 'Administrators','Site operators')" );
					$rootUser->addUserToGroup( ROOT_USER_ID, 1 );
				} else {
					vd( $rootUser->mErrors );
				}

				// now let's set up some default data. Group_id's are hardcoded in users/schema_inc defaults
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`) VALUES ( ".ROOT_USER_ID.", -1, 'Anonymous','Public users not logged')" );
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`) VALUES ( ".ROOT_USER_ID.", 2, 'Editors','Site  Editors')" );
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`,`is_default`) VALUES ( ".ROOT_USER_ID.", 3, 'Registered', 'Users logged into the system', 'y')" );

				$gBitUser->assign_level_permissions( ANONYMOUS_GROUP_ID, 'basic' );
				$gBitUser->assign_level_permissions( 3, 'registered' );
				$gBitUser->assign_level_permissions( 2, 'editors' );
				$gBitUser->assign_level_permissions( 1, 'admin' );

				// Create 'Anonymous' user has id= -1 just like phpBB
				$anonUser = new BitPermUser();
				$storeHash = array( 'real_name' => 'Guest', 'login' => 'guest', 'password' => $_SESSION['password'], 'email' =>'guest@localhost', 'pass_due' => FALSE, 'user_id' => ANONYMOUS_USER_ID,  'default_group_id' => ANONYMOUS_GROUP_ID );
				if( $anonUser->store( $storeHash ) ) {

					// Remove anonymous from registered group
					$regGroupId = $anonUser->groupExists( 'Registered', ROOT_USER_ID );
					$anonUser->removeUserFromGroup( ANONYMOUS_USER_ID, $regGroupId );
					$anonUser->addUserToGroup( ANONYMOUS_USER_ID, ANONYMOUS_GROUP_ID);
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
		}

		$gBitSmarty->assign( 'next_step', $step + 1 );
		asort( $packageList );
		$gBitSmarty->assign( 'packageList', $packageList );
		$gBitSmarty->assign( 'failedcommands', !empty( $failedcommands ) ? $failedcommands : NULL );
		// display the confirmation page
		$app = '_done';
	} else {
		// if we can't connect to the db, move back 2 steps
		header( "Location: ".$_SERVER['PHP_SELF']."?step=".$step - 2 );
	}
} elseif( !empty( $_REQUEST['submit_packages'] ) ) {
	$gBitSmarty->assign( 'warning', "No package was selected to install or uninstall" );
}
?>
