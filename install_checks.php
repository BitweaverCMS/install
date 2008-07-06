<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_checks.php,v 1.34 2008/07/06 06:17:01 wolff_borg Exp $
 * @package install
 * @subpackage functions
 * @author xing
 */

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step + 1 );

$check_settings = check_settings();

$gBitSmarty->assign( "error", $error );
$gBitSmarty->assign( "warning", $warning );

foreach( $check_settings as $type => $checks ) {
	$gBitSmarty->assign( $type, $checks );
}

if( !isset( $_SERVER['HTTP_REFERER'] ) ) {
	$gBitSmarty->assign( "http_referer_error", TRUE );
	$error = TRUE;
}

/**
 * check_settings
 */
function check_settings() {
	global $gBitSmarty, $error, $warning;
	$config_file = clean_file_path( empty( $_SERVER['CONFIG_INC'] ) ? KERNEL_PKG_PATH.'config_inc.php' : $_SERVER['CONFIG_INC'] );

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
		$required[$i]['note'] = 'The bitweaver configuration file is available and the file is writeable:<br /><code>'.$config_file.'</code>';
		$required[$i]['passed'] = TRUE;
	} elseif( @file_exists( $config_file ) && !@bw_is_writeable( $config_file ) ) {
		$required[$i]['note'] = 'The bitweaver configuration file is available but the file is not writeable. Please execute something like:<br /><code>chmod 777 '.$config_file.'</code>';
		$required[$i]['passed'] = FALSE;
	} else {
		$required[$i]['note'] = 'The bitweaver configuration file is not available. Please execute something like:<br /><code>touch '.$config_file.';<br />chmod 777 '.$config_file.'</code>';
		$required[$i]['passed'] = FALSE;
	}
	$i++;

	$dir_check = array(
		'storage' => defined( 'STORAGE_PKG_PATH' ) ? STORAGE_PKG_PATH : BIT_ROOT_PATH.'storage',
		'temp' => defined( 'TEMP_PKG_PATH' ) ? TEMP_PKG_PATH : BIT_ROOT_PATH.'temp',
	);
	foreach( $dir_check as $name => $d ) {
		// final attempt to create the required directories
		@mkdir( $d,0644 );
		if( @is_dir( $d ) && bw_is_writeable( $d ) ) {
			$required[$i]['note'] = "The $name directory is available and it is writeable.<br /><code>$d</code>";
			$required[$i]['passed'] = TRUE;
		} elseif( @is_dir( $d ) && !bw_is_writeable( $d ) ) {
			$required[$i]['note'] = "The $name directory is available but it is not writeable.<br />Please execute something like:<br /><code>chmod -R 777 $d</code>";
			$required[$i]['passed'] = FALSE;
		} else {
			$required[$i]['note'] = "The $name directory is not available and we cannot create it automaticalliy.<br />Please execute something like:<br /><code>mkdir -m 777 $d</code>";
			$required[$i]['passed'] = FALSE;
		}
		$i++;
	}
	foreach( $required as $r ) {
		if( !$r['passed'] ) {
			$error = TRUE;
		}
	}

	// check extensions
	$php_ext = array(
		'zlib'         => '<a href="http://www.zlib.net/">The zlib compression libraries</a> are used to pack and unpack compressed files such as zip files.',
		'gd'           => '<a href="http://www.boutell.com/gd/">GD Libraries</a> are used to manipulate images. We use these libraries to create thumbnails and convert images from one format to another. The GD libaries are quite limited and <strong>don\'t support</strong> a number of image formats including <strong>bmp</strong>. If you are planning on uploading and using a lot of images, we recommend you use one of the other image processors.<br />If you are running Red Hat or Fedora Core, you can try running: yum install php-gd.',
		'imagick'      => 'ImageMagick supports a multitude of different image and video formats and <strong>can be used instead of the GD Libraries</strong>. Using these libraries will allow you to upload most image formats without any difficulties. For installation help, please view our online documentation: <a class="external" href="http://www.bitweaver.org/wiki/ImageMagick">ImageMagick and MagickWand installation instructions</a> or visit the <a class="external" href="http://www.imagemagick.org">ImageMagick</a> homepage.',
		'magickwand'   => 'MagickWand the newer php extension for ImageMagick. For installation help, please view our online documentation: <a class="external" href="http://www.bitweaver.org/wiki/ImageMagick">ImageMagick and MagickWand installation instructions</a> or visit the <a class="external" href="http://www.imagemagick.org">ImageMagick</a> homepage.',
		'eAccelerator' => '<a href="http://eaccelerator.net/HomeUk">eAccelerator</a> increases the efficiency of php by caching and optimising queries. Using this extension will greatly increase your servers performance and reduce the memory needed to run bitweaver.',
		'ffmpeg'       => '<a href="http://ffmpeg-php.sourceforge.net/">ffmpeg-php</a> is an extension that will allow you to better process uploaded videos. This extension requires ffmpeg to be installed as well.',
	);
	foreach( $php_ext as $ext => $note ) {
		$extensions[$ext]['note'] = 'The extension <strong>'.$ext.'</strong> is ';
		if( extension_loaded( $ext ) ) {
			$extensions[$ext]['passed'] = TRUE;
		} else {
			$extensions[$ext]['note'] .= 'not ';
			$extensions[$ext]['passed'] = FALSE;
		}
		$extensions[$ext]['note'] .= 'available.<br />'.$note;
	}

	// disable one of the imagick / magickwand warnings
	if( $extensions['magickwand']['passed'] == TRUE && $extensions['imagick']['passed'] == FALSE ) {
		unset( $extensions['imagick'] );
	} elseif( $extensions['imagick']['passed'] == TRUE && $extensions['magickwand']['passed'] == FALSE ) {
		unset( $extensions['magickwand'] );
	}

	// make sure we show the worning flag if there is a need for it
	foreach( $extensions as $info ) {
		if( !$info['passed'] ) {
			$warning = TRUE;
		}
	}

	// output has to be verbose that we can catch the output of the shell_exec
	// using --help, -h or --version should make applications output something to stdout - this is no guarantee though, bunzip2 doesn't...
	$execs = array(
		'tar' => array(
			'command'      => 'tar -xvf',
			'dest_params'  => '-C',
			'testfile'     => 'test.tar',
			'note'         => '<strong>Tarball</strong> is a common archiving format on Linux and <a href="http://www.gnu.org/software/tar/">tar</a> is used to extract .tar files.',
		),
		'bzip2' => array(
			'command'      => 'tar -jvxf',
			'dest_params'  => '-C',
			'testfile'     => 'test.tar.bz2',
			'note'         => '<strong>Bzip</strong> is a common compression format on Linux and <a href="http://www.bzip.org/">bzip2</a> is used to extract .bz2 and in combination with tar .tar.bz2 file.',
		),
		'gzip' => array(
			'command'      => 'tar -zvxf',
			'dest_params'  => '-C',
			'testfile'     => 'test.tar.gz',
			'note'         => '<strong>Gzip</strong> is a common compression format on Linux and <a href="http://www.gnu.org/software/gzip/gzip.html">gzip</a> is used to extract .gz and in combination with tar .tar.gz file.',
		),
		'unzip' => array(
			'command'      => 'unzip -v',
			'dest_params'  => '-d',
			'testfile'     => 'test.zip',
			'note'         => '<strong>Zip</strong> is a common compression format on all operating systems and <a href="http://www.info-zip.org/">unzip</a> is used to extract .zip files.',
		),
		'unrar' => array(
			'command'      => 'unrar x',
			'dest_params'  => '',
			'testfile'     => 'test.rar',
			'note'         => '<strong>Rar</strong> is a common compression format on all operating systems and <a href="http://www.rarlab.com/rar_add.htm">unrar</a> is used to extract .rar files.',
		),
		'gs' => array(
			'command'      => 'gs --version',
			'note'         => '<a href="http://www.cs.wisc.edu/~ghost/">GhostScript</a> is an interpreter for the PostScript language and for PDF and is used to create PDF previews when uploading PDFs to fisheye. If you do not have this installed, previews of PDF files will not be generated on upload.<br />If you have difficulties with GhostScript, please try installing a different version. We have successfully tested versions: <strong>7.5, 8.15.4, 8.5, 8.54</strong> and we have had difficulties with version <strong>8.1</strong>',
			'result'       => 'Your version of GhostScript: ',
		),
		'graphviz' => array(
			'command'      => 'dot -V 2>&1',
			'note'         => '<a href="http://www.graphviz.org/">Graphviz</a> is a way of representing structural information as diagrams of abstract graphs and networks and visualizing that representation. It is used by the {graphviz} liberty plugin and you only need to install it if you intend to enable that plugin.<br /><em>The Pear::Image_Graphviz plugin is required as well.</em>',
			'result'       => 'Your version of Graphviz: ',
		),
		'ffmpeg' => array(
			'command'      => 'ffmpeg 2>&1',
			'note'         => '<a href="http://ffmpeg.mplayerhq.hu/">ffmpeg</a> is a hyper fast video and audio encoder that supports many common formats. If you are planning on uploading video and audio files, we recommend that you install this application.',
		),
//		'unstuff' => array(
//			'params'       => '-xf',
//			'testfile'     => 'test.tar',
//			'note'         => 'Unstuff is a common compression format on Mac and <strong>unstuff</strong> is used to extract .sit files.',
//		),
	);
	foreach( $execs as $exe => $app ) {
		$executables[$exe]['note'] = 'The application <strong>'.$exe.'</strong> is ';
		if( !empty( $app['testfile'] ) && is_readable( $file = INSTALL_PKG_PATH.'testfiles/'.$app['testfile'] )) {
			$command = $app['command'].' "'.$file.'" '.$app['dest_params'].' "'.TEMP_PKG_PATH.'"';
		} else {
			$command = $app['command'];
		}

		if( get_php_setting( 'safe_mode' ) == 'OFF' && $shellResults[$exe] = shell_exec( $command )) {
			@unlink( TEMP_PKG_PATH.'test.txt' );
			$executables[$exe]['passed'] = TRUE;
		} else {
			$executables[$exe]['note'] .= 'not ';
			$executables[$exe]['passed'] = FALSE;
		}
		$executables[$exe]['note'] .= 'available.<br />'.$app['note'];
		if( !empty( $app['result'] ) && !empty( $shellResults[$exe] )) {
			$executables[$exe]['note'] .= '<br />'.$app['result'].'<strong>'.$shellResults[$exe].'</strong>';
		}
	}


	// PEAR checks
	$pears = array(
		'PEAR' => array(
			'path'            => 'PEAR.php',
			'note'            => 'This check indicates if PEAR is installed and available. To make use of PEAR extensions, you need to make sure that PEAR is installed and the include_path is set in your php.ini file.',
		),
		'Auth' => array(
			'path'            => 'Auth/Auth.php',
			'note'            => 'This will allow you to use the PEAR::Auth package to authenticate users on your website.',
			'install_command' => 'pear install --onlyreqdeps Auth;',
		),
		'Text_Wiki' => array(
			'path'            => 'Text/Wiki.php',
			'note'            => 'Having PEAR::Text_Wiki installed will make more wiki format parsers available. The following parsers will be recognised and used: Text_Wiki_BBCode, Text_Wiki_Cowiki, Text_Wiki_Creole, Text_Wiki_Doku, Text_Wiki_Mediawiki, Text_Wiki_Tiki',
			'install_command' => 'pear install --onlyreqdeps Text_Wiki_BBCode Text_Wiki_Cowiki Text_Wiki_Creole Text_Wiki_Doku Text_Wiki_Mediawiki Text_Wiki_Tiki;',
		),
		'Text_Diff' => array(
			'path'            => 'Text/Diff.php',
			'note'            => 'PEAR::Text_Diff makes inline diffing of content available.',
			'install_command' => 'pear install --onlyreqdeps Text_Diff;',
		),
		'Image_Graphviz' => array(
			'path'            => 'Image/GraphViz.php',
			'note'            => 'Pear::Image_Graphviz makes the {graphviz} plugin available. With it you can draw maps of how your wiki pages are linked to each other. This can be used for informational purposes or a site-map.<br /><em>It also requires the application graphviz to be installed as well.</em>',
			'install_command' => 'pear install --onlyreqdeps Image_Graphviz;',
		),
		'HTMLPurifier' => array(
			'path'            => 'HTMLPurifier.php',
			'note'            => 'HTMLPurifier is an advanced system for defending against Cross Site Scripting (XSS) attacks and ensuring that all code on your site is standards compliant. It is highly recommended if you are going to allow HTML submission to your site. It is not required if you are only going to use a wiki format like tikiwiki or bbcode. You also need to enable it in the liberty plugins administration after installation. See <a class="external" href="http://www.bitweaver.org/wiki/HTMLPurifier">http://www.bitweaver.org/wiki/HTMLPurifier</a> and <a class = "external" href = "http: // htmlpurifier.org">http://htmlpurifier.org</a> for more information.',
			'install_command' => 'pear channel-discover htmlpurifier.org;<br />pear install hp/HTMLPurifier;',
		),
		'HTTP_Download' => array(
			'path'            => 'HTTP/Download.php',
			'note'            => 'Treasury - the file manager of bitweaver - can make use of PEAR::HTTP_Download to provide more reliable downloads and download resume support when using a download manager.',
			'install_command' => 'pear install --alldeps HTTP_Download;',
		),
	);

	foreach( $pears as $pear => $info ) {
		if( $pear == 'PEAR' ) {
			$pearexts[$pear]['note'] = '<strong>'.$pear.'</strong> is ';
		} else {
			$pearexts[$pear]['note'] = 'The extension <strong>PEAR::'.$pear.'</strong> is ';
		}

		if( @include_once( $info['path'] )) {
			$pearexts[$pear]['passed'] = TRUE;
		} else {
			$pearexts[$pear]['note'] .= 'not ';
			$pearexts[$pear]['passed'] = FALSE;
		}

		$pearexts[$pear]['original_note'] = $info['note'];
		$pearexts[$pear]['note'] .= 'available.<br />';
		$pearexts[$pear]['note'] .= $info['note'];

		if( !empty( $info['install_command'] ) && $pearexts[$pear]['passed'] == FALSE ) {
			$pearexts[$pear]['note'] .= '<br /><em>Install using this command:</em><br /><code>'.$info['install_command'].'</code>';
		}
	}

	$i = 0;
	// recommended php toggles - these don't need explicit explanations on how to rectify them
	// start with special cases
	$recommended[$i] = array( 'Memory Limit','memory_limit','shouldbe' => 'at least 16M', 'actual' => get_cfg_var( 'memory_limit' ) );
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
		array( 'Magic Quotes GPC','magic_quotes_gpc','shouldbe' => 'OFF' ),
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
		array( '<strong>Maximum post size</strong> will restrict the size of files when you upload a file using a form<br />recommended at least <strong>8M</strong>.', 'post_max_size' ),
		array( '<strong>Upload max filesize</strong> is related to maximim post size and will also limit the size of uploads<br />recommended at least <strong>8M</strong>.', 'upload_max_filesize' ),
		array( '<strong>Maximum execution time</strong> is related to time outs in PHP - affects database upgrades and backups<br />recommended <strong>60</strong>.', 'max_execution_time' ),
	);
	foreach( $php_ini_gets as $php_ini_get ) {
		$value = ini_get( $php_ini_get[1] );
		if( $value == 1 ) {
			$value = "On";
		} elseif( $value == 0 ) {
			$value = "Off";
		}

		$show[$php_ini_get[1]] = $php_ini_get[0]."<br /><strong>{$php_ini_get[1]}</strong> is set to <strong>$value</strong>";
	}

	$res['required']    = $required;
	$res['extensions']  = $extensions;
	$res['executables'] = $executables;
	$res['pearexts']    = $pearexts;
	$res['recommended'] = $recommended;
	$res['show']        = $show;
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
