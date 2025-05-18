#!/bin/bash

# Set variables
MOUNT_POINT="/mnt/datastore"
CIFS_PATH="//cmvm.datastore.ed.ac.uk/cmvm/sbms/groups/CDBS_SIDB_storage/NolanLab/ActiveProjects"

# Create mount point if it doesn't exist
sudo mkdir -p "$MOUNT_POINT"

# Check if already mounted
if mount | grep -q "$MOUNT_POINT"; then
    echo "Already mounted at $MOUNT_POINT"
else
    echo "Mounting $CIFS_PATH to $MOUNT_POINT"
    sudo mount -t cifs "$CIFS_PATH" "$MOUNT_POINT" -o credentials=/home/wolf/.smbcredentials,iocharset=utf8,uid=1000,gid=1000,file_mode=0777,dir_mode=0777
    if [ $? -eq 0 ]; then
        echo "Mount successful"
    else
        echo "Mount failed"
        exit 1
    fi
fi

