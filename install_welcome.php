<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_welcome.php,v 1.1.1.1.2.2 2005/07/26 15:50:07 drewslater Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step + 1 );
?>