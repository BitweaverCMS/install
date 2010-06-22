<?php
/**
 * @version $Header$
 * @package install
 * @subpackage functions
 */

/**
 * create_config
 */

/**
 * create configuration file
 *
 * @param string  $pParamHash['gBitDbType']
 * @param string  $pParamHash['gBitDbHost']
 * @param string  $pParamHash['gBitDbUser']
 * @param string  $pParamHash['gBitDbPassword']
 * @param string  $pParamHash['gBitDbName']
 * @param numeric $pParamHash['gBitDbCaseSensitivity']
 * @param string  $pParamHash['bit_db_prefix']
 * @param string  $pParamHash['bit_root_url']
 * @param boolean $pParamHash['auto_bug_submit']
 * @param boolean $pParamHash['is_live']
 * @access public
 * @return void
 */
function create_config( $pParamHash ) {
	// assign values to their keys
	extract( $pParamHash );

	$bit_db_prefix  = empty( $bit_db_prefix ) ? "" : $bit_db_prefix;

	$gBitDbType     = addslashes( $gBitDbType );
	$gBitDbHost     = addslashes( $gBitDbHost );
	$gBitDbUser     = addslashes( $gBitDbUser );
	$gBitDbPassword = addslashes( $gBitDbPassword );
	$gBitDbName     = addslashes( $gBitDbName );
	$bit_db_prefix  = addslashes( $bit_db_prefix );

	if( preg_match( '/\./', $bit_db_prefix ) ) {
		if( $gBitDbType == 'mysql' ) {
			$bit_db_prefix = preg_replace( '/[`.]/', '', $bit_db_prefix );
		} elseif( !preg_match( '/`\.`/', $bit_db_prefix ) ) {
			$bit_db_prefix = preg_replace( '/\./', '`.`', $bit_db_prefix );
		}
	}

	$config_file = empty( $_SERVER['CONFIG_INC'] ) ? '../config/kernel_config.php' : $_SERVER['CONFIG_INC'];

	// We can't call clean_file_path here even though we would like to.
	$config_file = ( strpos( $_SERVER["SERVER_SOFTWARE"],"IIS" ) ? str_replace( "/", "\\", $config_file ) : $config_file );

	$fw = fopen( $config_file, 'w' );
	if( isset( $fw )) {
		$filetowrite = "<?php
// Copyright (c) 2006, bitweaver.org
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE.

// The following line is required and should not be altered
global \$gBitDbType, \$gBitDbHost, \$gBitDbUser, \$gBitDbPassword, \$gBitDbName, \$gBitDbCaseSensitivity, \$smarty_force_compile, \$gDebug, \$gPreScan;


             /******************************************************\
              ***************   Database settings   **************** 
             \******************************************************/

// You can choose between different Database abstraction layers. Currently we support:
//    adodb          ADODB
//                   this is the default setting and is bundled with bitweaver
//    pear           PEAR::DB
//                   when using this, you can even remove the util/adodb directory
\$gBitDbSystem = \"adodb\";


// bitweaver can store its data in multiple different back-ends. Currently we
// support MySQL, MSSQL, Firebird, Sybase, PostgreSQL and Oracle.  Enter the
// hostname where your database lives, and the username and password you use to
// connect to it.
//
// You must specify the name of a database that already exists. bitweaver will not
// create the database for you, because it's very difficult to do that in a
// reliable, database-neutral fashion. The user that you use should have the
// following permissions:
//
//    SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP
//
// The possible database types that we support are:
//    mysql          Standard MySQL
//    mysqli         New MySQL driver
//    sqlite         SQLLite
//    mssql          MS-SQL (experimental)
//    postgres       PostgreSQL 7.x
//    oci8po         Oracle (9i and newer)
//    firebird       FireBird
//    sybase         Sybase
\$gBitDbType    = \"$gBitDbType\";

// Hostname or IP for your database.
// Some examples:
//    'localhost' if you are running the database on the same machine as bitweaver
//    If you use Oracle, insert your TNS Name here
//    If you use SQLite, insert the path and filename to your database file
\$gBitDbHost  = \"$gBitDbHost\";

// Database username
\$gBitDbUser  = \"$gBitDbUser\";

// Database password
\$gBitDbPassword  = \"$gBitDbPassword\";

// Database name
\$gBitDbName   = \"$gBitDbName\";

// Database field case default
\$gBitDbCaseSensitivity = \"$gBitDbCaseSensitivity\";

// This prefix will be prepended to the begining of every table name to allow
// multiple independent installs to share a single database. By ending the prefix
// with a '.' (period) you can use a schema in systems that support it. Backticks
// '`' around the '.' are required if present. A schema example is: 'bit`.`'
define( 'BIT_DB_PREFIX', '$bit_db_prefix' );


             /******************************************************\
              *************** Environment Settings  **************** 
             \******************************************************/

// Setting IS_LIVE to TRUE will let the application know that this site is a live
// production site and is not used for testing purposes.  This will prevent any
// nasty error pages from appearing and will redirect the user to a 'nicer' error
// page. Errors should still show up in your error logs. Please use these when
// submitting bugs to http://sourceforge.net/tracker/?group_id=141358&atid=749176
define( 'IS_LIVE', $is_live );


// if you set AUTO_BUG_SUBMIT to TRUE bitweaver will automatically email the team
// with details regarding the error.  Alternatively you can submit bugs to
// http://sourceforge.net/tracker/?group_id=141358&atid=749176 which will probably
// get processed faster since more people have access to these.
define( 'AUTO_BUG_SUBMIT', $auto_bug_submit );


// This is the path from the server root to your bitweaver location.  i.e. if you
// access bitweaver as 'http://MyServer.com/applications/new/wiki/index.php' you
// should enter '/applications/new/'
define( 'BIT_ROOT_URL', '$bit_root_url' );


// Here you can set the valid base URI for your site. If you do not set this, we
// will automatically determine a working value. You can force the use of a 
// specific URI here by putting something like: 'http://myfiles.example.com'
//define( 'BIT_ROOT_URI', 'http://myfiles.example.com' );


// Add default STORAGE_HOST_URI for optionally splitting off storage files to 
// separate host. This will allow you to serve thumbnails and other files from 
// a different server to your web server. If this is not set, we will use 
// BIT_ROOT_URI instead. Put something like: 'http://myfiles.example.com'
//define( 'STORAGE_HOST_URI', 'http://myfiles.example.com' );


// This allows you to set a custom path to your PHP tmp directory - used for ADODB
// caching if active, and other stuff This is usually only needed in very
// restrictive hosting environments.
//\$gTempDir = '/path/to/private/directory';


// \$gPreScan can be used to specify the order in which packages are scanned by
// the kernel.  In the example provided below, the kernel package is processed
// first, followed by the users and liberty packages.  Any packages not specified
// in \$gPreScan are processed in the traditional order
//\$gPreScan = array( 'kernel', 'storage', 'liberty', 'themes', 'users' );

// \$gThumbSizes defines the image thumbnail sizes that will be autogenerated when
// images are uploaded and processed. The example provided shows the default sizes
// that are used. You can add as many sizes as you want if you override the default. 
/*
\$gThumbSizes = array(
	'icon'   => array( 'width' => 48,  'height' => 48 ),
	'avatar' => array( 'width' => 100, 'height' => 100 ),
	'small'  => array( 'width' => 160, 'height' => 120 ),
	'medium' => array( 'width' => 400, 'height' => 300 ),
	'large'  => array( 'width' => 800, 'height' => 600 ),
);
*/";

		if( substr( PHP_OS, 0, 3 ) == 'WIN' ) {
			$filetowrite .= "


// Insert the absolute path to your php magic database. This is required for 
// us to check and verify the mime type of uploaded files. This setting is only 
// required on windows machines.
//define( 'PHP_MAGIC_PATH', 'C:\\Program Files\\PHP\\extras\\magic.mime' );";
		}

		$filetowrite .= "


             /******************************************************\
              ***************   Debugging Options   **************** 
             \******************************************************/

// If you wish to force compiling of every page, you can set the next setting to
// TRUE. this will, however, severly impact performance since every page that is
// generated is generated afresh and the cache is recreated every time.
\$smarty_force_compile = FALSE;


// Setting TEMPLATE_DEBUG = TRUE will output <!-- <called templates> --> in your
// templates, which will allow you to track all used templates in the HTML source
// of the page. This will also disable stripping of whitespace making it easier to
// read the templates. You will only see the effect of the strip changes by
// clearing out your cache or setting \$smarty_force_compile = TRUE;
// Note: be sure to set this to FALSE and clear out the cache once done since it
//       will increase the page size by at least 10%.
//define( 'TEMPLATE_DEBUG', TRUE );

// If you want to go a step further with template debugging then this enables
// smarty's debugging console.  A popup with a dump of all of the vars the
// template(s) have been passed.
\$smarty_debugging = FALSE;


// This statement will enable you to view all database queries made
//\$gDebug = TRUE;


// This will turn on ADODB performance monitoring and log all queries. This should
// not be enabled except when doing query analysis due to an overall performance
// drop.  see kernel/admin/db_performance.php for statistics
//define( 'DB_PERFORMANCE_STATS', TRUE );

?>";
		fwrite( $fw, $filetowrite );
		fclose( $fw );
	} else {
		print "UNABLE TO WRITE TO ".realpath( $config_file );
	}
}

?>
