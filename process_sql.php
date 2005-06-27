<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/process_sql.php,v 1.1.1.1.2.2 2005/06/27 17:48:09 lsces Exp $
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
