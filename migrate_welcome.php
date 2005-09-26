<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/migrate_welcome.php,v 1.1.2.1 2005/09/26 09:42:09 wolff_borg Exp $
 * @package install
 * @subpackage migrate
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step + 1 );
?>
