#!/bin/bash
#	echo "Usage: $0 [module [BRANCH [sfuser]]]"
#	echo "(Note: If sfuser is not supplied, 'bitweaver@bitweaver.cvs.sourceforge.net' will be assumed )"
#	exit 1
export CVS_RSH=ssh

if [ $1 = '--help' ] ; then
	echo "Usage: $0 [module [BRANCHNAME [sfuser [builddir]]]]"
	echo "(Note: If sfuser is not supplied, 'bitweaver@bitweaver.cvs.sourceforge.net' will be assumed )"
	exit 1
elif [ -z $1 ] ; then
	MODULE="bitweaver"
else
	MODULE=$1
fi

if [ -z $2 ] ; then
	BRANCH="-r HEAD"
else
	BRANCH="-r $2"
fi

if [ -z $3 ] ; then
	SFUSER=bitweaver
else
	SFUSER=$3
fi

if [ -z $4 ] ; then
	BUILDDIR=$1
else
	BUILDDIR=$4
fi



fname=bitweaver_$1\_wb_`date +"%Gweek%V"`

mkdir -p "/tmp/$fname/"
cd "/tmp/$fname/"
echo "cvs -qz5 -d :ext:$SFUSER@bitweaver.cvs.sourceforge.net:/cvsroot/bitweaver/ export -d $BUILDDIR $BRANCH $MODULE"
cvs -qz5 -d :ext:$SFUSER@bitweaver.cvs.sourceforge.net:/cvsroot/bitweaver/ export -d $BUILDDIR $BRANCH $MODULE
cd "/tmp/$fname/"

if [ $MODULE = 'bitweaver' ] ; then
	mv "$BUILDDIR/favicon.ico.sample" "$BUILDDIR/favicon.ico"
	if [ -d "$BUILDDIR/phpbb" ] ; then
		touch "$BUILDDIR/phpbb/config.php"
	fi
	if [ -d "$BUILDDIR/kernel" ] ; then
		touch "$BUILDDIR/config/kernel_config.php"
	fi
	if [ -d "$BUILDDIR/themes" ] ; then
		mkdir "$BUILDDIR/themes/force"
	fi
	if [ -d "$BUILDDIR/languages" ] ; then
		echo "Export languages from database to files"
		php -d display_errors=Off ~/bin/export_all_languages.php "`pwd`/$BUILDDIR/languages/lang"
	fi
fi

echo Create archive of downloaded files
zip -rq $fname.zip $BUILDDIR
echo Move archive to: $HOME/$fname.zip
mv $fname.zip $HOME/$fname.zip
echo Remove all temporary files
rm -Rf "/tmp/$fname/"
