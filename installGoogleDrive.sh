#!/bin/bash
number="0"
clear
echo Google Drive for Raspbian
echo -------------------------
echo Options:
echo 1. Install/Re-install Google Drive
echo 2. Uninstall Google Drive
echo 3. Add auto-mount
echo 4. Remove auto-mount
echo 5. Exit Installer
echo  
read -p "Input Number: " number
if (( $number == "1" )); then
	echo Initializing...
	cd /home/pi
	echo Cleaning up old assets...
	sudo umount /mnt/gdrivefs
	sudo rmdir /mnt/gdrivefs
	sudo rm "/home/pi/Google Drive"
	sudo rm /home/pi/.gdfs.creds
	sudo sed -i '\|sudo gdfs -\o allow_other /home/pi/.gdfs.creds /mnt/gdrivefs|d' /etc/rc.local
	echo Installing updates...
	sudo apt-get install python3-pip
	sudo pip3 install google-api-python-client -U
	sudo pip3 install six -U
	sudo pip3 install gdrivefs -U
	sudo pip3 install oauth2client -U
	echo Creating directories...
	sudo mkdir /mnt/gdrivefs
	echo Authorizing Google Drive...
	authKey=""
	echo Please follow the instructions to sign in to your Google Drive account:
	sleep 1s
	gdfstool auth_get_url
	read -p "Authorization Key: " authKey
	echo Authorizing...
	gdfstool auth -a /home/pi/.gdfs.creds "$authKey"
	echo Mounting drive files...
	sudo gdfs -o allow_other /home/pi/.gdfs.creds /mnt/gdrivefs
	ln -s "/mnt/gdrivefs" "/home/pi/Google Drive"
	echo Listing files...
	echo _______________________________
	confirm="y"
	ls "/home/pi/Google Drive"
	read -p "Is this correct (Y/n)? " confirm
	if (( $confirm == "y" || $confirm == "Y" )); then
		read -p "Mount at system startup (Y/n)? " confirm
		if (( $confirm == "y" || $confirm == "Y" )); then
			sudo sed -i -e '$i \sudo gdfs -o allow_other /home/pi/.gdfs.creds /mnt/gdrivefs' /etc/rc.local
			echo Installation successful...
			read -p "Press enter to exit..."
		fi
	else
		echo Installation failed!
		read -p "Press enter to exit..."
	fi
fi
if (( $number == "2" )); then
	echo Uninstalling...
	sudo umount /mnt/gdrivefs
	sudo rmdir /mnt/gdrivefs
	sudo rm "/home/pi/Google Drive"
	sudo rm /home/pi/.gdfs.creds
	sudo sed -i '\|sudo gdfs -\o allow_other /home/pi/.gdfs.creds /mnt/gdrivefs|d' /etc/rc.local
	sudo pip3 uninstall gdrivefs
	sudo pip3 uninstall oauth2client
	echo Uninstallation successful!
	read -p "Press enter to exit..."
fi

if (( $number == "3" )); then
	sudo sed -i -e '$i \sudo gdfs -o allow_other /home/pi/.gdfs.creds /mnt/gdrivefs' /etc/rc.local
	echo Auto-mount added!
	read -p "Press enter to exit..."
fi

if (( $number == "4" )); then
	sudo sed -i '\|sudo gdfs -\o allow_other /home/pi/.gdfs.creds /mnt/gdrivefs|d' /etc/rc.local
	echo Auto-mount removed!
	read -p "Press enter to exit..."
fi

echo Goodbye!
sleep 1s
clear
