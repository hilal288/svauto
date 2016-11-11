#! /bin/bash

update_web_dir_sums()
{

	echo
	echo "Merging SHA256SUMS files together..."
	
	if pushd $WEB_ROOT_CS_LAB &>/dev/null		; then cat *.sha256 > $BUILD_DATE/SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
        if pushd $WEB_ROOT_CS_RELEASE &>/dev/null	; then cat *.sha256 > $BUILD_DATE/SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
        if pushd $WEB_ROOT_CS &>/dev/null		; then cat *.sha256 > $BUILD_DATE/SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
        if pushd $WEB_ROOT_STOCK_LAB &>/dev/null	; then cat *.sha256 > $BUILD_DATE/SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi
        if pushd $WEB_ROOT_STOCK &>/dev/null		; then cat *.sha256 > $BUILD_DATE/SHA256SUMS &>/dev/null ; rm -f *.sha256 ; popd &>/dev/null ; fi

}
