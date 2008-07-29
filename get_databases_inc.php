<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/get_databases_inc.php,v 1.10 2008/07/29 05:55:17 lsces Exp $
 * @package install
 * @subpackage functions
 *
 * check what db servers are available and display them accordingly - only seems to work with *nix
 */
$gBitDbCaseSensitivity = TRUE;
$dbtodsn = array();
if( function_exists( 'mysql_connect' ) ) {
	// check version of mysql server - only server that allows check without actually connecting to it... (who knows how that works)
	if( @mysql_get_server_info() ) {
		$version = mysql_get_server_info();
		// Check for versions less than 4.0
		if ($version[0] < 4 || ($version[0] == 4 && $version[2] == 0)) {
			$gBitSmarty->assign("mysqlWarning", TRUE);
		}
		$dbtodsn['mysql'] = 'MySQL '.mysql_get_server_info();
	} else {
		$dbtodsn['mysql'] = 'MySQL';
		// Can't get the version output the warning.
		$gBitSmarty->assign("mysqlWarning", TRUE);
	}
}
if( function_exists( 'mysqli_connect' ) ) {
	$dbtodsn['mysqli'] = 'MySQLi';
}
if( function_exists( 'pg_connect' ) ) {
	$dbtodsn['postgres'] = 'PostgreSQL';
}
if( function_exists( 'ocilogon' ) ) {
	$dbtodsn['oci8po'] = 'Oracle 8.i';
	$gBitDbCaseSensitivity = FALSE;
}
if( function_exists( 'sybase_connect' ) ) {
	$dbtodsn['sybase'] = 'Sybase';
}
if( function_exists( 'mssql_connect' ) ) {
	$dbtodsn['mssql'] = 'MS-SQL';
}
if( function_exists( 'fbsql_connect' ) ) {
	$dbtodsn['fbsql'] = 'FrontBase';
}
if( function_exists( 'fbird_connect' ) ) {
	$dbtodsn['firebird'] = 'Firebird';
	if ( !empty($_REQUEST['fbpath']) ) $fbpath = $_REQUEST['fbpath'];
	if ( empty($fbpath) ) {
		if ( is_windows() )
			$fbpath = 'c:\Program Files\Firebird\Firebird_2_0\bin\isql';
		else
			$fbpath = '/opt/firebird/bin/isql';
	}
	$gBitSmarty->assign( 'fbpath', $fbpath );
	if ( empty($gBitDbName) ) $gBitDbName = 'bitweaver';
	$gBitDbCaseSensitivity = FALSE;
} 
if( function_exists( 'sqlite_open' ) ) {
	$dbtodsn['sqlite'] = 'SQLLite';
}
$gBitSmarty->assign_by_ref('dbservers', $dbtodsn);

$gBitSmarty->assign( 'gBitDbType', $gBitDbType );
$gBitSmarty->assign( 'gBitDbHost', $gBitDbHost );
$gBitSmarty->assign( 'gBitDbUser', $gBitDbUser );
$gBitSmarty->assign( 'gBitDbPassword', $gBitDbPassword );
$gBitSmarty->assign( 'gBitDbName', $gBitDbName );
$gBitSmarty->assign( 'gBitDbCaseSensitivity', $gBitDbCaseSensitivity );
$gBitSmarty->assign( 'db_prefix_bit', BIT_DB_PREFIX );
$gBitSmarty->assign( 'bit_root_url', $bit_root_url );
if( defined( 'AUTO_BUG_SUBMIT' ) ) {
	$gBitSmarty->assign( 'auto_bug_submit', AUTO_BUG_SUBMIT );
}

$gBitSmarty->assign( 'gBitDbPassword_input', $gBitDbPassword );
$gBitSmarty->assign( 'gBitDbPassword_print', preg_replace( '/./','&bull;',$gBitDbPassword ) );
?>
