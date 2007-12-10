<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/BitInstaller.php,v 1.30 2007/12/10 19:26:30 joasch Exp $
 * @package install
 */

/**
 * @package install
 */
class BitInstaller extends BitSystem {

	function BitInstaller() {
		BitSystem::BitSystem();
		$this->getWebServerUid();
	}

	function hasAdminBlock() {
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

	function display($pTemplate, $pBrowserTitle=NULL)
	{
		header( 'Content-Type: text/html; charset=utf-8' );
		// force the session to close *before* displaying. Why? Note this very important comment from http://us4.php.net/exec
		if (ini_get('safe_mode') && ini_get('safe_mode_gid')) {
			umask(0007);
		}
		session_write_close();

		if( !empty( $pBrowserTitle ) ) {
			$this->setBrowserTitle( $pBrowserTitle );
		}
		global $gBitSmarty;
		$gBitSmarty->verifyCompileDir();
		$gBitSmarty->display( $pTemplate );
	}

	function isInstalled() {
		return ( !empty( $this->mPackages['kernel']['installed'] ) );
	}

	function getWebServerUid() {
		global $wwwuser;
		global $wwwgroup;
		$wwwuser = '';
		$wwwgroup = '';

		if (is_windows()) {
				$wwwuser = 'SYSTEM';

				$wwwgroup = 'SYSTEM';
		}

		if (function_exists('posix_getuid')) {
				$user = @posix_getpwuid(@posix_getuid());

				$group = @posix_getpwuid(@posix_getgid());
				$wwwuser = $user ? $user['name'] : false;
				$wwwgroup = $group ? $group['name'] : false;
		}

		if (!$wwwuser) {
				$wwwuser = 'nobody (or the user account the web server is running under)';
		}

		if (!$wwwgroup) {
				$wwwgroup = 'nobody (or the group account the web server is running under)';
		}
	}

	function getTablePrefix() {
		global $gBitDbType;
		$ret = BIT_DB_PREFIX;
		// avoid errors in ADONewConnection() (wrong database driver etc...)
		// strip out some schema stuff
		switch ($gBitDbType) {
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

	function upgradePackage( $package ) {
		global $gBitSystem, $gBitDb;
		$ret = array();

		if( !empty( $gBitSystem->mUpgrades[$package] )) {
			// set table prefixes and handle special case of sequence prefixes
			$schemaQuote = strrpos( BIT_DB_PREFIX, '`' );
			$sequencePrefix = ( $schemaQuote ? substr( BIT_DB_PREFIX,  $schemaQuote + 1 ) : BIT_DB_PREFIX );
			$tablePrefix = $this->getTablePrefix();
			$dict = NewDataDictionary( $gBitDb->mDb );
			for( $i=0; $i<count( $gBitSystem->mUpgrades[$package] ); $i++ ) {

				if( !is_array( $gBitSystem->mUpgrades[$package][$i] ) ) {
					vd( "[$package][$i] is NOT array" );
					vd( $gBitSystem->mUpgrades[$package][$i] );
					bt();
					die;
				}

				$type = key( $gBitSystem->mUpgrades[$package][$i] );
				$step = &$gBitSystem->mUpgrades[$package][$i][$type];
				$failedcommands = array();

				switch( $type ) {
					case 'DATADICT':
						for( $j=0; $j<count($step); $j++ ) {
							$dd = &$step[$j];
							switch( key( $dd ) ) {
							case 'CREATE':
								foreach( $dd as $create ) {
									foreach( array_keys( $create ) as $tableName ) {
										$completeTableName = $tablePrefix.$tableName;
										$sql = $dict->CreateTableSQL( $completeTableName, $create[$tableName], 'REPLACE' );
										if( $sql && ( $dict->ExecuteSQLArray( $sql ) > 0 ) ) {
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
											if (is_string($flds)) {
												$sql = $dict->ChangeTableSQL( $completeTableName, $flds );
											} else {
												$sql = $dict->ChangeTableSQL( $completeTableName, array($flds) );
											}
											if( $sql && ($dict->ExecuteSQLArray( $sql ) > 0 ) ) {
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
											$this->mDb->CreateSequence( $sequencePrefix.$to, $this->mPackages[$package]['sequences'][$to]['start'] );
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
										if( $sql && ($dict->ExecuteSQLArray( $sql ) > 0 ) ) {
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
			if( $gBitSystem->isFeatureActive( 'feature_'.$package ) ) {
				$gBitSystem->storeConfig( 'package_'.$package, 'y', KERNEL_PKG_NAME );
			}

			if( !empty( $failedcommands )) {
				$ret['errors'] = $errors;
				$ret['failedcommands'] = $failedcommands;
			}
		}

		return $ret;
	}
}

function check_session_save_path() {
	global $errors;
	if (ini_get('session.save_handler') == 'files') {
		$save_path = ini_get('session.save_path');

		if (!is_dir($save_path)) {
			$errors .= "The directory '$save_path' does not exist or PHP is not allowed to access it (check session.save_path or open_basedir entries in php.ini).\n";
		} else if (!bw_is_writeable($save_path)) {
			$errors .= "The directory '$save_path' is not writeable.\n";
		}

		if ($errors) {
			$save_path = BitSystem::tempdir();

			if (is_dir($save_path) && bw_is_writeable($save_path)) {
				ini_set('session.save_path', $save_path);

				$errors = '';
			}
		}
	}
}

function makeConnection($gBitDbType, $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName) {
	$gDb = &ADONewConnection( $gBitDbType );
	if( !$gDb->Connect($gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName) ) {
		echo $gDb->ErrorMsg()."\n";
		die;
	}
	global $gBitDbCaseSensitivity;
	$gDb->mCaseSensitive = $gBitDbCaseSensitivity;
	$gDb->SetFetchMode(ADODB_FETCH_ASSOC);
	return $gDb;
}

function identifyBlobs($result) {
	$blobs = array();
	//echo "FieldCount: ".$result->FieldCount()."\n";
	for($i = 0; $i < $result->FieldCount(); $i++) {
		$field = $result->FetchField($i);
		//echo $i."-".$field->name."-".$result->MetaType($field->type)."-".$field->max_length."\n";
		// check for blobs
		if(($result->MetaType($field->type)=='B') || ($result->MetaType($field->type)=='X' && $field->max_length >= 16777215))
			$blobs[] = $field->name;
	}
	return $blobs;
}

// enumerate blob fields and encoded
function convertBlobs($gDb, &$res, $blobs) {
	foreach($blobs as $blob) {
		$res[$blob] = $gDb->dbByteEncode($res[$blob]);
	}
}

?>
