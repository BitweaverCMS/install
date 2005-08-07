<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/Attic/pump_bitcommerce_inc.php,v 1.2 2005/08/07 17:37:53 squareing Exp $
 * @package install
 * @subpackage pumps
 */

/**
 * Required files
 */
	require_once( BITCOMMERCE_PKG_PATH.'includes/common_inc.php' );
	reset_bitcommerce_layout();

	$pumpedData['Bitcommerce'][] = 'Created Commerce Layout';

?>