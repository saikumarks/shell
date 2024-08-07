#!/bin/bash

source_dir="ssh saikumar@192.168.1.94/home/saikumar/source"
target_dir="ssh saikumar@192.168.1.94/opt/tomcat/webapps/"
TOMCAT_HOME="ssh saikumar@192.168.1.94/opt/tomcat"

function filePermissions() {
    echo "################### File Permissions Done ###################"
    
    find /opt/tomcat/ -type d -exec chmod 777 {} \;
    
    chmod -R g+w "$TOMCAT_HOME/work/Catalina/localhost"
    chmod -R g+w "$TOMCAT_HOME/logs"
    chmod -R g+w "$TOMCAT_HOME/temp"
    
    rm -rf "$TOMCAT_HOME/work/Catalina/localhost/"*
    rm -rf "$TOMCAT_HOME/logs/"*
    rm -rf "$TOMCAT_HOME/temp/"*

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

function moveFile() {
    CURRENT_DATE="$(date +'%d''%b''%Y')"
    local backup_file="$TOMCAT_HOME/backp/$CURRENT_DATE"

    mkdir -p "$backup_file"

    echo "Checking for files in $source_dir"
    for source_file in "$source_dir"/*.{war,zip}; do
        echo "Processing $source_file"
        if [ -f "$source_file" ]; then
            file_name=$(basename "$source_file")
            particular_file="${file_name%.*}"
            
            echo "File Name: $file_name"
            echo "Particular File: $particular_file"

            # Source file is a zip
            if [[ "$source_file" == *.zip ]]; then
                if [ -d "$target_dir/$particular_file" ]; then
                    mv "$target_dir/$particular_file" "$backup_file"
                    echo "Existing folder $target_dir/$particular_file moved to $backup_file."
                fi

                if [ -f "$target_dir/$file_name" ]; then
                    mv "$target_dir/$file_name" "$backup_file"
                    echo "Existing zip file $target_dir/$file_name moved to $backup_file."
                fi

                cp "$source_file" "$target_dir"
                echo "Zip file copied to $target_dir"

                unzip -o "$target_dir/$file_name" -d "$target_dir"
                echo "File extracted to $target_dir"

                mv "$target_dir/$file_name" "$backup_file"
                echo "Zip file $target_dir/$file_name moved to $backup_file."
            else
                if [ -f "$target_dir/$file_name" ]; then
                    mv "$target_dir/$file_name" "$backup_file"
                    echo "Existing file moved from $target_dir to $backup_file."
                fi

                if [ -d "$target_dir/$particular_file" ]; then
                    mv "$target_dir/$particular_file" "$backup_file"
                    echo "Existing folder $target_dir/$particular_file moved to $backup_file."
                fi

                cp "$source_file" "$target_dir"
                echo "File moved to $target_dir"
            fi
        else
            echo "No files with .war or .zip extension in the source directory."
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
