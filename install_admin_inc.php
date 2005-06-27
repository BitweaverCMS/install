<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_admin_inc.php,v 1.1.1.1.2.1 2005/06/27 12:49:50 lsces Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$smarty->assign( 'next_step',$step );

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
		$smarty->assign( 'next_step',$step + 1 );
		$smarty->assign( 'pass_disp',eregi_replace( '.','&bull;',$_REQUEST['password'] ) );
	}
	$_SESSION['real_name'] = $_REQUEST['real_name'];
	$_SESSION['login'] = $_REQUEST['login'];
	$_SESSION['password'] = $_REQUEST['password'];
	$_SESSION['email'] = $_REQUEST['email'];

	$smarty->assign( 'real_name',$_SESSION['real_name'] );
	$smarty->assign( 'login',$_SESSION['login'] );
	$smarty->assign( 'password',$_SESSION['password'] );
	$smarty->assign( 'pass_confirm',$_SESSION['password'] );
	$smarty->assign( 'email',$_SESSION['email'] );
	$smarty->assign( 'errors',$errors );
} else {
	$smarty->assign( 'user', '');
	$smarty->assign( 'email', 'admin@localhost');
}
?>
