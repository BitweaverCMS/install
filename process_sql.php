<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/process_sql.php,v 1.3 2010/02/08 21:27:23 wjames5 Exp $
 * @package install
 * @subpackage functions
 */

/**
 * Global flag to indicate we are installing
 * @ignore 
 */
define( 'BIT_INSTALL', 'TRUE' );
	global $failedcommands;
// keep some crappy notices from spewing
$_SERVER['HTTP_HOST'] = 'shell';
$_SERVER['SERVER_SOFTWARE'] = 'command_line';

/**
 * required setup
 */
require_once( 'install_lib.php' );
include("../kernel/setup_inc.php");

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
