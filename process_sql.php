<?php
// Global flag to indicate we are installin
define( 'BIT_INSTALL', 'TRUE' );
	global $failedcommands;
// keep some crappy notices from spewing
$_SERVER['HTTP_HOST'] = 'shell';
$_SERVER['SERVER_SOFTWARE'] = 'command_line';


require_once( 'install_lib.php' );
include("../bit_setup_inc.php");

if( count( $argv ) < 2) {
	print "Please enter name of SQL file in db/ directory to process\n";
} else {
	// avoid errors in ADONewConnection() (wrong darabase driver etc...)
	$gBitDb = &ADONewConnection($gBitDbType);
	if( $gBitDb->Connect($gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName) ) {
		process_sql_file( $argv[1], $gBitDbType, BIT_DB_PREFIX );
	}
}

?>
