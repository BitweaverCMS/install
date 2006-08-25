<?php
// check what db servers are available and display them accordingly - only seems to work with *nix
$dbtodsn = array();
if( function_exists( 'mysql_connect' ) ) {
	// check version of mysql server - only server that allows check without actually connecting to it... (who knows how that works)
	if( @mysql_get_server_info() ) {
		$dbtodsn['mysql'] = 'MySQL '.mysql_get_server_info();
	} else {
		$dbtodsn['mysql'] = 'MySQL';
	}
}
if( function_exists( 'mysqli_connect' ) ) {
	$dbtodsn['mysql'] = 'MySQLi';
}
if( function_exists( 'pg_connect' ) ) {
	$dbtodsn['postgres'] = 'PostgreSQL';
}
if( function_exists( 'ocilogon' ) ) {
	$dbtodsn['oci8po'] = 'Oracle 8.i';
}
if( function_exists( 'sybase_connect' ) ) {
	$dbtodsn['sybase'] = 'Sybase';
}
if( function_exists( 'mssql_connect' ) ) {
	$dbtodsn['mssql'] = 'MS-SQL';
}
if( function_exists( 'ibase_connect' ) ) {
	$dbtodsn['firebird'] = 'Firebird';
	if ( empty($fbpath) ) {
		if ( isWindows() )
			$fbpath = 'c:\Program Files\Firebird\Firebird_1_5\bin\isql';
		else
			$fbpath = '/opt/firebird/bin/isql';
	}
	$gBitSmarty->assign( 'fbpath', $fbpath );
	if ( empty($gBitDbName) ) $gBitDbName = 'bitweaver';
	$gBitDbCaseSensitivity = FALSE;
} else {
	$gBitDbCaseSensitivity = TRUE;
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
$gBitSmarty->assign( 'root_url_bit', $root_url_bit );
if( defined( 'AUTO_BUG_SUBMIT' ) ) {
	$gBitSmarty->assign( 'auto_bug_submit', AUTO_BUG_SUBMIT );
}

$gBitSmarty->assign( 'gBitDbPassword_input', $gBitDbPassword );
$gBitSmarty->assign( 'gBitDbPassword_print', preg_replace( '/./','&bull;',$gBitDbPassword ) );
?>
