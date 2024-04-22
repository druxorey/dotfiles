## **Contents**   

0. [Introduction](#id-0)
1. [Installing BSPWM and SXHKD](#id-1)
2. [Initializing the Desktop Environment](#id-2)
   1. [Enabling the Display Manager](#id-2.1)
   2. [Configuring BSPWM and SXHKD](#id-2.2)
3. [Customizing BSPWM](#id-3)
   1. [Installation and Configuration of LXAppearance, Picom, and Nitrogen](#id-3.1)

# BSPWM In Arch Linux Installation Guide <a name='id-0'></a>

Welcome to this guide to install BSPWM in your Arch Linux. Whether you're a seasoned Linux user or a newcomer, we've got you covered. We'll walk you through the process, explain the concepts, and provide tips and tricks to make your experience smooth and enjoyable.

*- **Note**: To follow this guide, we assume that you already have Arch Linux installed. If you have not installed it yet, you can refer to the [Arch Linux Installation Guide](arch-linux-installation-guide.md).*

# 1) Installing BSPWM and SXHKD

We will start with the installation of **bspwm** and **sxhkd**. BSPWM is a tiling window manager and SXHKD, on the other hand, is an independent daemon to bind actions to key combinations and/or mouse buttons.

We will also install **lightdm**, which is a lightweight display manager, along with **lightdm-gtk-greeter** and **lightdm-gtk-greeter-settings** to provide a graphical user interface for configuration. Finally, **xorg**, which is the most popular public, free, and open-source window system.

To install these packages, open a terminal and run the following command:

    $ sudo pacman -S bspwm sxhkd lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings xorg

# 2) Initializing the Desktop Environment

## 2.1) Enabling the Display Manager

Now we have to initialize the LightDM display manager. This can be done by enabling it through the system control as follows:

    $ sudo systemctl enable lightdm

## 2.2) Configuring BSPWM and SXHKD

Next, we need to create custom directories for BSPWM and SXHKD  in the `.config` directory. This can be done using the `mkdir` command:

    $ mkdir -p ~/.config/{bspwm,sxhkd}

Once the directories are created, we can proceed to install the necessary files with the appropriate permissions. We'll use the `install` command to copy the example configuration files from the BSPWM and SXHKD documentation to our newly created directories:

    $ install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
    $ install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/

After installing the files, it's crucial to modify the `sxhkdrc` file located in the `.config/sxhkd/` directory. This file contains the configuration for the hotkeys, including the one for opening the terminal. If this is not set up correctly, you may encounter issues when trying to open a terminal after a system restart. 

In our case we will use `Kitty` as our terminal emulator, so the configuration would be as follows:

    # kitty
    super + Return
        kitty

# 3) Customizing BSPWM

## 3.1) Installation and Configuration of LXAppearance, Picom, and Nitrogen

We will install the `lxappearance`, `picom`, and `nitrogen` packages to customize the desktop environment.

### LXAppearance

**LXAppearance** is a desktop-independent theme manager that allows us to change the appearance of our desktop environment. To install it, run the following command:

    $ sudo pacman -S lxappearance

Once installed, you can run `lxappearance` in the terminal to open the graphical user interface. Here you can change the GTK theme, the icon theme, the font, and the cursor.

### Picom

**Picom** is an independent compositor for Xorg, famous for providing shading and transparency effects to windows. To install it, run the following command:

    $ sudo pacman -S picom

After installation, you can start Picom with the command `picom &`. To configure it, create a configuration file in your home directory, for example `~/.config/picom/picom.conf`, and adjust the settings according to your needs.

### Nitrogen

**Nitrogen** is a utility for changing the desktop background in X Window systems. To install it, run the following command:

    $ sudo pacman -S nitrogen

After installation, you can run `nitrogen /path/to/your/images/` to select an image as a desktop background.

*- **Important**: If you want these programs to run when you start your computer, you can add the following configuration to your .bspwmrc file: `nitrogen --restore % & picom --config ~/.config/picom/picom.conf &`.*