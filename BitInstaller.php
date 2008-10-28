<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/BitInstaller.php,v 1.41 2008/10/28 21:13:54 squareing Exp $
 * @package install
 */

/**
 * @package install
 */
class BitInstaller extends BitSystem {

	var $mPackageUpgrades = array();

	/**
	 * Initiolize BitInstaller 
	 * @access public
	 */
	function BitInstaller() {
		BitSystem::BitSystem();
		$this->getWebServerUid();
	}

	/**
	 * loadUpgradeFiles This will load all files in the dir <pckage>/admin/upgrades/<version>.php with a version greater than the one installed
	 * 
	 * @param array $pPackage 
	 * @access public
	 * @return void
	 */
	function loadUpgradeFiles( $pPackage ) {
		if( !empty( $pPackage )) {
			$dir = constant( strtoupper( $pPackage )."_PKG_PATH" )."admin/upgrades/";
			if( $this->isPackageActive( $pPackage ) && is_dir( $dir ) && $upDir = opendir( $dir )) {
				while( FALSE !== ( $file = readdir( $upDir ))) {
					if( is_file( $dir.$file )) {
						$upVersion = str_replace( ".php", "", $file );
						// we only want to load files of versions that are greater than is installed
						if( $this->validateVersion( $upVersion ) && version_compare( $this->getVersion( $pPackage ), $upVersion, '<' )) {
							include_once( $dir.$file );
						}
					}
				}
			}
		}
	}

	/**
	 * registerPackageUpgrade 
	 * 
	 * @param array $pParams Hash of information about upgrade
	 * @param string $pParams[package] Name of package that is upgrading
	 * @param string $pParams[version] Version of this upgrade
	 * @param string $pParams[description] Description of what the upgrade does
	 * @param string $pParams[post_upgrade] Textual note of stuff that needs to be observed after the upgrade
	 * @param array $pUpgradeHash Hash of update rules. See existing upgrades on how this works.
	 * @access public
	 * @return void
	 */
	function registerPackageUpgrade( $pParams, $pUpgradeHash = array() ) {
		if( $this->verifyPackageUpgrade( $pParams )) {
			$this->registerPackageVersion( $pParams['package'], $pParams['version'] );
			$this->mPackageUpgrades[$pParams['package']][$pParams['version']]            = $pParams;
			$this->mPackageUpgrades[$pParams['package']][$pParams['version']]['upgrade'] = $pUpgradeHash;

			// sort everything for a nice display
			ksort( $this->mPackageUpgrades );
			uksort( $this->mPackageUpgrades[$pParams['package']], 'upgrade_version_sort' );
		}
	}

	/**
	 * verifyPackageUpgrade 
	 * 
	 * @param array $pParams Hash of information about upgrade
	 * @param string $pParams[package] Name of package that is upgrading
	 * @param string $pParams[version] Version of this upgrade
	 * @param string $pParams[description] Description of what the upgrade does
	 * @param string $pParams[post_upgrade] Textual note of stuff that needs to be observed after the upgrade
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function verifyPackageUpgrade( &$pParams ) {
		if( empty( $pParams['package'] )) {
			$this->mErrors['package'] = "Please provide a valid package name.";
		}

		if( empty( $pParams['version'] ) || !$this->validateVersion( $pParams['version'] )) {
			$this->mErrors['version'] = "Please provide a valid version number.";
		} elseif( empty( $this->mErrors ) && !empty( $this->mPackageUpgrades[$pParams['package']][$pParams['version']] )) {
			$this->mErrors['version'] = "Please make sure you use a unique version number to register your new database changes.";
		}

		if( empty( $pParams['description'] )) {
			$this->mErrors['description'] = "Please add a brief description of what this upgrade is all about.";
		}

		// since this should only show up when devs are working, we'll simply display the output:
		if( !empty( $this->mErrors )) {
			vd( $this->mErrors );
			bt();
		}

		return( count( $this->mErrors ) == 0 );
	}

	/**
	 * registerPackageDependencies 
	 * 
	 * @param array $pParams 
	 * @param array $pDepHash 
	 * @access public
	 * @return void
	 */
	function registerPackageDependencies( $pParams, $pDepHash ) {
		if( !empty( $pParams['package'] ) && !empty( $pParams['version'] ) && $this->validateVersion( $pParams['version'] ) && $this->verifyPackageDependencies( $pDepHash )) {
			$this->mPackageDependencies[$pParams['package']][$pParams['version']]['dependencies'] = $pDepHash;
		}
	}

	/**
	 * verifyPackageDependencies 
	 * 
	 * @param array $pDepHash 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function verifyPackageDependencies( &$pDepHash ) {
		if( !empty( $pDepHash ) && is_array( $pDepHash )) {
			foreach( $pDepHash as $pkg => $versions ) {
				if( empty( $versions['min'] )) {
					$this->mErrors['version_min'] = "You have to provide a minimum version number for the $pkg dependency. If you just want the required package to be present, please use 0.0.0 as minimum version.";
				} elseif( !$this->validateVersion( $versions['min'] )) {
					$this->mErrors['version_min'] = "Please make sure you use a valid minimum version number for the $pkg dependency.";
				} else {
					// maximum version number is not required
					if( !empty( $versions['max'] ) && !$this->validateVersion( $versions['max'] )) {
						$this->mErrors['version_max'] = "Please make sure you use a valid maximum version number for the $pkg dependency.";
					}
				}
			}
		} else {
			$this->mErrors['deps'] = "If you want to register dependencies, please do so with a valid dependency hash.";
		}

		// since this should only show up when devs are working, we'll simply display the output:
		if( !empty( $this->mErrors )) {
			vd( $this->mErrors );
			bt();
		}

		return( count( $this->mErrors ) == 0 );
	}

	/**
	 * getPackageDependencies 
	 * 
	 * @param array $pPackage 
	 * @access public
	 * @return array of package dependencies
	 */
	function getPackageDependencies( $pPackage ) {
		$ret = array();
		if( !empty( $pPackage )) {
			$version = $this->getLatestUpgradeVersion( $pPackage );
			if( !empty( $version ) && !empty( $this->mPackageDependencies[$pPackage][$version]['dependencies'] )) {
				return $this->mPackageDependencies[$pPackage][$version]['dependencies'];
			}
		}
		return $ret;
	}

	/**
	 * calculateDependencies will calculate all dependencies and return a hash of the results
	 * 
	 * @access public
	 * @return array of calculated dependencies
	 */
	function calculateDependencies() {
		$ret = array();
		// first we gather all version information.
		foreach( array_keys( $this->mPackages ) as $package ) {
			if( $this->isPackageActive( $package )) {

				// get the latest upgrade version, since this is the version the package will be at after install
				if( !$version = $this->getLatestUpgradeVersion( $package )) {
					$version = $this->getVersion( $package );
				}
				$installed[$package] = $version;

				if( $deps = $this->getPackageDependencies( $package )) {
					$dependencies[$package] = $deps;
				}
			}
		}

		if( !empty( $dependencies )) {
			foreach( $dependencies as $package => $deps ) {
				foreach( $deps as $depPackage => $depVersion ) {
					$hash = array(
						'package'   => $package,
						'requires'  => $depPackage,
						'version'   => $depVersion,
					);

					if( !empty( $installed[$depPackage] )) {
						$hash['version']['available'] = $installed[$depPackage];
					}

					if( empty( $installed[$depPackage] )) {
						$hash['result'] = 'missing';
					} elseif( version_compare( $depVersion['min'], $installed[$depPackage], '>' )) {
						$hash['result'] = 'min_dep';
					} elseif( !empty( $depVersion['max'] ) && version_compare( $depVersion['max'], $installed[$depPackage], '<' )) {
						$hash['result'] = 'max_dep';
					} else {
						$hash['result'] = 'ok';
					}

					$ret[] = $hash;
				}
			}
		}

		return $ret;
	}

	/**
	 * getLatestUpgradeVersion will fetch the greatest upgrade number for a given package
	 * 
	 * @param array $pPackage package we want to fetch the latest version number for
	 * @access public
	 * @return string greatest upgrade number for a given package
	 */
	function getLatestUpgradeVersion( $pPackage ) {
		$ret = '0.0.0';
		if( !empty( $pPackage )) {
			$dir = constant( strtoupper( $pPackage )."_PKG_PATH" )."admin/upgrades/";
			if( is_dir( $dir ) && $upDir = opendir( $dir )) {
				while( FALSE !== ( $file = readdir( $upDir ))) {
					if( is_file( $dir.$file )) {
						$upVersion = str_replace( ".php", "", $file );
						// we only want to update $ret if the version of the file is greater than the previous one
						if( $this->validateVersion( $upVersion ) && version_compare( $ret, $upVersion, "<" )) {
							$ret = $upVersion;
						}
					}
				}
			}
		}
		return(( $ret == '0.0.0' ) ? FALSE : $ret );
	}

	/**
	 * registerPackageVersion Holds the package version
	 *
	 * @param array $pPackage 
	 * @param array $pVersion 
	 * @access public
	 * @return void
	 */
	function registerPackageVersion( $pPackage, $pVersion ) {
		$pPackage = strtolower( $pPackage ); // lower case for uniformity
		$this->mPackages[$pPackage]['version'] = $pVersion;
	}

	/**
	 * registerUpgrade 
	 * 
	 * @param array $pPackage 
	 * @param array $pUpgradeHash 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function registerUpgrade( $pPackage, $pUpgradeHash ) {
		$pPackage = strtolower( $pPackage ); // lower case for uniformity
		if( !empty( $pUpgradeHash ) ) {
			$this->mUpgrades[$pPackage] = $pUpgradeHash;
		}
	}

	/**
	 * display 
	 * 
	 * @param string $pTemplate 
	 * @param string $pBrowserTitle 
	 * @access public
	 * @return void
	 */
	function display( $pTemplate, $pBrowserTitle=NULL ) {
		header( 'Content-Type: text/html; charset=utf-8' );
		if( ini_get( 'safe_mode' ) && ini_get( 'safe_mode_gid' )) {
			umask( 0007 );
		}
		// force the session to close *before* displaying. Why? Note this very important comment from http://us4.php.net/exec
		session_write_close();

		if( !empty( $pBrowserTitle ) ) {
			$this->setBrowserTitle( $pBrowserTitle );
		}
		global $gBitSmarty;
		$gBitSmarty->verifyCompileDir();
		$gBitSmarty->display( $pTemplate );
	}

	/**
	 * isInstalled 
	 * 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function isInstalled( $pPackage = 'kernel' ) {
		return( !empty( $this->mPackages[$pPackage]['installed'] ));
	}

	/**
	 * getWebServerUid set global wwwuser and wwwgroup
	 * 
	 * @access public
	 * @return void
	 */
	function getWebServerUid() {
		global $wwwuser, $wwwgroup;
		$wwwuser = $wwwgroup = '';

		if( is_windows() ) {
			$wwwuser = 'SYSTEM';
			$wwwgroup = 'SYSTEM';
		}

		if( function_exists( 'posix_getuid' )) {
			$user = @posix_getpwuid( @posix_getuid() );
			$group = @posix_getpwuid( @posix_getgid() );
			$wwwuser = $user ? $user['name'] : false;
			$wwwgroup = $group ? $group['name'] : false;
		}

		if( !$wwwuser ) {
			$wwwuser = 'nobody (or the user account the web server is running under)';
		}

		if( !$wwwgroup ) {
			$wwwgroup = 'nobody (or the group account the web server is running under)';
		}
	}

	/**
	 * getTablePrefix 
	 * 
	 * @access public
	 * @return database adjusted table prefix
	 */
	function getTablePrefix() {
		global $gBitDbType;
		$ret = BIT_DB_PREFIX;
		// avoid errors in ADONewConnection() (wrong database driver etc...)
		// strip out some schema stuff
		switch( $gBitDbType ) {
			case "sybase":
				// avoid database change messages
				ini_set('sybct.min_server_severity', '11');
				break;
			case "oci8":
			case "postgres":
				// Do a little prep work for postgres, no break, cause we want default case too
				$ret = preg_replace( '/`/', '"', BIT_DB_PREFIX );
				if( preg_match( '/\./', $ret ) ) {
					// Assume we want to dump in a schema, so set the search path and nuke the prefix here.
					$schema = substr( $ret, 0, strpos( $ret, '.' ));
					$quote = strpos( $schema, '"' );
					if( $quote !== 0 ) {
						$schema = '"'.$schema;
					}
					$result = $this->mDb->query( "CREATE SCHEMA $schema" );
					$result = $this->mDb->query( "SET search_path TO $schema" );
				}
				break;
		}
		return $ret;
	}

	/**
	 * upgradePackage 
	 * 
	 * @param array $pPackage 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function upgradePackage( $pPackage ) {
		if( !empty( $pPackage ) && !empty( $this->mUpgrades[$pPackage] )) {
			return( $this->applyUpgrade( $pPackage, $this->mUpgrades[$pPackage] ));
		}
	}

	/**
	 * upgradePackageVersion 
	 * 
	 * @param array $pPackage 
	 * @param array $pVersion 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function upgradePackageVersions( $pPackage ) {
		if( !empty( $pPackage ) && !empty( $this->mPackageUpgrades[$pPackage] )) {
			// make sure everything is in the right order
			uksort( $this->mPackageUpgrades[$pPackage], 'upgrade_version_sort' );

			foreach( $this->mPackageUpgrades[$pPackage] as $version => $package ) {
				$errors[$version] = $this->applyUpgrade( $pPackage, $this->mPackageUpgrades[$pPackage][$version]['upgrade'] );
				if( !empty( $errors[$version] )) {
					return $errors;
				} else {
					// if the upgrade ended without incidence, we store the package version
					// this way we store the version after every successful step to avoid duplicate upgrades
					$this->storeVersion( $pPackage, $version );
				}
			}
		}

		return NULL;
	}

	/**
	 * applyUpgrade 
	 * 
	 * @param array $pPackage 
	 * @param array $pUpgradeHash 
	 * @access public
	 * @return empty array on success, array with errors on failure
	 */
	function applyUpgrade( $pPackage, $pUpgradeHash ) {
		global $gBitDb;
		$ret = array();

		if( !empty( $pUpgradeHash ) && is_array( $pUpgradeHash )) {
			// set table prefixes and handle special case of sequence prefixes
			$schemaQuote = strrpos( BIT_DB_PREFIX, '`' );
			$sequencePrefix = ( $schemaQuote ? substr( BIT_DB_PREFIX,  $schemaQuote + 1 ) : BIT_DB_PREFIX );
			$tablePrefix = $this->getTablePrefix();
			$dict = NewDataDictionary( $gBitDb->mDb );
			$failedcommands = array();

			for( $i = 0; $i < count( $pUpgradeHash ); $i++ ) {
				if( !is_array( $pUpgradeHash[$i] ) ) {
					vd( "[$pPackage][$i] is NOT an array" );
					vd( $pUpgradeHash[$i] );
					bt();
					die;
				}

				$type = key( $pUpgradeHash[$i] );
				$step = &$pUpgradeHash[$i][$type];

				switch( $type ) {
					case 'DATADICT':
						for( $j = 0; $j < count( $step ); $j++ ) {
							$dd = &$step[$j];
							switch( key( $dd ) ) {
								case 'CREATE':
									foreach( $dd as $create ) {
										foreach( array_keys( $create ) as $tableName ) {
											$completeTableName = $tablePrefix.$tableName;
											$sql = $dict->CreateTableSQL( $completeTableName, $create[$tableName], 'REPLACE' );
											if( $sql && ( $dict->ExecuteSQLArray( $sql, FALSE ) > 0 ) ) {
											} else {
												$errors[] = 'Failed to create '.$completeTableName;
												$failedcommands[] = implode( " ", $sql );
											}
										}
									}
									break;
								case 'ALTER':
									foreach( $dd as $alter ) {
										foreach( array_keys( $alter ) as $tableName ) {
											$completeTableName = $tablePrefix.$tableName;
											foreach( $alter[$tableName] as $from => $flds ) {
												if( is_string( $flds )) {
													$sql = $dict->ChangeTableSQL( $completeTableName, $flds );
												} else {
													$sql = $dict->ChangeTableSQL( $completeTableName, array( $flds ));
												}

												if( $sql && $dict->ExecuteSQLArray( $sql, FALSE ) > 0 ) {
												} else {
													$errors[] = 'Failed to alter '.$completeTableName.' -> '.$alter[$tableName];
													$failedcommands[] = implode( " ", $sql );
												}
											}
										}
									}
									break;
								case 'RENAMETABLE':
									foreach( $dd as $rename ) {
										foreach( array_keys( $rename ) as $tableName ) {
											$completeTableName = $tablePrefix.$tableName;
											if( $sql = @$dict->RenameTableSQL( $completeTableName, $tablePrefix.$rename[$tableName] ) ) {
												foreach( $sql AS $query ) {
													$this->mDb->query( $query );
												}
											} else {
												$errors[] = 'Failed to rename table '.$completeTableName.'.'.$rename[$tableName][0].' to '.$rename[$tableName][1];
												$failedcommands[] = implode( " ", $sql );
											}
										}
									}
									break;
								case 'RENAMECOLUMN':
									foreach( $dd as $rename ) {
										foreach( array_keys( $rename ) as $tableName ) {
											$completeTableName = $tablePrefix.$tableName;
											foreach( $rename[$tableName] as $from => $flds ) {
												// MySQL needs the fields string, others do not.
												// see http://phplens.com/lens/adodb/docs-datadict.htm
												$to = substr( $flds, 0, strpos( $flds, ' ') );
												if( $sql = @$dict->RenameColumnSQL( $completeTableName, $from, $to, $flds ) ) {
													foreach( $sql AS $query ) {
														$this->mDb->query( $query );
													}
												} else {
													$errors[] = 'Failed to rename column '.$completeTableName.'.'.$rename[$tableName][0].' to '.$rename[$tableName][1];
													$failedcommands[] = implode( " ", $sql );
												}
											}
										}
									}
									break;
								case 'CREATESEQUENCE':
									foreach( $dd as $create ) {
										foreach( $create as $sequence ) {
											$this->mDb->CreateSequence( $sequencePrefix.$sequence );
										}
									}
									break;
								case 'RENAMESEQUENCE':
									foreach( $dd as $rename ) {
										foreach( $rename as $from => $to ) {
											if( $this->mDb->tableExists( $tablePrefix.$from ) ) {
												if( $id = $this->mDb->GenID( $from ) ) {
													$this->mDb->DropSequence( $sequencePrefix.$from );
													$this->mDb->CreateSequence( $sequencePrefix.$to, $id );
												} else {
													$errors[] = 'Failed to rename sequence '.$sequencePrefix.$from.' to '.$sequencePrefix.$to;
													$failedcommands[] = implode( " ", $sql );
												}
											} else {
												$this->mDb->CreateSequence( $sequencePrefix.$to, $pUpgradeHash['sequences'][$to]['start'] );
											}
										}
									}
									break;
								case 'DROPCOLUMN':
									foreach( $dd as $drop ) {
										foreach( array_keys( $drop ) as $tableName ) {
											$completeTableName = $tablePrefix.$tableName;
											foreach( $drop[$tableName] as $col ) {
												if( $sql = $dict->DropColumnSQL( $completeTableName, $col ) ) {
													foreach( $sql AS $query ) {
														$this->mDb->query( $query );
													}
												} else {
													$errors[] = 'Failed to drop column '.$completeTableName;
													$failedcommands[] = implode( " ", $sql );
												}
											}
										}
									}
									break;
								case 'DROPTABLE':
									foreach( $dd as $drop ) {
										foreach( $drop as $tableName ) {
											$completeTableName = $tablePrefix.$tableName;
											$sql = $dict->DropTableSQL( $completeTableName );
											if( $sql && $dict->ExecuteSQLArray( $sql ) > 0 ) {
											} else {
												$errors[] = 'Failed to drop table '.$completeTableName;
												$failedcommands[] = implode( " ", $sql );
											}
										}
									}
									break;
								case 'CREATEINDEX':
									foreach( $dd as $indices ) {
										foreach( array_keys( $indices ) as $index ) {
											$completeTableName = $tablePrefix.$indices[$index][0];
											if( $sql = $dict->CreateIndexSQL( $index, $completeTableName, $indices[$index][1], $indices[$index][2] ) ) {
												foreach( $sql AS $query ) {
													$this->mDb->query( $query );
												}
											} else {
												$errors[] = 'Failed to create index '.$index;
												$failedcommands[] = implode( " ", $sql );
											}
										}
									}
									break;
							}
						}
						break;
					case 'QUERY':
						global $gBitDbType;
						foreach( array_keys( $step ) as $dbType ) {
							switch( $dbType ) {
								case 'MYSQL' :
									if( preg_match( '/mysql/', $gBitDbType ) ) {
										$sql = $step[$dbType];
									}
									break;
								case 'PGSQL' :
									if( preg_match( '/postgres/', $gBitDbType ) ) {
										$sql = $step[$dbType];
									}
									break;
								case 'SQL92' :
									$sql = $step[$dbType];
									break;
							}
							if( !empty( $sql ) ) {
								foreach( $sql as $query ) {
									if( !$result = $this->mDb->query( $query )) {
										$errors[] = 'Failed to execute SQL query';
										$failedcommands[] = implode( " ", $sql );
									}
								}
								$sql = NULL;
							}
						}
						break;
					case 'PHP':
						eval( $step );
						break;
					case 'POST':
						$postSql[] = $step;
						break;
				}
			}

			// turn on features that are turned on
			// legacy stuff
			if( $this->isFeatureActive( 'feature_'.$pPackage )) {
				$this->storeConfig( 'package_'.$pPackage, 'y', KERNEL_PKG_NAME );
			}

			if( !empty( $failedcommands )) {
				$ret['errors'] = $errors;
				$ret['failedcommands'] = $failedcommands;
			}
		}

		return $ret;
	}

	/**
	 * identifyBlobs 
	 * 
	 * @param array $result 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function identifyBlobs( $result ) {
		$blobs = array();
		//echo "FieldCount: ".$result->FieldCount()."\n";
		for( $i = 0; $i < $result->FieldCount(); $i++ ) {
			$field = $result->FetchField($i);
			//echo $i."-".$field->name."-".$result->MetaType($field->type)."-".$field->max_length."\n";
			// check for blobs
			if(( $result->MetaType( $field->type ) == 'B' ) || ( $result->MetaType( $field->type )=='X' && $field->max_length >= 16777215 ))
				$blobs[] = $field->name;
		}
		return $blobs;
	}

	/**
	 * convertBlobs enumerate blob fields and encoded
	 * 
	 * @param string $gDb 
	 * @param array $res 
	 * @param array $blobs 
	 * @access public
	 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
	 */
	function convertBlobs( $gDb, &$res, $blobs ) {
		foreach( $blobs as $blob ) {
			$res[$blob] = $gDb->dbByteEncode( $res[$blob] );
		}
	}

	/**
	 * hasAdminBlock 
	 * 
	 * @access public
	 * @return TRUE on success, FALSE on failure
	 * @deprecated i think this isn't used any more
	 */
	function hasAdminBlock() {
		deprecated( "i think this isn't used anymore." );
		global $gBitUser;
		// Let's find out if we are have admin perm or a root user
		$ret = TRUE;
		if( empty( $gBitUser ) || $gBitUser->isAdmin() ) {
			$ret = FALSE;
		} else {
			// let's try to load up user_id - if successful, we know we have one.
			$rootUser = new BitPermUser( 1 );
			$rootUser->load();
			if( !$rootUser->isValid() ) {
				$ret = FALSE;
			}
		}
		return $ret;
	}
}

/**
 * check_session_save_path 
 * 
 * @access public
 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
 */
function check_session_save_path() {
	global $errors;
	if( ini_get( 'session.save_handler' ) == 'files' ) {
		$save_path = ini_get( 'session.save_path' );

		if( !is_dir( $save_path )) {
			$errors .= "The directory '$save_path' does not exist or PHP is not allowed to access it (check session.save_path or open_basedir entries in php.ini).\n";
		} elseif( !bw_is_writeable( $save_path )) {
			$errors .= "The directory '$save_path' is not writeable.\n";
		}

		if( $errors ) {
			$save_path = BitSystem::tempdir();

			if (is_dir($save_path) && bw_is_writeable($save_path)) {
				ini_set('session.save_path', $save_path);

				$errors = '';
			}
		}
	}
}

/**
 * makeConnection 
 * 
 * @param string $gBitDbType 
 * @param string $gBitDbHost 
 * @param string $gBitDbUser 
 * @param string $gBitDbPassword 
 * @param string $gBitDbName 
 * @access public
 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
 */
function makeConnection( $gBitDbType, $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName ) {
	$gDb = &ADONewConnection( $gBitDbType );
	if( !$gDb->Connect( $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName )) {
		echo $gDb->ErrorMsg()."\n";
		die;
	}
	global $gBitDbCaseSensitivity;
	$gDb->mCaseSensitive = $gBitDbCaseSensitivity;
	$gDb->SetFetchMode( ADODB_FETCH_ASSOC );
	return $gDb;
}

/**
 * upgrade_package_sort 
 * 
 * @param array $a 
 * @param array $b 
 * @access public
 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
 */
function upgrade_package_sort( $a, $b ) {
	global $gBitInstaller;
	$aa = $gBitInstaller->mPackages[$a];
	$bb = $gBitInstaller->mPackages[$b];
	if(( $aa['required'] && $bb['required'] ) || ( !$aa['required'] && !$bb['required'] )) {
		return 0;
	} elseif( $aa['required'] && !$bb['required'] ) {
		return -1;
	} elseif( !$aa['required'] && $bb['required'] ) {
		return 1;
	}
}

/**
 * upgrade_version_sort 
 * 
 * @param array $a 
 * @param array $b 
 * @access public
 * @return TRUE on success, FALSE on failure - mErrors will contain reason for failure
 */
function upgrade_version_sort( $a, $b ) {
	return version_compare( $a, $b, '>' );
}

?>
