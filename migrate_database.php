<?php
/**
 * @version $Header$
 * @package install
 * @subpackage upgrade
 *
 * Copyright (c) 2004 Stephan Borg, tikipro.org
 * All Rights Reserved. See below for details and a complete list of authors.
 *
 * Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details
 *
 * $Id$
 */

/**
 * Initialization
 */
$gBitSmarty->assign( 'next_step', $step );
require_once( 'install_inc.php' );
require_once( "get_databases_inc.php" );

// set the maximum execution time to very high
ini_set( "max_execution_time", "86400" );

if( isset( $_REQUEST['db_src'] ) ) {
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
	$gBitSmarty->assign( 'convert_blobs', TRUE );
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
		$gBitSmarty->assignByRef( 'skip_tables', $tables_src );
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
	$createHash = array(
		"gBitDbType"            => $_REQUEST['db_dst'],
		"gBitDbHost"            => $tmpHost,
		"gBitDbUser"            => $_REQUEST['user_dst'],
		"gBitDbPassword"        => $_REQUEST['pass_dst'],
		"gBitDbName"            => $_REQUEST['name_dst'],
		//"gBitDbCaseSensitivity" => $_REQUEST['dbcase'],
		"bit_db_prefix"         => $_REQUEST['prefix_dst'],
		"bit_root_url"          => $_REQUEST['baseurl'],
		"auto_bug_submit"       => isset( $_REQUEST['auto_bug_submit'] ) ? 'TRUE' : 'FALSE',
		"is_live"               => isset( $_REQUEST['is_live'] ) ? 'TRUE' : 'FALSE',
	);
	create_config( $createHash );

	// init db connections
	//vd($gDb_src);
	//vd($gDb_dst);die;

	if($debug) {
		$gDb_dst->debug();
	}

	// list source tables list
	$tables_src = array($tables_src[2]);
	$tables_dst = getTables($gDb_dst);
	print_r($tables_src);die;

	$table_schema = array();
	// iterate through source tables
	foreach($tables_src as $table) {
		if (array_search($table, $skip_tables) !== FALSE) {
			if ($debug)
				echo "Skipping $table<br>\n";
			continue;
		}
		if ($debug)
			echo "Creating $table<br>\n";

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
				case "tinyint":
				case "int":
					$i = abs(( ( (int)$x->max_length ^ 2) - 1 ));
					$i = ($i == 5) ? 4 : $i;
					$i = ($i == 0) ? 1 : $i;
					$t .= "I" . $i;
					break;

				case "double":
					$t .= "N";
					break;
				
				case "varchar":
				case "char":
				case "enum":
				case "decimal":
					$t .= "C(" . $x->max_length . ")";
					break;
				
				case "time":
				case "timestamp":
				case "datetime":
					$t .= "T";
					break;
				
				case "date":
					$t .= "D";
					break;
				
				case "blob":
				case "longblob":
				case "tinyblob":
					$t .= "B";
					break;

				case "text":
					$t .= "X";
					break;
				default:
					die(tra("No support for type '".$x->type."' - please log a bug at http://sf.net/projects/bitweaver"));
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
		$blobs = BitInstaller::identifyBlobs($result);
		//print_r($blobs);

		while ($res = $result->FetchRow()) {
			//var_dump($res);die;
			// convert blobs
			if($convert_blobs && !empty($blobs)) {
				$c++;
				BitInstaller::convertBlobs($gDb_dst, $res, $blobs);
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
	$gBitSmarty->assignByRef( 'results', $results );
	$gBitSmarty->assignByRef( 'errors', $gDb_dst->mFailed );
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
