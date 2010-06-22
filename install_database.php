<?php
/**
 * @version $Header$
 * @package install
 * @subpackage functions
 */

/**
 * assign next step in installation process
 */
$gBitSmarty->assign( 'next_step',$step );

require_once( "get_databases_inc.php" );

// next block checks if there is a config/kernel_config.php and if we can connect through this.
if( isset( $_REQUEST['submit_db_info'] )) {
	if( $gBitDbType == 'sybase' ) {
		// avoid database change messages
		ini_set( 'sybct.min_server_severity', '11' );
	}
	
	// for Oracle force database name to use one from tnsnames
	// this way we avoid further StartTrans errors that was often reported,
	if( $gBitDbType == 'oci8po' && empty( $gBitDbName ) ) {
		$gBitSmarty->assign( 'error', TRUE );
		$gBitSmarty->assign( 'errorMsg', "Please fill Database Name field. If you don't know it and you're using Express Edition it's probably 'XE'. Otherwise check your \"tnsnames.ora\" file to get appropriate one." );
		$error = TRUE; 
	} else {
		
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
	
			if( $_SESSION['first_install'] == TRUE ) {
				// For MySql only, on first install check if server support
				// InnoDB and set a smarty var for template to offer using
				// the transaction safe storage engine
				if( preg_match( '/mysql/', $gBitDbType )) {
					$_SESSION['use_innodb'] = FALSE;
					$rs = $gBitDb->Execute('SHOW ENGINES');
					while ( !$rs->EOF) {
						$row = $rs->GetRowAssoc(false);
						switch( isset( $row['Engine'] ) ? strtoupper( $row['Engine'] ) : strtoupper( $row['Type'] )) {
							case 'INNODB':
							case 'INNOBASE':
								if( strtoupper( $row['Support'] ) == 'YES' || strtoupper( $row['Support'] ) == 'DEFAULT' ) {
									$gBitSmarty->assign( 'has_innodb_support',strtoupper( $row['Support'] ) );
									break 2;
								}
						}
	
						$rs->MoveNext();
					}
					$rs->Close();
				}
			}
		} else {
			$gBitSmarty->assign( 'error', TRUE );
			$gBitSmarty->assign( 'errorMsg', $gBitDb->_errorMsg );
			$error = TRUE;
		}
	}
}
?>
