<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_database.php,v 1.4 2005/06/28 07:45:45 spiderr Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$smarty->assign( 'next_step',$step );

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
	$dbtodsn['mssql'] = 'MS-SQL (experimental)';
}
if( function_exists( 'ibase_connect' ) ) {
	$dbtodsn['firebird'] = 'Firebird 1.5+';
	if ( empty($fbpath) ) {
		if ( isWindows() )
			$fbpath = 'c:\Program Files\Firebird\Firebird_1_5\bin\isql';
		else
			$fbpath = '/opt/firebird/bin/isql';
	}
	$smarty->assign( 'fbpath', $fbpath );
	if ( empty($gBitDbName) ) $gBitDbName = 'bitweaver';
}
if( function_exists( 'sqlite_open' ) ) {
	$dbtodsn['sqlite'] = 'SQLLite';
}
$smarty->assign_by_ref('dbservers', $dbtodsn);

$smarty->assign( 'gBitDbType', $gBitDbType );
$smarty->assign( 'gBitDbHost', $gBitDbHost );
$smarty->assign( 'gBitDbUser', $gBitDbUser );
$smarty->assign( 'gBitDbPassword', $gBitDbPassword );
$smarty->assign( 'gBitDbName', $gBitDbName );
$smarty->assign( 'db_prefix_bit', BIT_DB_PREFIX );
$smarty->assign( 'root_url_bit', $root_url_bit );
if( defined( 'AUTO_BUG_SUBMIT' ) ) {
	$smarty->assign( 'auto_bug_submit', AUTO_BUG_SUBMIT );
}

$smarty->assign( 'gBitDbPassword_input', $gBitDbPassword );
$smarty->assign( 'gBitDbPassword_print', preg_replace( '/./','&bull;',$gBitDbPassword ) );

// next block checks if there is a config_inc.php and if we can connect through this.
if( isset( $_REQUEST['fSubmitDbInfo'] ) ) {
	if( $gBitDbType == 'sybase' ) {
		// avoid database change messages
		ini_set('sybct.min_server_severity', '11');
	}

	$gBitDb = &ADONewConnection($gBitDbType);

	if( $gBitDb->Connect($gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName) ) {
		// display success page when done
		$app = '_done';
		$smarty->assign( 'next_step',$step + 1 );
		// this is where we tell the installer that this is the first install
		// if so, clear out session variables
		// if we are coming here from the upgrade process, don't change any value
		if( isset( $_SESSION['first_install'] ) && $_SESSION['first_install'] == TRUE && isset( $_SESSION['upgrade'] ) && $_SESSION['upgrade'] == TRUE ) {
			// nothing to do
		} elseif( !$gBitUser->isAdmin() ) {
			$_SESSION = NULL;
			$_SESSION['first_install'] = TRUE;
		} else {
			$_SESSION['first_install'] = FALSE;
		}
	} else {
		$smarty->assign( 'error', 'Database connection could not be established.
			<ul>
				<li>Perhaps your database is not available</li>
				<li>or the server cannot connect to it</li>
				<li>or you have made a typo</li>
				<li>Please double check the following settings:
					<ul>
						<li><strong>database name</strong></li>
						<li><strong>database username</strong></li>
						<li><strong>database password</strong></li>
					</ul>
				</li>
			</ul>' );
		$error = 1;
	}
}
?>
