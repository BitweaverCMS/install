<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/migrate_welcome.php,v 1.3 2009/10/01 13:45:42 wjames5 Exp $
 * @package install
 * @subpackage migrate
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step + 1 );
?>
