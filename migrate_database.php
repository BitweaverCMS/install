<?php
/**
* $Header: /cvsroot/bitweaver/_bit_install/migrate_database.php,v 1.1.2.1 2005/09/26 09:42:09 wolff_borg Exp $
*
* Copyright (c) 2004 Stephan Borg, tikipro.org
* All Rights Reserved. See copyright.txt for details and a complete list of authors.

* Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details
*
* $Id: migrate_database.php,v 1.1.2.1 2005/09/26 09:42:09 wolff_borg Exp $
*/
$gBitSmarty->assign( 'next_step', $step );
require_once( 'install_inc.php' );

// set the maximum execution time to very high
ini_set( "max_execution_time", "86400" );

// check what db servers are available and display them accordingly - only seems to work with *nix
$dbtodsn = array();
if( function_exists( 'mysql_connect' ) ) {
	// check version of mysql server - only server that allows check without actually connecting to it... (who knows how that works)
	if( @mysql_get_server_info() ) {
		$dbtodsn['mysql'] = 'MySQL '.mysql_get_server_info();
	} else {
		$dbtodsn['mysql'] = 'MySQL 3.x';
	}
}
if( function_exists( 'mysqli_connect' ) ) {
	$dbtodsn['mysql'] = 'MySQLi 4.x';
}
if( function_exists( 'pg_connect' ) ) {
	$dbtodsn['postgres'] = 'PostgreSQL 7.x';
}
if( function_exists( 'ocilogon' ) ) {
	$dbtodsn['oci8'] = 'Oracle 8.i';
}
if( function_exists( 'sybase_connect' ) ) {
	$dbtodsn['sybase'] = 'Sybase';
}
if( function_exists( 'mssql_connect' ) ) {
	$dbtodsn['mssql'] = 'MS-SQL 8.0+';
}
if( function_exists( 'ibase_connect' ) ) {
	$dbtodsn['firebird'] = 'Firebird 1.5+';
	if ( empty($fbpath) ) {
		if ( isWindows() )
			$fbpath = 'c:\Program Files\Firebird\Firebird_1_5\bin\isql';
		else
			$fbpath = '/opt/firebird/bin/isql';
	}
	$gBitSmarty->assign( 'fbpath', $fbpath );
	if ( empty($gBitDbName) ) $gBitDbName = 'bitweaver';
}
if( function_exists( 'sqlite_open' ) ) {
	$dbtodsn['sqlite'] = 'SQLLite';
}
$gBitSmarty->assign_by_ref('dbservers', $dbtodsn);

$gBitSmarty->assign( 'db_dst', $gBitDbType );
$gBitSmarty->assign( 'host_dst', $gBitDbHost );
$gBitSmarty->assign( 'user_dst', $gBitDbUser );
$gBitSmarty->assign( 'pass_dst', $gBitDbPassword );
$gBitSmarty->assign( 'name_dst', $gBitDbName );
$gBitSmarty->assign( 'prefix_dst', BIT_DB_PREFIX );
$gBitSmarty->assign( 'root_url_bit', $root_url_bit );
if( defined( 'AUTO_BUG_SUBMIT' ) ) {
	$gBitSmarty->assign( 'auto_bug_submit', AUTO_BUG_SUBMIT );
}

$gBitSmarty->assign( 'gBitDbPassword_input', $gBitDbPassword );
$gBitSmarty->assign( 'gBitDbPassword_print', preg_replace( '/./','&bull;',$gBitDbPassword ) );

if (isset($_REQUEST['db_src'])) {
	// source database settings
	$gBitSmarty->assign( 'db_src', $_REQUEST['db_src'] );
	$gBitSmarty->assign( 'host_src', $_REQUEST['host_src'] );
	$gBitSmarty->assign( 'user_src', $_REQUEST['user_src'] );
	$gBitSmarty->assign( 'pass_src', $_REQUEST['pass_src'] );
	$gBitSmarty->assign( 'name_src', $_REQUEST['name_src'] );
	$gBitSmarty->assign( 'prefix_src', $_REQUEST['prefix_src'] );

	// destination database settings
	$gBitSmarty->assign( 'db_dst', $_REQUEST['db_dst'] );
	$gBitSmarty->assign( 'host_dst', $_REQUEST['host_dst'] );
	$gBitSmarty->assign( 'user_dst', $_REQUEST['user_dst'] );
	$gBitSmarty->assign( 'pass_dst', $_REQUEST['pass_dst'] );
	$gBitSmarty->assign( 'name_dst', $_REQUEST['name_dst'] );
	$gBitSmarty->assign( 'prefix_dst', $_REQUEST['prefix_dst'] );

	$skip_tables = isset($_REQUEST['skip_tables']) ? $_REQUEST['skip_tables'] : array();
	$gBitSmarty->assign( 'skip_tables_select', $skip_tables );
	$empty_tables = isset($_REQUEST['empty_tables']);
	$gBitSmarty->assign( 'empty_tables', $empty_tables );
	$convert_blobs = isset($_REQUEST['convert_blobs']);
	$gBitSmarty->assign( 'convert_blobs', $convert_blobs );
	$stop_on_errors = isset($_REQUEST['stop_on_errors']);
	$gBitSmarty->assign( 'stop_on_errors', $stop_on_errors );
	$debug = isset($_REQUEST['debug']);
	$gBitSmarty->assign( 'debug', $debug );
} else {
	//defaults
	$gBitSmarty->assign( 'stop_on_errors', TRUE );
}

if (isset($_REQUEST['fSubmitDatabase']) || isset($_REQUEST['fUpdateTables'])) {
	global $gBitDbType, $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName;
	global $gDb_src, $prefix_src, $gDb_dst, $prefix_dst;
	// source database settings
	$gBitDbType = $_REQUEST['db_src'];
	$gBitDbHost = $_REQUEST['host_src'];
	$gBitDbUser = $_REQUEST['user_src'];
	$gBitDbPassword = $_REQUEST['pass_src'];
	$gBitDbName = $_REQUEST['name_src'];
	$prefix_src = $_REQUEST['prefix_src'];
	if (testDatabase()) {
		$gBitSmarty->assign( 'error_src', TRUE );
		return;
	} else {
		$gDb_src = new BitDb();
	}

	$tables_src = $gDb_src->MetaTables();

	if (isset($_REQUEST['fUpdateTables'])) {
		$gBitSmarty->assign_by_ref( 'skip_tables', $tables_src );
		return;
	}

	// destination database settings
	$gBitDbType = $_REQUEST['db_dst'];
	$gBitDbHost = $_REQUEST['host_dst'];
	$gBitDbUser = $_REQUEST['user_dst'];
	$gBitDbPassword = $_REQUEST['pass_dst'];
	$gBitDbName = $_REQUEST['name_dst'];
	$prefix_dst = $_REQUEST['prefix_dst'];
	if (testDatabase()) {
		$gBitSmarty->assign( 'error_dst', TRUE );
		return;
	} else {
		$gDb_dst = new BitDb();
	}

	require_once( 'create_config_inc.php' );
	create_config($_REQUEST['db_dst'], $_REQUEST['host_dst'], $_REQUEST['user_dst'], $_REQUEST['pass_dst'], $_REQUEST['name_dst'], $_REQUEST['prefix_dst'], $_REQUEST['baseurl'], isset( $_REQUEST['auto_bug_submit'] ) ? 'TRUE' : 'FALSE' );

	// init db connections
	//vd($gDb_src);
	//vd($gDb_dst);die;

	if($debug) {
		$gDb_dst->debug();
	}

	// list source tables list
	//$tables_src = array($tables_src[2]);
	//$tables_dst = getTables($gDb_dst);
	//print_r($tables_src);die;

	$table_schema = array();
	// iterate through source tables
	foreach($tables_src as $table) {
		if (array_search($table, $skip_tables) !== FALSE) {
			if ($debug)
				echo "Skipping $table\n";
			continue;
		}
		if ($debug)
			echo "Creating $table\n";

		if ($empty_tables && $gDb_dst->tableExists($table))
			$gDb_dst->dropTables(array($table));

		$schema = $gDb_src->MetaColumns( $table, false, true );
		$t = "";
		$first = true;
		foreach(array_keys($schema) as $col) {
			$t .= (!$first) ? ",\n" : "";
			$x = $schema[$col];
			$t .= $x->name . " ";
			switch($x->type) {
				case "int":
					$i = abs(( ( (int)$x->max_length ^ 2) - 1 ));
					$t .= "I" . $i;
					break;

				case "varchar":
					$t .= "C(" . $x->max_length . ")";
					break;
				
				case "datetime":
					$t .= "T";
					break;
				
				case "longblob":
					$t .= "X";
					break;
			}
			$default = (!$x->binary) ? $x->has_default : false;
			$t .= " " . ( ($x->unsigned) ? "UNSIGNED" : "" ) . " "
			 	. ( ($x->not_null) ? "NOTNULL" : "" ) . " "
			 	. ( ($x->auto_increment) ? "AUTO" : "" ) . " "
				. ( ($x->primary_key) ? "PRIMARY" : "" ) . " "
				. ( ($default) ? "DEFAULT ". $x->default_value : "" );
			$table_schema[$table] = $t;
			$first = false;
		}
		$indices[$table] = $gDb_src->MetaIndexes( $table, false, false );
	}

	//vd($table_schema);
	//vd($indices);

	$pOptions = array();
	if ($empty_tables)
		$pOptions[] = "REPLACE";

	switch ($gDb_dst->mType) {
		case "mysql":
		// SHOULD HANDLE INNODB so foreign keys are cool - XOXO spiderr
		$pOptions['mysql'] = 'TYPE=INNODB';
		default:
		//$pOptions[] = 'REPLACE';
	}

	$dict = NewDataDictionary($gDb_dst->mDb);
	$result = true;
	foreach(array_keys($table_schema) AS $tableName)
	{
		$completeTableName = $prefix_dst.$tableName;
		$sql = $dict->CreateTableSQL($completeTableName, $table_schema[$tableName], $pOptions);
		if ($sql && ($dict->ExecuteSQLArray($sql) > 0))
		{
			// Success
		}
		else
		{
			// Failure
			array_push($gDb_dst->mFailed, $gDb_dst->mDb->ErrorMsg());
			if ($stop_on_errors)
				break;
		}

		foreach( array_keys( $indices ) as $index ) {
			foreach( array_keys( $indices[$index] ) as $col) {
				$completeTableName = $prefix_dst.$index;
				$flds = implode(",", $indices[$index][$col]["columns"]);
				$name = implode("_", $indices[$index][$col]["columns"]);
				$sql = $dict->CreateIndexSQL( $index."_".$name, $completeTableName, $flds, (($indices[$index][$col]["unique"]) ? array("UNIQUE") : NULL) );
				if( $sql && ($dict->ExecuteSQLArray($sql) > 0))
				{
					// Success
				} else {
					// Failure
					array_push( $gDb_dst->mFailed, $gDb_dst->mDb->ErrorMsg());
					if ($stop_on_errors)
						break;
				}
			}
		}

	}

//vd($gDb_dst->mFailed);die;
	foreach(array_keys($table_schema) as $table) {
		$q = 0;
		$c = 0;
		$gDb_dst->StartTrans();
		// get source data
		$result = $gDb_src->Execute("SELECT * FROM $table");
		// identify blob fields
		//echo "$table\n";
		//print_r($encoded_tables);
		//var_dump(array_search($table, $encoded_tables));die;
		$blobs = identifyBlobs($result);
		//print_r($blobs);

		while ($res = $result->FetchRow()) {
			//var_dump($res);die;
			// convert blobs
			if($convert_blobs && !empty($blobs)) {
				$c++;
				convertBlobs($gDb_dst, $res, $blobs);
			}
			$q++;
			// insert data into destination
			if($gDb_dst->associateInsert( $table, $res) === false) {
				array_push( $gDb_dst->mFailed, $gDb_dst->mDb->ErrorMsg());
				if ($stop_on_errors)
					break;
			}
		}

		$gDb_dst->CompleteTrans();
		$results[]= "$table: migrated $q records".(($c > 0) ? "and converted $c blobs" : "");
	}
//vd($gDb_dst->mFailed);die;
	$gBitSmarty->assign_by_ref( 'results', $results );
	$gBitSmarty->assign_by_ref( 'errors', $gDb_dst->mFailed );
	$app = "_done";
	$gBitSmarty->assign( 'next_step', $step + 1 );

}

function testDatabase() {
	global $gBitDbType, $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName, $gBitSmarty;
	if( $gBitDbType == 'sybase' ) {
		// avoid database change messages
		ini_set('sybct.min_server_severity', '11');
	}

	$gBitDb = &ADONewConnection($gBitDbType);

	if( !$gBitDb->Connect($gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName) ) {
		return TRUE;
	}
	return FALSE;
}

?>
