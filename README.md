# RPi-Google-Drive
An automated Google Drive live-sync client (gdrivefs) installer for the Raspberry Pi

This utility will allow the user to mount their Google Drive to their Raspberry Pi and keep it mounted through reboots in a simple, automated process.
It includes both a fully automated version (requires a GUI setup) and a headless version (Works over SSH and on non-GUI systems, but requires a bit more setup).

This script will not have the execute permission when first downloaded. To fix this, simply open a terminal and type:

`[sudo] chmod +x "/path/to/installGoogleDrive.sh"`

Python 3 must be installed in order for this script to work.

Basic process acquired from here: https://www.raspberrypi.org/forums/viewtopic.php?t=109587

All credit for Google Drive incorporation goes to the creators of gdrivefs. This project is in no way affiliated with Google or the creators of gdrivefs.
