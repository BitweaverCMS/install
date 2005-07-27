<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/create_config_inc.php,v 1.3.2.2 2005/07/27 13:21:06 spiderr Exp $
 * @package install
 * @subpackage functions
 */

/**
 * create_config
 */
function create_config($gBitDbType,$gBitDbHost,$gBitDbUser,$gBitDbPassword,$gBitDbName,$bit_db_prefix="",$root_url_bit,$auto_bug_submit='FALSE') {
	$config_file = empty($_SERVER['CONFIG_INC']) ? '../kernel/config_inc.php' : $_SERVER['CONFIG_INC'];
	// We can't call clean_file_path here even though we would like to.
	$config_file = (strpos($_SERVER["SERVER_SOFTWARE"],"IIS") ? str_replace( "/", "\\", $config_file) : $config_file);

	$gBitDbType=addslashes($gBitDbType);
	$gBitDbHost=addslashes($gBitDbHost);
	$gBitDbUser=addslashes($gBitDbUser);
	$gBitDbPassword=addslashes($gBitDbPassword);
	$gBitDbName=addslashes($gBitDbName);
	$bit_db_prefix=addslashes($bit_db_prefix);

  	if( preg_match( '/\./', $bit_db_prefix ) ) {
		if( $gBitDbType == 'mysql' ) {
			$bit_db_prefix=preg_replace( '/[`.]/', '', $bit_db_prefix );
		} elseif( !preg_match( '/`\.`/', $bit_db_prefix ) ) {
			$bit_db_prefix=preg_replace( '/\./', '`.`', $bit_db_prefix );
		}
	}

	$fw = fopen($config_file, 'w' );
	if( isset( $fw ) ) {
		$filetowrite="<?php
// +----------------------------------------------------------------------+
// | Copyright (c) 2004, bitweaver.org
// +----------------------------------------------------------------------+
// | All Rights Reserved. See copyright.txt for details and a complete list of authors.
// | Licensed under the GNU LESSER GENERAL PUBLIC LICENSE. See license.txt for details
// +----------------------------------------------------------------------+
// The following line is required and should not be altered
global \$gBitDbType, \$gBitDbHost, \$gBitDbUser, \$gBitDbPassword, \$gBitDbName, \$smarty_force_compile, \$gDebug, \$gPreScan;


// bitweaver can store its data in multiple different back ends. Currently we
// support MySQL, MSSQL, Firebird, Sybase, PostgreSQL and Oracle.
// Enter the hostname where your database lives, and the username and
// password you use to connect to it.
//
// You must specify the name of a database that already exists. bitweaver will
// not create the database for you, because it's very difficult to do that in
// a reliable, database-neutral fashion. The user that you use should have
// the following permissions:
//
//    SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, DROP
//
// The possible database types that we support are:
//    mysql          Standard MySQL
//    sqlite         SQLLite
//    mssql          MS-SQL (experimental)
//    postgres          PostgreSQL 7.x
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


// This prefix will be prepended to the begining of every table name to allow multiple
// independent installs to share a single database. By ending the prefix with a '.' (period)
// you can use a schema in systems that support it. backticks '`' around the '.' are required if present
// a schema example is: 'bit`.`'
define( 'BIT_DB_PREFIX', '$bit_db_prefix' );


// This is the path from the server root to your bitweaver location.
// i.e. if you access bitweaver as 'http://MyServer.com/applications/new/wiki/index.php'
// you should enter '/applications/new/'
define( 'BIT_ROOT_URL', '$root_url_bit' );


// If you wish to force compiling of every page, you can set the next setting to
// TRUE. this will, however, severly impact performance since every page that is
// generated is generated afresh and the cache is recreated every time.
\$smarty_force_compile = FALSE;


// This statement will enable you to view all database queries made
//\$gDebug = TRUE;


// This allows you to set a custom path to your PHP tmp directory - used for ADODB caching if active, and other stuff
// This is usually only needed in very restrictive hosting environments.
//\$gTempDir = '/path/to/private/directory';


// This will turn on ADODB performance monitoring and log all queries. This should
// not be enabled except when doing query analysis due to an overall performance drop.
// see kernel/admin/db_performance.php for statistics
//define( 'DB_PERFORMANCE_STATS', TRUE );


// \$gPreScan can be used to specify the order in which packages are scanned by the kernel.
// In the example provided below, the kernel package is processed first, followed by the users and liberty packages.
// Any packages not specified in \$gPreScan are processed in the traditional order
//\$gPreScan = array( 'kernel', 'users', 'liberty' );


// if you set AUTO_BUG_SUBMIT to TRUE, the application will know that this site is running live and is not used for testing purposes.
// This will prevent any horrible error pages from appearing and will redirect the user to a 'nicer' error page and
// will automatically email the team with details regarding the error.
// Bugs added to http://www.sourceforge.net will get processed faster since more people have access to these.
define( 'AUTO_BUG_SUBMIT', $auto_bug_submit );

?>";
        fwrite( $fw, $filetowrite );
		fclose( $fw );
	} else {
		print "UNABLE TO WRITE TO ".realpath($config_file);
	}
}

?>
