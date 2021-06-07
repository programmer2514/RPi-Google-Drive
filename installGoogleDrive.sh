#!/bin/bash

# Initialize the input variable
number="0"

# Print main menu
clear
echo Google Drive for Raspbian
echo -------------------------
echo Options:
echo 1. Install/Re-install Google Drive
echo 2. Uninstall Google Drive
echo 3. Mount Google Drive
echo 4. Unmount Google Drive
echo 5. Add auto-mount
echo 6. Remove auto-mount
echo 7. Exit Installer
echo

# Get user input
read -p "Input Number: " number

# If user inputs 1, install GDFS
if (( $number == "1" )); then

    echo Initializing...

    # Set active directory
    cd /home/pi

    echo Cleaning up old assets...

    # Unmount & delete GDFS mount location if it exists
    sudo umount /mnt/gdrivefs
    sudo rmdir /mnt/gdrivefs
    sudo rm /mnt/gdrivefs

    # Delete Google Drive auth token if it exists
    sudo rm /home/pi/.gdfs/creds

    # Delete Google Drive symbolic link in home directory if it exists
    sudo rm "/home/pi/Google Drive"

    # Remove autostart entry if it exists
    sudo rm /home/pi/.config/autostart/mountgdfs.desktop

    echo Installing updates...

    # Make sure pip3 is installed
    sudo apt-get install python3-pip

    # Install necessary python packages
    sudo pip3 install google-api-python-client -U
    sudo pip3 install gdrivefs -U

    # Notify user of new auth window
    echo Authorizing Google Drive...
    echo A new browser window will open shortly
    echo Please sign in to your Google account to authorize GDFS
    echo After authorization is complete, close the browser window to continue

    # Give user some time to read the message
    sleep 3

    # Open new browser window and get GDFS auth token
    gdfstool auth_automatic

    # Create GDFS mount location
    echo Creating folders...
    sudo mkdir /mnt/gdrivefs

    # Allow GDFS to run without root
    echo Modifying permissions...
    sudo chmod 777 /mnt/gdrivefs

    echo Mounting drive files...

    # Mount GDFS
    gdfs /home/pi/.gdfs/creds /mnt/gdrivefs

    # Create symbolic link
    ln -s "/mnt/gdrivefs" "/home/pi/Google Drive"

    echo Listing files...
    echo _______________________________

    # Initialize confirmation variable
    confirm="y"

    # List files in drive
    ls "/home/pi/Google Drive"

    # Ask user for success confirmation
    read -p "Is this correct (Y/n)? " confirm

    # If user confirms, continue
    if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then

        # Ask user for auto-mount confirmation
        read -p "Mount on user login (Y/n)? " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then

            # Add autostart entry
            echo "[Desktop Entry]
Type=Application
Exec=gdfs /home/pi/.gdfs/creds /mnt/gdrivefs
Name=Mount GDFS
Comment=Mounts Google Drive" >> /home/pi/.config/autostart/mountgdfs.desktop

            # Exit script
            echo Installation successful...
            echo If no files show up in the Google Drive folder,
            echo make sure to refresh the file manager by pressing Ctrl+R
            read -p "Press enter to exit..."

        fi

    # If user declines, cancel
    else

        # Exit script
        echo Installation failed!
        read -p "Press enter to exit..."

    fi

fi

# If user inputs 2, uninstall GDFS
if (( $number == "2" )); then

    echo Uninstalling...

    # Unmount & delete GDFS mount location
    sudo umount /mnt/gdrivefs
    sudo rmdir /mnt/gdrivefs
    sudo rm /mnt/gdrivefs

    # Delete Google Drive auth token
    sudo rm /home/pi/.gdfs/creds

    # Delete Google Drive symbolic link in home directory
    sudo rm "/home/pi/Google Drive"

    # Remove autostart entry
    sudo rm /home/pi/.config/autostart/mountgdfs.desktop

    # Uninstall gdrivefs
    sudo pip3 uninstall gdrivefs

    # Exit script
    echo Uninstallation successful!
    read -p "Press enter to exit..."

fi

# If user inputs 3, mount GDFS
if (( $number == "3" )); then

    # Mount GDFS
    echo Mounting GDFS...
    gdfs /home/pi/.gdfs/creds /mnt/gdrivefs

    # Exit script
    echo GDFS mounted!
    read -p "Press enter to exit..."

fi

# If user inputs 4, unmount GDFS
if (( $number == "4" )); then

    # Unmount GDFS
    echo Unmounting GDFS...
    sudo umount /mnt/gdrivefs

    # Exit script
    echo GDFS unmounted!
    read -p "Press enter to exit..."

fi

# If user inputs 5, make GDFS mount on startup
if (( $number == "5" )); then

    # Remove autostart entry if it exists
    sudo rm /home/pi/.config/autostart/mountgdfs.desktop

    # Add new autostart entry
    echo "[Desktop Entry]
Type=Application
Exec=gdfs /home/pi/.gdfs/creds /mnt/gdrivefs
Name=Mount GDFS
Comment=Mounts Google Drive" >> /home/pi/.config/autostart/mountgdfs.desktop

    # Exit script
    echo Auto-mount added!
    read -p "Press enter to exit..."

fi

# If user inputs 6, make GDFS not mount on startup
if (( $number == "6" )); then

    # Remove autostart entry
    sudo rm /home/pi/.config/autostart/mountgdfs.desktop

    # Exit script
    echo Auto-mount removed!
    read -p "Press enter to exit..."

fi

# Exit the installer
echo Goodbye!
sleep 1s
clear
