<?php
/**
 * @version $Header$
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See below for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See http://www.gnu.org/copyleft/lesser.html for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step );

if( !empty( $_REQUEST['admin_submit'] )) {
	$mail = $errors = array();
	if( empty( $_REQUEST['login'] ) ) {
		$errors['login'] = "You must specify an administrator name.";
	}
	if( empty( $_REQUEST['email'] ) ) {
		$errors['email'] = "You must specify an email address.";
	} else {
		BitUser::verifyEmail( $_REQUEST['email'], $errors );
	}

	if( $_REQUEST['password'] != $_REQUEST['pass_confirm'] ) {
		$errors['password'] = "The passwords you entered do not match.";
		$_REQUEST['password'] = '';
	} elseif( strlen( $_REQUEST['password'] ) < 4 ) {
		$errors['password'] = "The administrator password has to be at least 4 characters.";
		$_REQUEST['password'] = '';
	}

	if( empty( $errors )) {
		$app = '_done';
		$gBitSmarty->assign( 'next_step', $step + 1 );
		$gBitSmarty->assign( 'pass_disp', preg_replace( '/./i','&bull;',$_REQUEST['password'] ) );

		// do a mailer check as well - we need to remove trailing options for the sendmail_path check
		if( !empty( $_REQUEST['testemail'] )) {
			if(( $mail_path = trim( preg_replace( "#\s+\-[a-zA-Z]+.*$#", "", ini_get( 'sendmail_path' )))) && is_file( $mail_path )) {
				$to      = $_REQUEST['email'];
				$from    = "bitweaver@".$_SERVER['SERVER_NAME'];
				$subject = "bitweaver test email";
				$message = "Congratulations!\r\n".
					"The email system on your server at ".$_SERVER['SERVER_NAME']." is working!\r\n\r\n".
					"Thank you for trying bitweaver,\r\n".
					"The bitweaver team.\r\n";
				$headers = "From: $from\r\n".
					"Reply-To: $from\r\n".
					"X-Mailer: PHP/".phpversion();

				if( mail( $to, $subject, $message, $headers )) {
					$mail['success'] = "We sent an email to <strong>$to</strong>.";
				} else {
					$mail['warning'] = "We have tried to send an email to <strong>$to</strong> and the mailing system on the server has not accepted the email.";
				}
			} else {
				$mail['warning'] = "The email settings on your php server are not set up correctly. Please make sure to set a valid <strong>sendmail_path</strong> if you plan to send emails with bitweaver.";
			}
		}
	}

	$_SESSION['real_name'] = $_REQUEST['real_name'];
	$_SESSION['login']     = $_REQUEST['login'];
	$_SESSION['password']  = $_REQUEST['password'];
	$_SESSION['email']     = $_REQUEST['email'];

	$gBitSmarty->assign( 'mail', $mail );
	$gBitSmarty->assign( 'real_name', $_SESSION['real_name'] );
	$gBitSmarty->assign( 'login', $_SESSION['login'] );
	$gBitSmarty->assign( 'password', $_SESSION['password'] );
	$gBitSmarty->assign( 'pass_confirm', $_SESSION['password'] );
	$gBitSmarty->assign( 'email', $_SESSION['email'] );
	$gBitSmarty->assign( 'errors', $errors );
} else {
	$gBitSmarty->assign( 'user', '');
	$gBitSmarty->assign( 'email', 'admin@localhost');
}
?>
