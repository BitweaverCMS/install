<?php
/**
 * @version $Header$
 * @package install
 * @subpackage functions
 *
 * @copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
 * All Rights Reserved. See below for details and a complete list of authors.
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.
 */

/**
 * we set this variable since || admin >> kernel >> packages || uses this file as well
 */
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
	header( 'Location: '.INSTALL_PKG_URL.'install.php?step=1' );
	die;
}

if( !empty( $_REQUEST['cancel'] ) ) {
	header( 'Location: '.INSTALL_PKG_URL.'install.php?step='.( $step + 1 ) );
} elseif( !empty( $_REQUEST['packages'] ) && is_array( $_REQUEST['packages'] ) && !empty( $_REQUEST['method'] ) && !empty( $_REQUEST['submit_packages'] ) ) {
	// shorthand for the actions we are supposed to perform during an unistall or re-install
	$removeActions = !empty( $_REQUEST['remove_actions'] ) ? $_REQUEST['remove_actions'] : array();

	// make sure that required pkgs are only present when we are installing
	if(( $method = ( $_REQUEST['method'] )) == 'install' && !$_SESSION['first_install'] ) {
		// make sure no required packages are included in this list
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] )) {
				$gBitSmarty->assign( 'warning', "Something unexpected has happened: One of the required packages has appeared in the list of selected packages. This generally only happens if the installation is missing a core database table. Please contact the bitweaver developers team on how to proceed." );
				$method = FALSE;
			}
		}
	} elseif( $method != 'install' && empty( $removeActions ) ) {
		// we are un / reinstalling stuff but no actions have been selected
		$gBitSmarty->assign( 'warning', "You have selected to un / reinstall packages but have not selected any options. Please select at least one." );
		return FALSE;
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
// Leave commented for present, new installations on Firebird should use FB2.1.x and above which have an internal function library
//			$result = $gBitInstallDb->Execute( "DECLARE EXTERNAL FUNCTION LOWER CSTRING(80) RETURNS CSTRING(80) FREE_IT ENTRY_POINT 'IB_UDF_lower' MODULE_NAME 'ib_udf'" );
//			$result = $gBitInstallDb->Execute( "DECLARE EXTERNAL FUNCTION RAND RETURNS DOUBLE PRECISION BY VALUE ENTRY_POINT 'IB_UDF_rand' MODULE_NAME 'ib_udf'" );
		}

		$tablePrefix = $gBitInstaller->getTablePrefix();

		$dict = NewDataDictionary( $gBitInstallDb );

		if( !$gBitInstaller->mDb->getCaseSensitivity() ) {
			// set nameQuote to blank
			$dict->connection->nameQuote = '';
		}

		// When using MySql and installing further packages after first install
		// check to see what storage engine in use, InnoDb or MyIsam,
		// so we don't end up with mixed table types.
		if( $gBitInstaller->isInstalled() ) {
			global $gBitDbType;
			if( preg_match( '/mysql/', $gBitDbType )) {
				$_SESSION['use_innodb'] = FALSE;
				$rs = $gBitDb->Execute("SHOW TABLE STATUS LIKE '%kernel_config'");
				while ( !$rs->EOF) {
					$row = $rs->GetRowAssoc(false);
					switch( isset( $row['Engine'] ) ? strtoupper( $row['Engine'] ) : strtoupper( $row['Type'] )) {
						case 'INNODB':
						case 'INNOBASE':
							$_SESSION['use_innodb'] = TRUE;
							break 2;
					}

					$rs->MoveNext();
				}
				$rs->Close();
			}
		}

		$sqlArray = array();

		//error_reporting( E_ALL );
		// packages are sorted alphabetically. but we really need a /etc/rc.d/rc.3 style loading precidence!
		// We perform several loops through mPackages due to foreign keys, and some packages may insert
		// value into other packages tables - typically users_permissions, bit_preferences, etc...
		sort( $_REQUEST['packages'] );



		// Need to unquote constraints. but this need replacing with a datadict function
		require_once('../kernel/BitDbBase.php');
		$gBitKernelDb = new BitDb();
		$gBitKernelDb->mType = $gBitDbType;

		// ---------------------- 1. ----------------------
		// let's generate all the tables's
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] )) {
				unset( $build );
				// work out what we're going to do with this package
				if ( $method == 'install' && $_SESSION['first_install'] ) {
					$build = array( 'NEW' );
				} elseif( $method == "install" && empty( $gBitInstaller->mPackages[$package]['installed'] )) {
					$build = array( 'NEW' );
				} elseif( $method == "reinstall" && !empty( $gBitInstaller->mPackages[$package]['installed'] ) && in_array( 'tables', $removeActions )) {
					// only set $build if we want to reset the tables - this allows us to reset a package to it's starting values without deleting any content
					$build = array( 'REPLACE' );
				} elseif( $method == "uninstall" && !empty( $gBitInstaller->mPackages[$package]['installed'] ) && in_array( 'tables', $removeActions )) {
					$build = array( 'DROP' );
				}
				// If we use MySql and not DROP anything
				// set correct storage engine to use
				if( isset( $_SESSION['use_innodb'] ) && isset( $build ) &&  $build['0'] != 'DROP' ){
					if( $_SESSION['use_innodb'] == TRUE) {
						$build = array_merge($build, array('MYSQL' => 'ENGINE=INNODB'));
					} else {
						$build = array_merge($build, array('MYSQL' => 'ENGINE=MYISAM'));
					}
				}
				// Install tables - $build is empty when we don't pick tables, when un / reinstalling packages
				if( !empty( $gBitInstaller->mPackages[$package]['tables'] ) && is_array( $gBitInstaller->mPackages[$package]['tables'] ) && !empty( $build )) {
					foreach( array_keys( $gBitInstaller->mPackages[$package]['tables'] ) as $tableName ) {
						$completeTableName = $tablePrefix.$tableName;
						// in case prefix has backticks for schema
						$sql = $dict->CreateTableSQL( $completeTableName, $gBitInstaller->mPackages[$package]['tables'][$tableName], $build );
						// Uncomment this line to see the create sql
						for( $sqlIdx = 0; $sqlIdx < count( $sql ); $sqlIdx++ ) {
							$gBitKernelDb->convertQuery( $sql[$sqlIdx] );
						}
						if( $sql && $dict->ExecuteSQLArray( $sql ) <= 1) {
							$errors[] = 'Failed to create table '.$completeTableName;
							$failedcommands[] = implode(" ", $sql);
						}
					}
				}
			}
		}



		// ---------------------- 2. ----------------------
		// install additional constraints
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) && ($method == 'install' || $method == 'reinstall' )
				&& !empty( $gBitInstaller->mPackages[$package]['constraints'] ) && is_array( $gBitInstaller->mPackages[$package]['constraints'] ) ) {
				foreach( array_keys($gBitInstaller->mPackages[$package]['constraints']) as $tableName ) {
					$completeTableName = $tablePrefix.$tableName;
					foreach( array_keys($gBitInstaller->mPackages[$package]['constraints'][$tableName]) as $constraintName ) {
						$sql = 'ALTER TABLE `'.$completeTableName.'` ADD CONSTRAINT `'.$constraintName.'` '.$gBitInstaller->mPackages[$package]['constraints'][$tableName][$constraintName];
						$gBitKernelDb->convertQuery($sql);
						$ret = $gBitInstallDb->Execute( $sql );
						if ( $ret === false ) {
							$errors[] = 'Failed to add constraint '.$constraintName.' to table '.$completeTableName;
							$failedcommands[] = $sql;
						}
					}
				}
			}
		}



		// ---------------------- 3. ----------------------
		// let's generate all the indexes, and sequences
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) ) {
				// set prefix
				$schemaQuote = strrpos( BIT_DB_PREFIX, '`' );
				$sequencePrefix = ( $schemaQuote ? substr( BIT_DB_PREFIX,  $schemaQuote + 1 ) : BIT_DB_PREFIX );

				if( $method == 'install' || ( $method == 'reinstall' && in_array( 'tables', $removeActions ))) {
					// Install Indexes
					if( isset( $gBitInstaller->mPackages[$package]['indexes'] ) && is_array( $gBitInstaller->mPackages[$package]['indexes'] ) ) {
						foreach( array_keys( $gBitInstaller->mPackages[$package]['indexes'] ) as $tableIdx ) {
							$completeTableName = $sequencePrefix.$gBitInstaller->mPackages[$package]['indexes'][$tableIdx]['table'];

							$sql = $dict->CreateIndexSQL( $tableIdx, $completeTableName, $gBitInstaller->mPackages[$package]['indexes'][$tableIdx]['cols'], $gBitInstaller->mPackages[$package]['indexes'][$tableIdx]['opts'] );
							if( $sql && $dict->ExecuteSQLArray( $sql ) <= 1) {
								$errors[] = 'Failed to create index '.$tableIdx." on ".$completeTableName;
								$failedcommands[] = implode(" ", $sql);
							}
						}
					}

					if( $method == 'reinstall' && in_array( 'tables', $removeActions )) {
						if( isset( $gBitInstaller->mPackages[$package]['sequences'] ) && is_array( $gBitInstaller->mPackages[$package]['sequences'] ) ) {
							foreach( array_keys( $gBitInstaller->mPackages[$package]['sequences'] ) as $sequenceIdx ) {
								$sql = $gBitInstallDb->DropSequence( $sequencePrefix.$sequenceIdx );
								if (!$sql) {
									$errors[] = 'Failed to drop sequence '.$sequencePrefix.$sequenceIdx;
									$failedcommands[] = "DROP SEQUENCE ".$sequencePrefix.$sequenceIdx;
								}
							}
						}
					}

					if( isset( $gBitInstaller->mPackages[$package]['sequences'] ) && is_array( $gBitInstaller->mPackages[$package]['sequences'] ) ) {
						// If we use InnoDB for MySql we need this to get sequence tables created correctly.
						if( isset( $_SESSION['use_innodb'] ) ) {
							if( $_SESSION['use_innodb'] == TRUE ) {
								$gBitInstallDb->_genSeqSQL = "create table %s (id int not null) ENGINE=INNODB";
							} else {
								$gBitInstallDb->_genSeqSQL = "create table %s (id int not null) ENGINE=MYISAM";
							}
						}
						foreach( array_keys( $gBitInstaller->mPackages[$package]['sequences'] ) as $sequenceIdx ) {
							$sql = $gBitInstallDb->CreateSequence( $sequencePrefix.$sequenceIdx, $gBitInstaller->mPackages[$package]['sequences'][$sequenceIdx]['start'] );
							if (!$sql) {
								$errors[] = 'Failed to create sequence '.$sequencePrefix.$sequenceIdx;
								$failedcommands[] = "CREATE SEQUENCE ".$sequencePrefix.$sequenceIdx." START ".$gBitInstaller->mPackages[$package]['sequences'][$sequenceIdx]['start'];
							}
						}
					}
				} elseif( $method == 'uninstall' && in_array( 'tables', $removeActions )) {
					if( isset( $gBitInstaller->mPackages[$package]['sequences'] ) && is_array( $gBitInstaller->mPackages[$package]['sequences'] ) ) {
						foreach( array_keys( $gBitInstaller->mPackages[$package]['sequences'] ) as $sequenceIdx ) {
							$sql = $gBitInstallDb->DropSequence( $sequencePrefix.$sequenceIdx );
							if (!$sql) {
								$errors[] = 'Failed to drop sequence '.$sequencePrefix.$sequenceIdx;
								$failedcommands[] = "DROP SEQUENCE ".$sequencePrefix.$sequenceIdx;
							}
						}
					}
				}
			}
		}
		// Force a reload of all our preferences
		$gBitInstaller->mPrefs = '';
		$gBitInstaller->loadConfig();



		// ---------------------- 4. ----------------------
		// manipulate the data in kernel_config
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( in_array( $package, $_REQUEST['packages'] ) ) {
				// remove all the requested settings - this is a bit tricky and might require some more testing
				// Remove settings if requested
				if( in_array( 'settings', $removeActions ) ) {
					// get a list of permissions used by this package
					$query = "SELECT `perm_name` FROM `".$tablePrefix."users_permissions` WHERE `package`=?";
					$perms = $gBitInstaller->mDb->getCol( $query, array( $package ));
					// we deal with liberty_content_permissions below
					$tables = array( 'users_group_permissions', 'users_permissions' );
					foreach( $tables as $table ) {
						foreach( $perms as $perm ) {
							$delete = "
								DELETE FROM `".$tablePrefix.$table."`
								WHERE `perm_name`=?";
							$ret = $gBitInstaller->mDb->query( $delete, array( $perm ) );
							if (!$ret) {
								$errors[] = "Error deleting permission ". $perm;
								$failedcommands[] = $delete." ".$perm;
							}
						}
					}

					// list of tables where we store package specific settings
					$tables = array( 'kernel_config' );
					foreach( $tables as $table ) {
						$delete = "
							DELETE FROM `".$tablePrefix.$table."`
							WHERE `package`=? OR `config_name` LIKE ?";
						$ret = $gBitInstaller->mDb->query( $delete, array( $package, $package."%" ));
						if (!$ret) {
							$errors[] = "Error deleting confgis for package ". $package;
							$failedcommands[] = $delete." ".$package;
						}
					}
				}

				// now we can start removing content if requested
				// lots of foreach loops in here
				if( in_array( 'content', $removeActions ) ) {
					// first we need to work out the package specific content details
					foreach( $gLibertySystem->mContentTypes as $contentType ) {
						if( $contentType['handler_package'] == $package ) {
							// first we get a list of content_ids which we can use to scan various tables without content_type_guid column for data
							$query = "SELECT `content_id` FROM `".$tablePrefix."liberty_content` WHERE `content_type_guid`=?";
							$rmContentIds = $gBitInstaller->mDb->getCol( $query, array( $contentType['content_type_guid'] ));

							// list of core tables where bitweaver might store relevant data
							// firstly, we delete using the content ids
							// order is important due to the constraints set in the schema
							$tables = array(
								'liberty_aliases'             => 'content_id',
								'liberty_structures'          => 'content_id',
								'liberty_content_hits'        => 'content_id',
								'liberty_content_history'     => 'content_id',
								'liberty_content_prefs'       => 'content_id',
								'liberty_content_links'       => 'to_content_id',
								'liberty_content_links'       => 'from_content_id',
								'liberty_process_queue'       => 'content_id',
								'liberty_content_permissions' => 'content_id',
								'users_favorites_map'         => 'favorite_content_id'
								// This table needs to be fixed to use content_id instead of page_id
								//'liberty_copyrights'          => 'content_id',

								// liberty comments are tricky. should we remove comments linked to the content being deleted?
								// makes sense to me but only if boards are not installed - xing
								//'liberty_comments'            => 'root_id',
							);
							foreach( $rmContentIds as $contentId ) {
								foreach( $tables as $table => $column ) {
									$delete = "
										DELETE FROM `".$tablePrefix.$table."`
										WHERE `$column`=?";
									$ret = $gBitInstaller->mDb->query( $delete, array( $contentId ));
									if (!$ret) {
										$errors[] = "Error deleting from ". $tablePrefxi.$table;
										$failedcommands[] = $delete." ".$contentId;
									}
								}
							}
							// TODO: get a list of tables that have a liberty_content.content_id constraint and delete those entries that we can
							// remove the entries from liberty_content in the next step
							// one such example is stars and stars_history - we need to automagically recognise tables with such constraints.

							// TODO: we need an option to physically remove files from the server when we uninstall stuff like fisheye and treasury
							// i think we'll need to call the appropriate expunge function but i'm too tired to work out how or where to get that info from

							// secondly, we delete using the content type guid
							// order is important due to the constraints set in the schema
							$tables = array(
								'liberty_content',
								'liberty_content_types'
							);
							foreach( $tables as $table ) {
								$delete = "
									DELETE FROM `".$tablePrefix.$table."`
									WHERE `content_type_guid`=?";
								$ret = $gBitInstaller->mDb->query( $delete, array( $contentType['content_type_guid'] ));
								if (!$ret) {
									$errors[] = "Error deleting content type";
									$failedcommands[] = $delete." ".$contentType['content_type_guid'];
								}
							}
						}
					}
				}

				// set installed packages active
				if( $method == 'install' || $method == 'reinstall' ) {
					// apparently we need to first remove the vaue from the database to make sure it's set
					$gBitSystem->storeConfig( 'package_'.$package , NULL );
					$gBitSystem->storeConfig( 'package_'.$package , 'y', $package );

					// we can assume that the latest upgrade version available for a package is the most current version number for that package
					if( $version = $gBitInstaller->getLatestUpgradeVersion( $package )) {
						$gBitSystem->storeVersion( $package, $version );
					} elseif( !empty( $gBitInstaller->mPackages[$package]['version'] )) {
						$gBitSystem->storeVersion( $package, $gBitInstaller->mPackages[$package]['version'] );
					}

					$gBitInstaller->mPackages[ $package ]['installed'] = TRUE;
					$gBitInstaller->mPackages[ $package ]['active_switch'] = TRUE;
					// we'll default wiki to the home page
					if( defined( 'WIKI_PKG_NAME' ) && $package == WIKI_PKG_NAME && !$gBitSystem->isFeatureActive( 'bit_index' )) {
						$gBitSystem->storeConfig( "bit_index", WIKI_PKG_NAME, WIKI_PKG_NAME );
					}
				}
			}
		}

		// Tonnes of stuff has changed. Force a reload of all our preferences
		$gBitInstaller->mPrefs = '';
		$gBitInstaller->loadConfig();



		// ---------------------- 5. ----------------------
		// run the defaults through afterwards so we can be sure all tables needed have been created
		foreach( array_keys( $gBitInstaller->mPackages ) as $package ) {
			if( !empty( $package )) {
				if( in_array( $package, $_REQUEST['packages'] ) || ( empty( $gBitInstaller->mPackages[$package]['installed'] ) && !empty( $gBitInstaller->mPackages[$package]['required'] ) ) ) {
					if( $method == 'install' || ( $method == 'reinstall' && in_array( 'settings', $removeActions ))) {
						// this list of installed packages is used to show newly installed packages
						if( !empty( $gBitInstaller->mPackages[$package]['defaults'] ) ) {
							foreach( $gBitInstaller->mPackages[$package]['defaults'] as $def ) {
								if( $gBitInstaller->mDb->mType == 'firebird' ) {
									$def = preg_replace( "/\\\'/", "''", $def );
								}
								$ret = $gBitInstaller->mDb->query( $def );
								if (!$ret) {
									$errors[] = "Error setting defaults";
									$failedcommands[] = $def;
								}
							}
						}
					}
					// this is to list any processed packages
					$packageList[$method][] = $package;
				}
			}
		}



		// ---------------------- 6. ----------------------
		// register all content types for installed packages
		foreach( $gBitInstaller->mContentClasses as $package => $classes ){
			if ( $gBitInstaller->isPackageInstalled( $package ) ){
				foreach ( $classes as $objectClass=>$classFile ){
					require_once( $classFile );
					$tempObject = new $objectClass();
				}
			}
		}


		// ---------------------- 7. ----------------------
		// Do stuff that only applies during the first install
		if( isset( $_SESSION['first_install'] ) && $_SESSION['first_install'] == TRUE ) {
			// set the version of bitweaver in the database
			$gBitSystem->storeVersion( NULL, $gBitSystem->getBitVersion() );

			// Some packages have some special things to take care of here.
			foreach( $gBitInstaller->mInstallModules as $mod ) {
				$gBitThemes->storeModule( $mod );
			}

			// Set the default format to get quicktags and content storing working
			$plugin_file = LIBERTY_PKG_PATH.'plugins/format.tikiwiki.php';
			if( is_readable( $plugin_file ) ) {
				require_once( $plugin_file );
				// manually set the config settings to avoid problems
				$gBitSystem->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."kernel_config` ( `config_name`, `package`, `config_value` ) VALUES ( 'liberty_plugin_file_".PLUGIN_GUID_TIKIWIKI."', '$plugin_file', '".LIBERTY_PKG_NAME."' )" );
				$gBitSystem->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."kernel_config` ( `config_name`, `package`, `config_value` ) VALUES ( 'liberty_plugin_status_".PLUGIN_GUID_TIKIWIKI."', 'y', '".LIBERTY_PKG_NAME."' )" );
				// it appear default_format is already set.
				$gBitSystem->storeConfig( 'default_format', PLUGIN_GUID_TIKIWIKI, LIBERTY_PKG_NAME );
			}

			// Installing users has some special things to take care of here and needs a separate check.
			if( in_array( 'users', $_REQUEST['packages'] ) ) {
				// Creating 'root' user has id=1. phpBB starts with user_id=2, so this is a hack to keep things in sync
				$rootUser = new BitPermUser();
				$storeHash = array(
					'real_name' => 'Root',
					'login'     => 'root',
					'password'  => $_SESSION['password'],
					'email'     => 'root@localhost',
					'pass_due'  => FALSE,
					'user_id'   => ROOT_USER_ID
				);
				if( $rootUser->store( $storeHash ) ) {
					$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`) VALUES ( ".ROOT_USER_ID.", 1, 'Administrators','Site operators')" );
					$rootUser->addUserToGroup( ROOT_USER_ID, 1 );
				} else {
					vd( 'Errors in root user store:'.PHP_EOL );
					vd( $rootUser->mErrors );
				}

				// now let's set up some default data. Group_id's are hardcoded in users/schema_inc defaults
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`) VALUES ( ".ROOT_USER_ID.", ".ANONYMOUS_GROUP_ID.", 'Anonymous','Public users not logged')" );
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`) VALUES ( ".ROOT_USER_ID.", 2, 'Editors','Site  Editors')" );
				$gBitUser->mDb->query( "INSERT INTO `".BIT_DB_PREFIX."users_groups` (`user_id`, `group_id`, `group_name`,`group_desc`,`is_default`) VALUES ( ".ROOT_USER_ID.", 3, 'Registered', 'Users logged into the system', 'y')" );

				$gBitUser->assignLevelPermissions( ANONYMOUS_GROUP_ID, 'basic' );
				$gBitUser->assignLevelPermissions( 3, 'registered' );
				$gBitUser->assignLevelPermissions( 2, 'editors' );
				$gBitUser->assignLevelPermissions( 1, 'admin' );

				// Create 'Anonymous' user has id= -1 just like phpBB
				$anonUser = new BitPermUser();
				$storeHash = array(
					'real_name'        => 'Guest',
					'login'            => 'guest',
					'password'         => $_SESSION['password'],
					'email'            => 'guest@localhost',
					'pass_due'         => FALSE,
					'user_id'          => ANONYMOUS_USER_ID,
					'default_group_id' => ANONYMOUS_GROUP_ID
				);
				if( $anonUser->store( $storeHash ) ) {
					// Remove anonymous from registered group
					$regGroupId = $anonUser->groupExists( 'Registered', ROOT_USER_ID );
					$anonUser->removeUserFromGroup( ANONYMOUS_USER_ID, $regGroupId );
					$anonUser->addUserToGroup( ANONYMOUS_USER_ID, ANONYMOUS_GROUP_ID);
				}

				$adminUser = new BitPermUser();
				$storeHash = array(
					'real_name' => $_SESSION['real_name'],
					'login'     => $_SESSION['login'],
					'password'  => $_SESSION['password'],
					'email'     => $_SESSION['email'],
					'pass_due'  => FALSE
				);
				if( $adminUser->store( $storeHash ) ) {
					// add user to admin group
					$adminUser->addUserToGroup( $adminUser->mUserId, 1 );
					// set admin group as default
					$adminUser->storeUserDefaultGroup( $adminUser->mUserId, 1 );
				}

				// kill admin info in $_SESSION
				unset( $_SESSION['real_name'] );
				unset( $_SESSION['login'] );
				unset( $_SESSION['password'] );
				unset( $_SESSION['email'] );
			}
		}



		// ---------------------- 8. ----------------------
		// woo! we're done with the installation bit - below here is some generic installer stuff
		$gBitSmarty->assign( 'next_step', $step + 1 );

		// display list of installed packages
		asort( $packageList );
		$gBitSmarty->assign( 'packageList', $packageList );

		// enter some log information to say we've initialised the system
		if( empty( $failedcommands ) ) {
			$logHash['action_log'] = array(
				'user_id' => ROOT_USER_ID,
				'title' => 'System Installation',
				'log_message' => 'Packages were successfully installed and bitweaver is ready for use.',
			);

			if( empty( $_SESSION['first_install'] ) ) {
				$list = '';
				foreach( $packageList as $pkg ) {
					$list .= implode( ", ", $pkg );
				}
				$logHash['action_log']['title'] = "Package {$method}";
				$logHash['action_log']['log_message'] = "The following package(s) were {$method}ed: $list";
			} else {
				$gBitSystem->setConfig( 'liberty_action_log', 'y' );
			}

			LibertyContent::storeActionLog( $logHash );
		} else {
			$gBitSmarty->assign( 'errors', $errors);
			$gBitSmarty->assign( 'failedcommands', $failedcommands);
		}

		// display the confirmation page
		$app = '_done';
	} else {
		// if we can't connect to the db, move back 2 steps
		header( "Location: ".$_SERVER['PHP_SELF']."?step=".$step - 2 );
	}
} elseif( !empty( $_REQUEST['submit_packages'] ) ) {
	// No packages to install so just move to the next step.
	$gBitSmarty->assign( 'next_step', $step + 1 );
	$app = '_done';
}
?>
