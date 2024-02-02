# BSPWM Installation Guide

Welcome to this guide to install BSPWM in your Arch Linux. This guide is designed to be a comprehensive resource to help you every step of the way. 

Whether you're a seasoned Linux user or a newcomer, we've got you covered. We'll walk you through the process, explain the concepts, and provide tips and tricks to make your experience smooth and enjoyable.

***Important**: This guide is based on the assumption that the required packages have been installed using the `scripts/initpkg.sh` script. Please ensure that you have successfully run this script before proceeding with the steps outlined in this guide.*

## Initializing the Desktop Environment

The first step in setting up BSPWM on Arch Linux is to initialize the LightDM display manager. This can be done by enabling it through the system control as follows:

    $ sudo systemctl enable lightdm

Next, we need to create custom directories for BSPWM and SXHKD  in the `.config` directory. This can be done using the `mkdir` command:

    $ mkdir -p .config/{bspwm,sxhkd}

Once the directories are created, we can proceed to install the necessary files with the appropriate permissions. We'll use the `install` command to copy the example configuration files from the BSPWM and SXHKD documentation to our newly created directories:

    $ install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc .config/bspwm/
    $ install -Dm644 /usr/share/doc/sxhkd/examples/sxhkdrc .config/sxhkd/

After installing the files, it's crucial to modify the `sxhkdrc` file located in the `.config/sxhkd/` directory. This file contains the configuration for the hotkeys, including the one for opening the terminal. If this is not set up correctly, you may encounter issues when trying to open a terminal after a system restart. Therefore, ensure that the terminal program is correctly set in the `sxhkdrc` file.

Remember, each step is crucial for the successful installation and operation of the BSPWM on Arch Linux. Happy coding!

## Customizing BSPWM

