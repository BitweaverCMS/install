<?php
/**
 * @version $Header: /cvsroot/bitweaver/_bit_install/install_version.php,v 1.3 2009/01/28 10:48:35 squareing Exp $
 * @package install
 * @subpackage functions
 */

// assign next step in installation process
$gBitSmarty->assign( 'next_step', $step );

// check if database version is up to date
if( version_compare( $gBitSystem->getBitVersion(), $gBitSystem->getVersion(), '==' )) {
	$upToDate = TRUE;
	$gBitSmarty->assign( 'upToDate', $upToDate );
}

// updating to version 2.1.0-beta
if( version_compare( '2.1.0-beta', $gBitSystem->getVersion(), '>' )) {
	// get a list of all groups and their permissions
	$listHash = array(
		'only_root_groups' => TRUE,
		'sort_mode' => !empty( $_REQUEST['sort_mode'] ) ? $_REQUEST['sort_mode'] : 'group_name_asc'
	);
	$allGroups = $gBitUser->getAllGroups( $listHash );
	$allPerms = $gBitUser->getGroupPermissions( $_REQUEST );

	$gBitSmarty->assign( 'allPerms', $allPerms );
	$gBitSmarty->assign( 'allGroups', $allGroups );
	$gBitSmarty->assign( 'version_210beta', TRUE );

	$versionUpdate = TRUE;

	// deal with assigning permissions to various groups
	if( !empty( $_REQUEST['fix_version_210beta'] )) {
		foreach( array_keys( $allGroups ) as $groupId ) {
			foreach( array_keys( $allPerms ) as $perm ) {
				if( !empty( $_REQUEST['perms'][$groupId][$perm] )) {
					$gBitUser->assignPermissionToGroup( $perm, $groupId );
				} else {
					$gBitUser->removePermissionFromGroup( $perm, $groupId );
				}
			}
		}
	}
}

// ===================== Update version to current one =====================
// Only update the version when the form has been submitted
if( !empty( $_REQUEST['update_version'] )) {
	if( !empty( $upToDate ) || !empty( $_REQUEST['skip'] )) {
		// if we're already up to date, we'll simply move on to the next page
		bit_redirect( $_SERVER['PHP_SELF']."?step=".++$step );
	} else {
		// set the version of bitweaver in the database
		if( $gBitSystem->storeVersion( NULL, $gBitSystem->getBitVersion() )) {
			// display the confirmation page
			$gBitSmarty->assign( 'next_step', $step + 1 );
			$app = '_done';
		}
	}
}
?>
