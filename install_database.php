<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_database.php,v 1.3.2.5 2005/12/22 13:48:21 squareing Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step );

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

$gBitSmarty->assign( 'gBitDbType', $gBitDbType );
$gBitSmarty->assign( 'gBitDbHost', $gBitDbHost );
$gBitSmarty->assign( 'gBitDbUser', $gBitDbUser );
$gBitSmarty->assign( 'gBitDbPassword', $gBitDbPassword );
$gBitSmarty->assign( 'gBitDbName', $gBitDbName );
$gBitSmarty->assign( 'db_prefix_bit', BIT_DB_PREFIX );
$gBitSmarty->assign( 'root_url_bit', $root_url_bit );
if( defined( 'AUTO_BUG_SUBMIT' ) ) {
	$gBitSmarty->assign( 'auto_bug_submit', AUTO_BUG_SUBMIT );
}

$gBitSmarty->assign( 'gBitDbPassword_input', $gBitDbPassword );
$gBitSmarty->assign( 'gBitDbPassword_print', preg_replace( '/./','&bull;',$gBitDbPassword ) );

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
		$gBitSmarty->assign( 'next_step',$step + 1 );
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
		$gBitSmarty->assign( 'error', TRUE );
		$gBitSmarty->assign( 'errorMsg', $gBitDb->_errorMsg );
		$error = TRUE;
	}
}
?>
