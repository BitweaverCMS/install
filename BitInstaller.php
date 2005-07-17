<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/BitInstaller.php,v 1.5 2005/07/17 17:36:04 squareing Exp $
 * @package install
 */

/**
 * @package install
 * @subpackage BitInstaller
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
		if( !empty( $pBrowserTitle ) ) {
			$this->setBrowserTitle( $pBrowserTitle );
		}
		global $smarty;
		$smarty->verifyCompileDir();
		$smarty->display( $pTemplate );
	}

	function isInstalled() {
		return ( !empty( $this->mPackages['kernel']['installed'] ) );
	}

	function getWebServerUid() {
		global $wwwuser;
		global $wwwgroup;
		$wwwuser = '';
		$wwwgroup = '';
	
		if (isWindows()) {
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
					$result = $this->query( "CREATE SCHEMA $schema" );
					$result = $this->query( "SET search_path TO $schema" );
				}
				break;
			case "firebird":
				$result = $this->mDb->mDb->Execute( "DECLARE EXTERNAL FUNCTION LOWER CSTRING(80) RETURNS CSTRING(80) FREE_IT ENTRY_POINT 'IB_UDF_lower' MODULE_NAME 'ib_udf'" );
				break;
		}
		return $ret;
	}
	
	function upgradePackage( $package ) {
		global $gBitSystem;
		if( !empty( $gBitSystem->mUpgrades[$package] ) ) {
			$tablePrefix = $this->getTablePrefix();
			$dict = NewDataDictionary( $this->mDb->mDb );
			for( $i=0; $i<count( $gBitSystem->mUpgrades[$package] ); $i++ ) {
	
if( !is_array( $gBitSystem->mUpgrades[$package][$i] ) ) {
	vd( "[$package][$i] is NOT array" );
	vd( $gBitSystem->mUpgrades[$package][$i] );
	bt();
	die;
}
				$type = key( $gBitSystem->mUpgrades[$package][$i] );
				$step = &$gBitSystem->mUpgrades[$package][$i][$type];
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
									if( $sql && ($dict->ExecuteSQLArray( $sql ) > 0 ) ) {
									} else {
										print '<dd><font color="red">Failed to create '.$completeTableName.'</font>';
										array_push( $failedcommands, $sql );
									}
								}
							}
							break;
						case 'ALTER':
							foreach( $dd as $alter ) {
								foreach( array_keys( $alter ) as $tableName ) {
									$completeTableName = $tablePrefix.$tableName;
									$sql = $dict->ChangeTableSQL( $completeTableName, $alter[$tableName] );
									if( $sql && ($dict->ExecuteSQLArray( $sql ) > 0 ) ) {
									} else {
										print '<dd><font color="red">Failed to alter '.$completeTableName.' -> '.$alter[$tableName].'</font>';
										array_push( $failedcommands, $sql );
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
											$this->query( $query );
										}
									} else {
										print '<dd><font color="red">Failed to rename table '.$completeTableName.'.'.$rename[$tableName][0].' to '.$rename[$tableName][1].'</font>';
										array_push( $failedcommands, $sql );
									}
								}
							}
							break;
						case 'RENAMECOLUMN':
							foreach( $dd as $rename ) {
								foreach( array_keys( $rename ) as $tableName ) {
									$completeTableName = $tablePrefix.$tableName;
									foreach( $rename[$tableName] as $from=>$flds ) {
										// MySQL needs the fields string, others do not.  
										// see http://phplens.com/lens/adodb/docs-datadict.htm
										$to = substr( $flds, 0, strpos( $flds, ' ') );
										if( $sql = @$dict->RenameColumnSQL( $completeTableName, $from, $to, $flds ) ) {
											foreach( $sql AS $query ) {
												$this->query( $query );
											}
										} else {
											print '<dd><font color="red">Failed to rename column '.$completeTableName.'.'.$rename[$tableName][0].' to '.$rename[$tableName][1].'</font>';
											array_push( $failedcommands, $sql );
										}
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
												$this->query( $query );
											}
										} else {
											print '<dd><font color="red">Failed to drop column '.$completeTableName.'</font>';
											array_push( $failedcommands, $sql );
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
										print '<dd><font color="red">Failed to drop table '.$completeTableName.'</font>';
										array_push( $failedcommands, $sql );
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
											$this->query( $query );
										}
									} else {
										print '<dd><font color="red">Failed to create index '.$index.'</font>';
										array_push( $failedcommands, $sql );
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
								$this->query( $query );
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
				$gBitSystem->storePreference( 'package_'.$package, 'y', $package );
			}
		}
	}

}

function process_sql_file( $file, $gBitDbType, $pBitDbPrefix ) {
	global $gBitDb;

	global $succcommands;
	global $failedcommands;
	global $smarty;
	if(!isset($succcommands)) {
	  $succcommands=array();
	  $failedcommands=array();
	}

	if( !file_exists( INSTALL_PKG_PATH.'db/'.$file ) ) {
		$failedcommands[] = "Could not open ".INSTALL_PKG_PATH.'db/'.$file;
		return;
	}
	$command = '';
	$fp = fopen( INSTALL_PKG_PATH."db/$file", "r");

	while(!feof($fp)) {
		$command.= fread($fp,4096);
	}

	switch ($gBitDbType) {
	  case "sybase":
	    $splitString = "(\r|\n)go(\r|\n)";
	    break;
	  case "oci8":
	    $splitString = "#(;\n)|(\n/\n)#";
	    break;
	  case "postgres":
	  	// Do a little prep work for postgres, no break, cause we want default case too
	  	if( preg_match( '/\./', $pBitDbPrefix ) ) {
			$schema = preg_replace( '/[`\.]/', '', $pBitDbPrefix );
			// Assume we want to dump in a schema, so set the search path and nuke the prefix here.
			$result = $gBitDb->Execute( "CREATE SCHEMA $schema" );
			$result = $gBitDb->Execute( "SET search_path TO $schema" );
			$pBitDbPrefix='';
		}
	  default:
	  	$splitString = "#(;\n)|(;\r\n)#";
	    break;
	}
	$command = str_replace( "##PREFIX##", $pBitDbPrefix, $command );
	$statements = preg_split( "#(;\n)|(;\r\n)#", $command );

	$prestmt="";
	$do_exec=true;
	$succcommands[]= "Prefix: <".$pBitDbPrefix.">";
	foreach ($statements as $statement) {
		//echo "executing $statement ";
			if (trim($statement)) {
				switch ($gBitDbType) {
				case "oci8":
					$statement = preg_replace("/`/", "\"", $statement);
					// we have to preserve the ";" in sqlplus programs (triggers)
					if (preg_match("/BEGIN/",$statement)) {
						$prestmt=$statement.";";
						$do_exec=false;
					}
					if (preg_match("/END/",$statement)) {
						$statement=$prestmt."\n".$statement.";";
						$do_exec=true;
					}
					if($do_exec) $result = $gBitDb->Execute($statement);
					break;
				case "sqlite":
					$statement = preg_replace("/`/", "", $statement);
				case "postgres":
				case "sybase":
				case "mssql":
					$statement = preg_replace("/`/", "\"", $statement);
				default:
					$result = $gBitDb->Execute($statement);
					break;
			}

			if (!$result) {
				if( !preg_match( '/DROP TABLE/i', $statement ) ) {
					$failedcommands[]= "Command: ".trim($statement)."\nMessage: ".$gBitDb->ErrorMsg()."\n";
				//trigger_error("DB error:  " . $gBitDb->ErrorMsg(). " in query:<pre>" . $command . "<\/pre>", E_USER_WARNING);
				// Do not die at the moment. We need some better error checking here
				//die;
				}
			} else {
				$succcommands[]=$statement;
			}
		}
	}

	$smarty->assign_by_ref('succcommands', $succcommands);
	$smarty->assign_by_ref('failedcommands', $failedcommands);

	return( empty( $failedcommands ) );
}

function kill_script() {
	$installFile = 'install.php';
	if( rename( $installFile, 'install.done.php' ) ) {
		header ('location: install.done.php');
	} else {
		return 'no_kill';
	}
}

function check_session_save_path() {
	global $errors;
	if (ini_get('session.save_handler') == 'files') {
        	$save_path = ini_get('session.save_path');

        	if (!is_dir($save_path)) {
                	$errors .= "The directory '$save_path' does not exist or PHP is not allowed to access it (check session.save_path or open_basedir entries in php.ini).\n";
        	} else if (!is_writeable($save_path)) {
                	$errors .= "The directory '$save_path' is not writeable.\n";
        	}

        	if ($errors) {
                	$save_path = BitSystem::tempdir();

                	if (is_dir($save_path) && is_writeable($save_path)) {
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
	$gDb->SetFetchMode(ADODB_FETCH_ASSOC);
	return $gDb;
}

function getTables($gDb, $skip_tables) {
	$tables = array();
	$result = $gDb->Execute( $gDb->metaTablesSQL );
	while ($res = $result->FetchRow()) {
		//print_r($res);
		$column_name = array_keys($res);
		//echo $column_name."\n";
		$table = $res[$column_name[0]];

		// used to skip/drop dbs of a certain prefix
		//if (!strncmp('tst_', $table, 4)) {
		//	$gDb->Execute("DROP TABLE $table");
		//	continue;
		//}

		// migrate only one table
		//if (strcmp('bit_link_cache', $table)) continue;

		// ignore tables
		if (array_search($table, $skip_tables) !== FALSE) continue;
		//echo $table."\n";
		$tables[] = $table;
	}
	return $tables;
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

// insert data into destination
function insertData($res, $table, $gDb, $stop_on_errors) {
	$query = "INSERT INTO $table (\"";
	$query .= join("\", \"", array_keys($res));
	$query .= "\") VALUES (?";
	for($i = 1; $i < count($res); $i++)
		$query .= ",?";
	$query .= ")";
	//echo $query."\n";
	if(!$gDb->Execute($query, $res)) {
		echo $query."\n";
		echo $gDb->ErrorMsg()."\n";
		if ($stop_on_errors) die;
	}
}

// enumerate blob fields and encoded
function convertBlobs($db_type, &$res, $blobs) {
	foreach($blobs as $blob) {
		$res[$blob] = db_byte_encode($db_type, $res[$blob]);
	}
}

?>
