<?php
// this is set to tell the progress meter to include this page --> 100% completed
$app = '_done';
if( !empty( $_SESSION['first_install'] ) ) {
	$_SESSION = NULL;
}
?>
