<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_checks.php,v 1.2.2.11 2006/01/14 09:24:32 squareing Exp $
 * @package install
 * @subpackage functions
 */

// Copyright (c) 2002-2003, Luis Argerich, Garland Foster, Eduardo Polidor, et. al.
// All Rights Reserved. See copyright.txt for details and a complete list of authors.
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details.

// assign next step in installation process
$gBitSmarty->assign( 'next_step',$step + 1 );

$check_settings = check_settings();

$gBitSmarty->assign( "error",$error );
$gBitSmarty->assign( "warning",$warning );
$gBitSmarty->assign( "required",$check_settings['required'] );
$gBitSmarty->assign( "extensions",$check_settings['extensions'] );
$gBitSmarty->assign( "recommended",$check_settings['recommended'] );
$gBitSmarty->assign( "show",$check_settings['show'] );

if( !isset( $_SERVER['HTTP_REFERER'] ) ) {
	$gBitSmarty->assign( "http_referer_error", TRUE );
	$error = TRUE;
}

/**
 * check_settings
 */
function check_settings() {
	global $gBitSmarty,$error,$warning;
	$config_file = clean_file_path( empty($_SERVER['CONFIG_INC']) ? (KERNEL_PKG_PATH.'config_inc.php') : $_SERVER['CONFIG_INC'] );

	$i = 0;
	// required settings - if not met, are passed into the array $reqd
	// PHP system checks
	$phpvers = '4.1.0';
	if( phpversion() < $phpvers ) {
		$required[$i]['note'] = '<strong>PHP version</strong> should be greater than <strong>'.$phpvers.'</strong>.<br />Your installed version of PHP is <strong>'.phpversion().'</strong>.';
		$required[$i]['passed'] = FALSE;
	} else {
		$required[$i]['note'] = '<strong>PHP version</strong> is greater than <strong>'.$phpvers.'</strong>.<br />Your installed version of PHP is <strong>'.phpversion().'</strong>.';
		$required[$i]['passed'] = TRUE;
	}
	// check file and directory permissisions
	$i++;
	if( @file_exists( $config_file ) && @bw_is_writeable( $config_file ) ) {
		$required[$i]['note'] = 'The configuration file \'<strong>'.$config_file.'</strong>\' is available and the file is writeable.';
		$required[$i]['passed'] = TRUE;
	} elseif( @file_exists( $config_file ) && !@bw_is_writeable( $config_file ) ) {
		$required[$i]['note'] = 'The configuration file \'<strong>'.$config_file.'</strong>\' is available but the file is not writeable. Please execute something like:<br />chmod 777 '.$config_file;
		$required[$i]['passed'] = FALSE;
	} else {
		$required[$i]['note'] = 'The configuration file \'<strong>'.$config_file.'</strong>\' is not available. Please execute something like:<br />touch '.KERNEL_PKG_PATH.'config_inc.php; chmod 777 '.$config_file;
		$required[$i]['passed'] = FALSE;
	}
	$i++;
	$dir_check = array( 'storage','temp' );
	foreach( $dir_check as $d ) {
		// final attempt to create the required directories
		@mkdir( BIT_ROOT_PATH.$d,0644 );
		if( @is_dir( BIT_ROOT_PATH.$d ) && bw_is_writeable( BIT_ROOT_PATH.$d ) ) {
			$required[$i]['note'] = 'The directory \'<strong>'.BIT_ROOT_PATH.$d.'</strong>\' is available and it is writeable.';
			$required[$i]['passed'] = TRUE;
		} elseif( @is_dir( BIT_ROOT_PATH.$d ) && !bw_is_writeable( BIT_ROOT_PATH.$d ) ) {
			$required[$i]['note'] = 'The directory \'<strong>'.BIT_ROOT_PATH.$d.'</strong>\' is available but it is not writeable.<br />Please execute something like:<br />chmod -R 777 '.BIT_ROOT_PATH.$d;
			$required[$i]['passed'] = FALSE;
		} else {
			$required[$i]['note'] = 'The directory \'<strong>'.BIT_ROOT_PATH.$d.'</strong>\' is not available and we cannot create it automaticalliy.<br />Please execute something like:<br />mkdir -m 777 '.BIT_ROOT_PATH.$d;
			$required[$i]['passed'] = FALSE;
		}
		$i++;
	}
	foreach( $required as $r ) {
		if( !$r['passed'] ) {
			$error = TRUE;
		}
	}

	$i = 0;
	// check extensions
	$php_ext = array(
		'zlib' => '<a href="http://www.zlib.net/">The zlib compression libraries</a> are used to pack and unpack compressed files such as zip files.',
		'gd' => '<a href="http://www.boutell.com/gd/">GD Libraries</a> are used to manipulate images. We use these libraries to create thumbnails and convert images from one format to another. The GD libaries are quite limited and <strong>don\'t support</strong> a number of image formats including <strong>bmp</strong>. If you are planning on uploading and using a lot of images, we recommend you use ImageMagic instead.<br />If you are running Red Hat or Fedora Core, you can try running: yum install php-gd.',
		'imagick' => 'ImageMagick supports a multitude of different image and video formats and <strong>can be used instead of the GD Libraries</strong>. Using these libraries will allow you to upload most image formats without any difficulties. It also requires less memory than the GD Libraries.<br />To find out more about <a class="external" href="http://www.imagemagick.org">ImageMagick</a>, please visit their homepage.
			<dl>
				<dt>*nix</dt>
				<dd>Prebuilt RPMs are available for Fedora and RedHat from <a class="external" href="http://phprpms.sourceforge.net/imagick">phpRPMs</a> or compile a <a class="external" href="http://sourceforge.net/project/showfiles.php?group_id=112092&amp;package_id=139307&amp;release_id=292417">source RPM</a>.</dd>
				<dt>Windows</dt>
				<dd>For information on how to install ImageMagick on Windows, please visit <a class="external" href="http://www.bitweaver.org/wiki/ImageMagick">Install ImageMagick</a>.</dd>
			</dl>',
		'magickwand' => 'MagickWand is an alternative php extension for ImageMagick. please see the ImageMagic documentation for installation instructions.',
		'eAccelerator' => '<a href="http://eaccelerator.net/HomeUk">eAccelerator</a> increases the efficiency of php by caching and optimising queries. Using this extension will greatly increase your servers performance and reduce the memory needed to run bitweaver.',
	);
	foreach( $php_ext as $ext => $note ) {
		$extensions[$i]['note'] = 'The extension <strong>'.$ext.'</strong> is ';
		if( extension_loaded( $ext ) ) {
			$extensions[$i]['passed'] = TRUE;
		} else {
			$extensions[$i]['note'] .= 'not ';
			$extensions[$i]['passed'] = FALSE;
		}
		$extensions[$i]['note'] .= 'available.<br />'.$note;
		$i++;
	}
	foreach( $extensions as $e ) {
		if( !$e['passed'] ) {
			$warning = TRUE;
		}
	}

	$i = 0;
	// recommended php toggles - these don't need explicit explanations on how to rectify them
	// start with special cases
	$recommended[$i] = array( 'Memory Limit','memory_limit','shouldbe' => 'at least 8M','actual' => get_cfg_var( 'memory_limit' ) );
	if( eregi_replace( 'M','',get_cfg_var( 'memory_limit' ) ) > 15 ) {
		$recommended[$i]['passed'] = TRUE;
	} else {
		$recommended[$i]['passed'] = FALSE;
		$gBitSmarty->assign( 'memory_warning', TRUE );
	}

	$i++;
	// now continue with easy toggle checks
	$php_rec_toggles = array(
		array( 'Safe Mode','safe_mode','shouldbe' => 'OFF', ),
		array( 'Display Errors','display_errors','shouldbe' => 'ON' ),
		array( 'File Uploads','file_uploads','shouldbe' => 'ON' ),
		array( 'Magic Quotes GPC','magic_quotes_gpc','shouldbe' => 'ON' ),
		array( 'Magic Quotes Runtime','magic_quotes_runtime','shouldbe' => 'OFF' ),
		array( 'Magic Quotes Sybase','magic_quotes_sybase','shouldbe' => 'OFF' ),
		array( 'Register Globals','register_globals','shouldbe' => 'OFF' ),
		array( 'Output Buffering','output_buffering','shouldbe' => 'OFF' ),
		array( 'Session auto start','session.auto_start','shouldbe' => 'OFF' ),
	);
	foreach( $php_rec_toggles as $php_rec_toggle ) {
		$php_rec_toggle['actual'] = get_php_setting( $php_rec_toggle[1] );
		if( get_php_setting( $php_rec_toggle[1] ) == $php_rec_toggle['shouldbe'] ) {
			$php_rec_toggle['passed'] = TRUE;
		} else {
			$php_rec_toggle['passed'] = FALSE;
		}
		$recommended[] = $php_rec_toggle;
		$i++;
	}

	// settings that are useful to know about
	$php_ini_gets = array(
		array( '<strong>Maximum post size</strong> will restrict the size of files when you upload a file using a form - recommended <strong>8M</strong>.','post_max_size' ),
		array( '<strong>Upload max filesize</strong> is related to maximim post size and will also limit the size of uploads - recommended <strong>8M</strong>.','upload_max_filesize' ),
		array( '<strong>Maximum execution time</strong> is related to time outs in PHP - affects database upgrades and backups - recommended <strong>60</strong>.','max_execution_time' ),
	);
	foreach( $php_ini_gets as $php_ini_get ) {
		$show[] = $php_ini_get[0].'<br />This value is set to <strong>'.ini_get( $php_ini_get[1] ).'</strong>';
	}

	$res['required'] = $required;
	$res['extensions'] = $extensions;
	$res['recommended'] = $recommended;
	$res['show'] = $show;
	return $res;
}

/**
 * get_php_setting
 */
function get_php_setting( $val ) {
	$r = ( ini_get( $val ) == '1' ? 1 : 0 );
	return $r ? 'ON' : 'OFF';
}
?>
