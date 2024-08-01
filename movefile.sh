#!/bin/bash

source_dir="/home/saikumar/source"
target_dir="/opt/tomcat/webapps/"
TOMCAT_HOME="/opt/tomcat"

function filePermissions() {
	echo "################### File Permissions Done ###################"

	#find /opt/tomcat/ -type d -exec chmod 777 {} \;

	#chmod -R g+w "$TOMCAT_HOME/work/Catalina/localhost"
	
	#chmod -R g+w "$TOMCAT_HOME/logs"
	
	#chmod -R g+w "$TOMCAT_HOME/temp"
	
	#rm -rf "$TOMCAT_HOME/work/Catalina/localhost/"*
	
	#rm -rf "$TOMCAT_HOME/logs/"*
	
	#rm -rf "$TOMCAT_HOME/temp/"*
	
	sudo chmod 777 -R /opt/tomcat/

	cd /opt/tomcat/work/Catalina/localhost/

	rm -r -f *

	cd /opt/tomcat/logs/

	rm -r -f *

	cd /opt/tomcat/temp/

	rm -r -f *
	
	

	echo "Cleared work, logs, and temp directories"
}

function showFilesInTargetDirectory() {
	echo "*************** File Available In Target-Directory Done **************"
	cd "$target_dir" || exit
	ls
}

function stopTomcat() {
	cd "$TOMCAT_HOME/bin" || exit
	./shutdown.sh
	echo "################### Tomcat server stopped. ###################"
}
set -x
function moveFile() {
	CURRENT_DATE="$(date +'%d''%b''%Y')"
	local backup_file="$TOMCAT_HOME/backp/$CURRENT_DATE"

	mkdir -p "$backup_file"

	for source_file in "$source_dir"/*.{war,zip}; do
		if [ -f "$source_file" ]; then
			file_name=$(basename "$source_file")
			particular_file="${file_name%.*}"

			# Source file is a zip
			if [[ "$source_file" == *.zip ]]; then
			
				# Move existing folder to backup_file if it exists
				if [ -d "$target_dir/$particular_file" ]; then
					mv "$target_dir/$particular_file" "$backup_file"
					echo "********** Existing folder $target_dir/$particular_file moved to $backup_file. *************"
				fi

					# Move existing zip file to backup_file if it exists
					if [ -f "$target_dir/$file_name" ]; then
						mv "$target_dir/$file_name" "$backup_file"
						echo "********* Existing zip file $target_dir/$file_name moved to $backup_file. **********"
					fi

				# Copy the zip file to target_dir
				cp "$source_file" "$target_dir"
				echo "************* Zip file copied to $target_dir ********************"

				# Extract the zip file in target_dir
				unzip -o "$target_dir/$file_name" -d "$target_dir"
				echo "************* File extracted to $target_dir ****************"

		                # Move the zip file to backup_file
				mv "$target_dir/$file_name" "$backup_file"
				echo "************** Zip file $target_dir/$file_name moved to $backup_file. ***************"

			else
				# If it's not a zip file
				if [ -f "$target_dir/$file_name" ]; then
					mv "$target_dir/$file_name" "$backup_file"
					echo "*************** Existing file moved from $target_dir to $backup_file. ******************"
				fi

				# Move existing folder to backup_file if it exists
				if [ -d "$target_dir/$particular_file" ]; then
					mv "$target_dir/$particular_file" "$backup_file"
					echo "************** Existing folder $target_dir/$particular_file moved to $backup_file. *****************"
				fi

				# Copy the source file to target_dir
				cp "$source_file" "$target_dir"
				echo "***************** File moved to $target_dir ***************"
			fi
		else
			echo "***************** No files with .war or .zip extension in the source directory. **********************"
		fi
	done
}

function startTomcat() {
	cd "$TOMCAT_HOME/bin" || exit
	./startup.sh
	echo "################### Tomcat server started. ###################"
}

stopTomcat

sleep 5
filePermissions

sleep 5
moveFile

sleep 5
showFilesInTargetDirectory

sleep 5
startTomcat

sleep 5
showFilesInTargetDirectory
set +x
