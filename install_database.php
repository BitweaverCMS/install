<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_database.php,v 1.18 2007/01/11 08:41:37 squareing Exp $
 * @package install
 * @subpackage functions
 */

/**
 * assign next step in installation process
 */ 
$gBitSmarty->assign( 'next_step',$step );

require_once( "get_databases_inc.php" );

// next block checks if there is a config_inc.php and if we can connect through this.
if( isset( $_REQUEST['submit_db_info'] )) {
	if( $gBitDbType == 'sybase' ) {
		// avoid database change messages
		ini_set( 'sybct.min_server_severity', '11' );
	}

	$gBitDb = &ADONewConnection( $gBitDbType );

	if( $gBitDb->Connect( $gBitDbHost, $gBitDbUser, $gBitDbPassword, $gBitDbName )) {
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
