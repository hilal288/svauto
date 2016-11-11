#! /bin/bash

update_web_dir_symlink()
{

	echo
	echo "Updating symbolic link \"current\" to point to \"$BUILD_DATE\"..."
	
	pushd $WEB_ROOT_CS_MAIN &>/dev/null
	
	rm -f current
	ln -s $BUILD_DATE current
	
	popd &>/dev/null

}
