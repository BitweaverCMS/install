<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_final.php,v 1.5 2007/06/22 09:35:38 lsces Exp $
 * this is set to tell the progress meter to include this page --> 100% completed
 * 
 * @package install
 * @subpackage functions
 */
$app = '_done';
if( !empty( $_SESSION['first_install'] ) ) {
	$_SESSION = NULL;
}
?>
