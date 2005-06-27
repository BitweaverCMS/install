<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/create_firebird_database.php,v 1.1.2.1 2005/06/27 12:49:50 lsces Exp $
 * @package install
 * @subpackage functions
 */

/**
  V4.22 15 Apr 2004  (c) 2000-2004 John Lim (jlim@natsoft.com.my). All rights reserved.
  Released under both BSD license and Lesser GPL library license. 
  Whenever there is any discrepancy between the two licenses, 
  the BSD license will take precedence.
	
  Set tabs to 4 for best viewing.
  Added by Lester Caine to provide an in-line generation of Firebird(/Interbase) database
  Firebird requires the database to exist before it can be connected to as part of it's 
  security system
  Still need to be extended to allow selection of OS tmp directory, 
  and path to Firebird bin directory 
*/
	function FirebirdCreateDB($host, $user, $pass, $dbalias, $fbpath)
	{
		$sql = 'CREATE DATABASE "'.$host.':'.$dbalias.'"';
    	if (strlen($user) > 0)
        	$sql .= ' USER "'.$user.'"';
        if (strlen($pass) > 0)
            $sql .= ' PASSWORD "'.$pass.'"';
        $sql .= ' PAGE_SIZE = 4096';

//		if ($s_create_charset != 'NONE') {
			// NONE is the default character set
//			$sql .= ' DEFAULT CHARACTER SET '.$s_create_charset;
//		}

    	$sql .= ';';

    	$sql = str_replace("\r\n", "\n", $sql);
	    $sql .= "\n";
    	$tmp_name = $_ENV["TMP"].'/'.uniqid('').'.sql';

    	if ($fp = fopen ($tmp_name, 'a')) {
        	fwrite($fp, $sql);
        	fclose($fp); 
    	}

	    $command =  sprintf('"%s" -i %s', $fbpath, $tmp_name );
    	$result = exec($command);
	}

?>