<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_admin_inc.php,v 1.1.1.1.2.2 2005/07/26 15:50:07 drewslater Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step );

if( isset( $_REQUEST['fSubmitAdmin'] ) ) {
	$warning = array();
	if( empty( $_REQUEST['login'] ) ) {
		$errors['login'] = "You must specify an administrator name.";
	}
	if( empty( $_REQUEST['email'] ) || !BitUser::verifyEmail( $_REQUEST['email'] ) ) {
		$errors['email'] = 'The email "'.$_REQUEST['email'].'" is not valid.';
	}
	if( $_REQUEST['password'] != $_REQUEST['pass_confirm'] ) {
		$errors['password'] = "The passwords you entered do not match.";
		$_REQUEST['password'] = '';
	} elseif( strlen( $_REQUEST['password'] ) < 4 ) {
		$errors['password'] = "The administrator password has to be at least 4 characters.";
		$_REQUEST['password'] = '';
	}
	if( empty( $errors ) ) {
		$app = '_done';
		$gBitSmarty->assign( 'next_step',$step + 1 );
		$gBitSmarty->assign( 'pass_disp',eregi_replace( '.','&bull;',$_REQUEST['password'] ) );
	}
	$_SESSION['real_name'] = $_REQUEST['real_name'];
	$_SESSION['login'] = $_REQUEST['login'];
	$_SESSION['password'] = $_REQUEST['password'];
	$_SESSION['email'] = $_REQUEST['email'];

	$gBitSmarty->assign( 'real_name',$_SESSION['real_name'] );
	$gBitSmarty->assign( 'login',$_SESSION['login'] );
	$gBitSmarty->assign( 'password',$_SESSION['password'] );
	$gBitSmarty->assign( 'pass_confirm',$_SESSION['password'] );
	$gBitSmarty->assign( 'email',$_SESSION['email'] );
	$gBitSmarty->assign( 'errors',$errors );
} else {
	$gBitSmarty->assign( 'user', '');
	$gBitSmarty->assign( 'email', 'admin@localhost');
}
?>
