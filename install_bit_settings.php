<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_bit_settings.php,v 1.3.2.1 2005/06/27 12:49:50 lsces Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$smarty->assign( 'next_step',$step );

/**
 * simple_set_toggle
 */
function simple_set_toggle($feature, $pPackageName=NULL) {
	toggle_preference( $feature, (isset($_REQUEST[$feature][0]) ? $_REQUEST[$feature][0] : NULL), $pPackageName );
}

/**
 * toggle_preference
 */
function toggle_preference( $pName, $pValue, $pPackageName=NULL ) {
	global $_REQUEST, $gBitSystem, $smarty;

	if (isset($pValue) && $pValue == "on") {
		$prefValue='y';
	} elseif( isset($pValue) && $pValue != "n" && strlen( $pValue ) == 1 ) {
		$prefValue=$pValue;
	} else {
		$prefValue='n';
	}
	$gBitSystem->storePreference( $pName, $prefValue, $pPackageName );
}

/**
 * simple_set_value
 */
function simple_set_value($feature) {
	global $_REQUEST, $gBitSystem, $smarty;
	if (isset($_REQUEST[$feature])) {
		$gBitSystem->storePreference($feature, $_REQUEST[$feature]);
		$smarty->assign($feature, $_REQUEST[$feature]);
	}
}

// pass all package data to template
$smarty->assign_by_ref( 'schema', $gBitInstaller->mPackages );

// settings that aren't just toggles
$formInstallValues = array(
	'bitIndex',
	'feature_server_name',
	'siteTitle',
	'site_slogan',
	'bitlanguage',
);

if( extension_loaded( 'imagick' ) && extension_loaded( 'gd' ) ) {
	$smarty->assign( 'choose_image_processor', TRUE );
	$formInstallValues[] = 'image_processor';
}

$smarty->assign( 'feature_server_name', $_SERVER['SERVER_NAME'] );

// get list of available languages
$languages = array();
$languages = $gBitLanguage->listLanguages();
$smarty->assign_by_ref("languages",$languages );

// process form
if( isset( $_REQUEST['fSubmitBitSettings'] ) ) {
	foreach( $formInstallValues as $item ) {
		simple_set_value( $item );
	}

	$gBitLanguage->setLanguage( $_REQUEST['bitlanguage'] );
	$smarty->assign( "siteLanguage",$languages[$_REQUEST['bitlanguage']] );
	// advance a step in the installer
	$app = '_done';
	$smarty->assign( 'next_step',$step + 1 );
} elseif( isset( $_REQUEST['skip'] ) ) {
	$goto = $step + 1;
	header( "Location: install.php?step=$goto" );
}

// get list of foreign packages that are ready to be installed
// @TODO this isn't working yet, since the info stuff isn't read from schema_inc.php on this page
$foreign_packages = array();
foreach( $gBitSystem->mPackages as $package ) {
	if( isset( $package['info']['install'] ) ) {
		$foreign_packages[] = $package;
	}
}
$smarty->assign("foreign_packages",$foreign_packages );
?>
