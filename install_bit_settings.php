<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_bit_settings.php,v 1.6 2005/10/12 15:13:51 spiderr Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step );

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
	global $_REQUEST, $gBitSystem, $gBitSmarty;

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
	global $_REQUEST, $gBitSystem, $gBitSmarty;
	if (isset($_REQUEST[$feature])) {
		$gBitSystem->storePreference($feature, $_REQUEST[$feature]);
		$gBitSmarty->assign($feature, $_REQUEST[$feature]);
	}
}

// pass all package data to template
$gBitSmarty->assign_by_ref( 'schema', $gBitInstaller->mPackages );

// settings that aren't just toggles
$formInstallValues = array(
	'bitIndex',
	'feature_server_name',
	'siteTitle',
	'site_slogan',
	'bitlanguage',
);

if( extension_loaded( 'imagick' ) && extension_loaded( 'gd' ) ) {
	$gBitSmarty->assign( 'choose_image_processor', TRUE );
	$formInstallValues[] = 'image_processor';
}

// get list of available languages
$languages = array();
$languages = $gBitLanguage->listLanguages();
$gBitSmarty->assign_by_ref("languages",$languages );

// process form
if( isset( $_REQUEST['fSubmitBitSettings'] ) ) {
	foreach( $formInstallValues as $item ) {
		simple_set_value( $item );
	}

	$gBitLanguage->setLanguage( $_REQUEST['bitlanguage'] );
	$gBitSmarty->assign( "siteLanguage",$languages[$_REQUEST['bitlanguage']] );
	// advance a step in the installer
	$app = '_done';
	$gBitSmarty->assign( 'next_step',$step + 1 );
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
$gBitSmarty->assign( "foreign_packages", $foreign_packages );
?>
