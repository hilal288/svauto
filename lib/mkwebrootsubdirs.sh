#! /bin/bash

mkwebrootsubdirs()
{

	# Web Public directory details
	
	WEB_ROOT_STOCK_LAB=$WEB_ROOT_STOCK_MAIN/$BUILD_DATE/lab
	WEB_ROOT_STOCK_RELEASE=$WEB_ROOT_STOCK_MAIN/$BUILD_DATE/to-be-released
	WEB_ROOT_STOCK_RELEASE_LAB=$WEB_ROOT_STOCK_MAIN/$BUILD_DATE/to-be-released/lab
	
	WEB_ROOT_CS_LAB=$WEB_ROOT_CS_MAIN/$BUILD_DATE/lab
	WEB_ROOT_CS_RELEASE=$WEB_ROOT_CS_MAIN/$BUILD_DATE/to-be-released
	WEB_ROOT_CS_RELEASE_LAB=$WEB_ROOT_CS_MAIN/$BUILD_DATE/to-be-released/lab
	
	
	# Creating the Web directory structure:
	mkdir -p $WEB_ROOT_STOCK_LAB
	mkdir -p $WEB_ROOT_STOCK_RELEASE
	
	mkdir -p $WEB_ROOT_CS_LAB
	mkdir -p $WEB_ROOT_CS_RELEASE

}
