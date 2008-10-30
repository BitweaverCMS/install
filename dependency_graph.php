<?php
require_once( 'install_inc.php' );
$gBitInstaller->drawDependencyGraph(( !empty( $_REQUEST['format'] ) ? $_REQUEST['format'] : 'png' ), ( !empty( $_REQUEST['command'] ) ? $_REQUEST['command'] : 'dot' ));
?>
