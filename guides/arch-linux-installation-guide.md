## **Contents**   

0. [Introduction](#id-0)
1. [Pre-Installation](#id-1)
   1. [Preparation of installation media](#id-1.1)
   2. [Network Configuration](#id-1.2)
2. [Drive preparation](#id-2)
   1. [Partitioning disk](#id-2.1)
   2. [Formatting the Partitions](#id-2.2)
   3. [Mounting the Partitions](#id-2.3)
3. [Installation](#id-3)
   1. [Basic packages](#id-3.1)
   2. [File System Tab](#id-3.2)
   3. [Switching to the Installed System (Changing Root)](#id-3.3)
4. [Internal Configuration](#id-4)
   1. [Setting the Time Zone](#id-4.1)
   2. [Configuring Localization](#id-4.2)
   3. [Configuring the Keyboard Layout (Keymap)](#id-4.3)
   4. [Setting the Hostname](#id-4.4)
   5. [Setting the Root Password](#id-4.5)
   6. [Creating a New User](#id-4.6)
   7. [Enabling Network Manager](#id-4.7)
   8. [Installing the Bootloader](#id-4.8)
   9. [Final Steps and Rebooting the System](#id-4.9)
5. [Post-Installation Tasks](#id-5)
   1. [Extra Configurations](#id-5.1)
   2. [Establishing the Internet Connection](#id-5.2)
   3. [Configuring the DNS](#id-5.3)
   4. [Firewall Configuration](#id-5.4)
   5. [Battery Optimization](#id-5.5)

---

# Arch Linux Installation Guide <a name='id-0'></a>

This guide is rooted in the official [Arch Linux Wiki](https://wiki.archlinux.org/) to ensure that you’re receiving accurate and up-to-date information. For further information and support, the official Arch Linux forum is an invaluable resource. Here, you’ll find the official [**Installation Guide**](https://wiki.archlinux.org/title/installation_guide), along with a wealth of knowledge from the Arch Linux community.

In addition to the standard procedures, this guide adds different commands and strategies designed to make the installation process faster and easier whether you are an experienced Linux user or a newcomer to the world of open source operating systems.

We have to clarify that this guide will focus on the basic installation of Arch. If you want to use a graphical environment, you can consult the rest of our guides:

 - [BSPWM](bspwm-arch-installation-guide.md)

Also you can check out the official Arch Wiki, which provides comprehensive guides for installing various [desktop environments](https://wiki.archlinux.org/title/Desktop_environment).

# 1) Pre-instalattion <a name='id-1'>

*- **Note**: It’s important to clarify that everything done in the pre-installation section will not have any impact on the computer. However, from the [preparation of the disk](#id-2) onwards, the changes will be irreversible.*

## 1.1) Preparation of installation medium <a name='id-1.1'>

*- **Omission**: If you are gonna carry out this process on a virtual machine you can skip this step.*

Before we start, we need to obtain the installation image (ISO). You can get it from the [Arch Linux Downloads](https://archlinux.org/download/) section where you can download it via Magnet Link, Torrent, or HTTP direct.

After downloading the ISO, we need to prepare the installation medium. For this, you can use any program to create USB boot drives, however, we recommend using [Ventoy](https://www.ventoy.net/en/index.html). If you use Windows, you can also use [Rufus](https://rufus.ie/en/).

Once the installation medium is created and booted from it, you will reach the Arch Linux welcome screen and you will be logged in as the root user in the virtual console.

*- **Note**: The Arch Linux image does not support Secure Boot. You will need to disable it on your machine to be able to boot from the installation medium.*

## 1.2) Network Configuration <a name='id-1.2'></a>

*- **Omission**: If the computer on which you are going to install Arch is connected by cable, you can skip the following part, as it is the configuration of the wireless connection.*

We are gonna use the tool `iwctl` for the internet configuration

    $ iwctl

After executing the command you have to look for the technical name of your wifi card with the command `device list`.

    $ device list

The name of your wifi card will be the one you will place in the **wlan** section.

    $ station <wlan> connect <Network Name>

*- **Note**: If your network is hidden, you must replace the `connect` with the `connect-hidden` attribute.*

After this, it is advisable to test the connection with the `ping` command.

# 2) Drive Preparation <a name='id-2'></a>

*- **Note**: If you want to do an easier installation, you can use the `archinstall` script. However, in this guide, we are going to use the manual installation. If you want to use the script, you can refer to the [official documentation](https://wiki.archlinux.org/title/Archinstall).*

## 2.1) Partitioning disk <a name='id-2.1'></a>

The first step is to identify the path of the partition we want to manage. We can do this by using the `fdisk -l` command, which lists all the disks and their partitions.

When you run `fdisk -l`, look for your disk in the output. You can identify your disk based on its size or model. In this case, We have an NVMe drive, so it appears as `nvme0n1`.

Once you've identified your disk, you can use the `cfdisk` command followed by the path to your disk. In our case, the command would be:

    $ cfdisk /dev/nvme0n1

We will be using the `cfdisk` tool to partition the disk into three sections: boot, swap, and root. It is advisable to use the **gpt** label type, as it is prevalent in UEFI systems. If you have partitions already created from a previous operating system, you will need to delete all of them. 

- **The boot partition**: This partition is essential for the system to boot up. It is recommended to allocate at least 100M for the boot partition. 
- **The swap partition**: The swap partition acts as an overflow for your system memory, ensuring smooth operation when your RAM is fully utilized. The size of the swap partition should be a power of 2 (2, 4, 8, 16, etc.), depending on the size of your hard drive. In this case, it is recommended that the swap partition be at least 8GB. 
- **The root partition**: This partition will contain your operating system, applications, and files. Allocate the remaining hard drive space to the root partition. 

Once you have partitioned the disk, write the changes and exit the `cfdisk` tool.

To list the partitions and track your progress, use the `lsblk` command. This command is crucial for confirming the ID, size, and type of the partitions. If you did it correctly, when listing the partitions they should come out as follows:

```
NAME        MAJ:MIN RM   SIZE RO TYPE
nvme0n1     259:0    0 476.9G  0 disk 
├─nvme0n1p1 259:1    0   100M  0 part 
├─nvme0n1p2 259:2    0     8G  0 part 
└─nvme0n1p3 259:3    0 468.8G  0 part 
```

It is important to know the number at the end of the partitions, as it will be necessary to be able to format them and mount them in the correct way. In this case, the partition that ends in 1 is the boot, the one that ends in 2 is the swap, and the one that ends in 3 is the root.

## 2.2) Formatting the Partitions <a name='id-2.2'></a>

In this step, we will format the three partitions that we have created. 

*- **Note:** Remember to replace `/dev/nvme0n1pX` with your actual partition paths if they are different. Always double-check your commands before executing them to avoid data loss.* 

1. **Root Partition**: The first partition we need to format is the root partition. This can be accomplished using the next command:

        $ mkfs.ext4 /dev/nvme0n1p3

    This command formats the partition as an **ext4** filesystem, which is a common choice for Linux installations due to its robustness and excellent performance.

2. **Boot Partition**: Next, we will format the boot partition using the following command:

        $ mkfs.fat -F 32 /dev/nvme0n1p1

    This command formats the partition with a **FAT32** filesystem. FAT32 is commonly used for boot partitions as it is universally supported by almost all operating systems.

3. **Swap Partition**: Finally, we will set up the swap partition with the following command:

        $ mkswap /dev/nvme0n1p2

    This command initializes the partition to be used as swap space.

## 2.3) Mounting the Partitions <a name='id-2.3'></a>

In this step, we will be mounting the partitions. First, let's start with the **root** partition. You can mount it using the command below:

    $ mount /dev/nvme0n1p3 /mnt

Next, we need to mount the **boot** partition. However, the required path does not exist yet. Therefore, we will create it using the following command:

    $ mkdir -p /mnt/boot/efi

With the path now created, we can proceed to mount the **boot** partition:

    $ mount /dev/nvme0n1p1 /mnt/boot/efi

Lastly, the **swap** partition does not need to be mounted in the traditional sense. Instead, it needs to be activated. You can do this with the following command:

    $ swapon /dev/nvme0n1p2

# 3) System Installation <a name='id-3'></a>

## 3.1) Basic packages <a name='id-3.1'></a>

The installation process involves selecting the desired packages and mounting them in the `/mnt` directory. It is recommended to install at least the following packages: `base`, `linux`, `linux-firmware`, `base-devel`, `grub`, `efibootmgr`, `nano`, `networkmanager`, `git`, `pulseaudio` and `intel-ucode`.

*- **Note**: For those using an AMD processor, it's necessary to install the `amd-ucode` package instead of `intel-ucode`. This will ensure your system has the latest microcode updates from AMD.*

To install these packages, use the command below:

    $ pacstrap /mnt base linux linux-firmware base-devel grub efibootmgr nano networkmanager git pulseaudio intel-ucode

This command will install the base system along with the Linux kernel and firmware, development tools, the GRUB bootloader, EFI boot manager, a basic text editor (nano), network manager, Git for version control, and microcode for Intel processors. 

## 3.2) File System Tab <a name='id-3.2'></a>

Once you've installed the necessary tools, the next step is to generate a **fstab** file, which allows your system to automatically mount partitions upon booting. You can generate a **fstab** file using the following command:

    $ genfstab /mnt

This command will display information about the currently mounted files. However, you need to transfer this information to disk. To do this, you can redirect the output of the `genfstab` command to the **fstab** file located in the `/mnt/etc/` directory:

    $ genfstab /mnt > /mnt/etc/fstab

To ensure that the **fstab** file has been correctly generated, you can use the `cat` command to display its contents:

    $ cat /mnt/etc/fstab

The output should match the initial output of the `genfstab /mnt` command. If it does, then you've successfully generated your **fstab** file and are ready to proceed to the next step of the installation process.

## 3.3) Switching to the Installed System (Changing Root) <a name='id-3.3'></a>

In this step, we will transition into our newly installed system environment. To do this, we use the following command:

    $ arch-chroot /mnt

*- **Note**: It's important to explain that everything we had done up until now had been on the installation medium, however with the previous command we switched to our PC. This means that in case there is a problem and we cannot access our PC, we can use the installation medium to access the PC (Clarifying that once we put a password on our PC we will need it if we want to access it externally).*

# 4) Internal Configuration <a name='id-4'></a>

## 4.1) Setting the Time Zone <a name='id-4.1'></a>

The first step in our internal configuration process is to set the system's time zone. This can be done by creating a symbolic link between our desired time zone and `/etc/localtime`. After setting the time zone, we will check the system date and synchronize the hardware clock with the system clock. The commands are as follows:

*- **Note**: Replace 'Continent' and 'City' with your specific location.*

    $ ln -sf /usr/share/zoneinfo/Continent/City /etc/localtime
    $ date
    $ hwclock --systohc

## 4.2) Configuring Localization <a name='id-4.2'></a>

Next, we will configure the system's locale settings. This involves editing the `locale.gen` file to uncomment the line corresponding to our desired locale. In this case, we will be using `en_US.UTF-8 UTF-8`. After saving the changes, we generate the new locale configuration using the `locale-gen` command.

    $ nano /etc/locale.gen
    # Uncomment the line: en_US.UTF-8 UTF-8
    $ locale-gen

For certain programs to function correctly, we need to specify our locale in the `/etc/locale.conf` file. We can do this by adding the line `LANG=en_US.UTF-8` to the file.

    echo LANG=en_US.UTF-8 > /etc/locale.conf

Now, your system-wide locale is set and will be recognized by all locale-aware programs on your system. Remember to replace `en_US.UTF-8` with your desired locale if it's different. 

## 4.3) Configuring the Keyboard Layout (Keymap) <a name='id-4.3'></a>

If you're using an english keyboard, this step may not be necessary. However, if you need to change the keyboard layout, you can do so by modifying the `/etc/vconsole.conf` file. 

To set the keyboard layout to US English, add the following line to the file:

    $ echo KEYMAP=us > /etc/vconsole.conf

If you want to use a variant of the US layout, such as the international layout, you would add it like this:

    $ echo KEYMAP=us-acentos > /etc/vconsole.conf

## 4.4) Setting the Hostname <a name='id-4.4'></a>

The hostname is a crucial aspect of your system configuration because it determines the internal name of your computer. To set the hostname, you need to access the file located at `/etc/hostname` and enter your desired name there. Here's how you can do it:

    $ echo YourDesiredHostname > /etc/hostname

Replace 'YourDesiredHostname' with the name you want to assign to your computer.

## 4.5) Setting the Root Password <a name='id-.5'></a>

Setting the root password it's vital for your system's security. The root password is what you'll use every time you need to access as sudo, so it should be complex to prevent unauthorized access. 

You can set the root password using the `passwd` command. After entering the command, you'll be prompted to type your password twice to confirm it. Here's how you can do it:

    $ passwd
    # You'll be prompted to type your password twice

Remember, a strong password typically includes a mix of upper and lower case letters, numbers, and special characters.

## 4.6) Creating a New User <a name='id-4.6'></a>

We will use the `useradd` command with the `-m` flag, which instructs the system to create a `/home` directory for the new account. The `-G` option is used to specify the group that should own the user’s home directory, in this case, `wheel`. The `-s` option sets the default shell for the user, which we will set to `/bin/bash`. Replace '(name)' with the desired username. 

    $ useradd -m -G wheel -s /bin/bash (name)

Now we will need a password for our new user:

    $ passwd (name)

Next, we will set up sudo for the new user. As it stands, if we switch to our new user using the `su (user)` command and attempt to execute a command with sudo (for example, `sudo pacman -Syu`), we will encounter an error. 

*- **Note**: If you switch to your new user using the `su (user)` command, you will need to exit your user session using either the `exit` command or `sudo su`. This is because we need root privileges to be able to modify the file.*

To rectify this, we will open the sudoers file using the **visudo** command with our preferred editor set by the **EDITOR** environment variable:

    $ EDITOR=nano visudo

In the sudoers file, locate and uncomment the line `%wheel ALL=(ALL) ALL`. This grants all members of the **wheel** group full sudo privileges. 

Now, if we switch back to our new user and attempt to use sudo commands, we should be able to do so without encountering any errors.

## 4.7) Enabling Network Manager <a name='id-4.7'></a>

To ensure that your system can connect to the internet, you'll need to enable the **Network Manager**. This can be done by running the following command:

    $ systemctl enable NetworkManager

## 4.8) Installing the Bootloader <a name='id-4.8'></a>

The next step, which is arguably the most crucial, involves installing a bootloader, because without a bootloader your system will not be able to start. In this guide, we'll be using GRUB as our bootloader. To install GRUB, execute the following command:

    $ grub-install /dev/nvme0n1

After installing GRUB we need to be configure it with the following command:

    $ grub-mkconfig -o /boot/grub/grub.cfg

## 4.9) Final Steps and Rebooting the System <a name='id-4.9'></a>

Once GRUB has been configured, you can exit the root user, unmount all mounted filesystems, and reboot your system. This can be done by running the following commands:

    $ exit
    $ umount -a
    $ reboot

After rebooting, your Arch Linux installation should be complete and ready to use. 

# 5) Post-Installation Tasks <a name='id-5'></a>

## 5.1) Extra Configurations <a name='id-5.1'></a>

In the `/etc/pacman.conf` file, we highly recommend making a few adjustments to enhance your experience. First, find the line that reads `Color` and uncomment it. This will enable colored output, making it easier to read and understand the information displayed in your terminal. 

Next, look for `ParallelDownloads` and set its value to 5. This allows for multiple packages to be downloaded simultaneously, speeding up the installation process.

Finally, uncomment the `ILoveCandy` line. While this doesn't impact the functionality, it does replace the standard download progress bar with a fun, candy-themed one. It's a small touch, but it adds a bit of whimsy to your Arch Linux setup process.

## 5.2) Establishing the Internet Connection <a name='id-5.2'></a>

Once the system is installed, it's recommended to retest the internet connection. This can be done using the `ping` command. 

    $ ping -c 3 www.google.com

If you're unable to establish an internet connection, you will have to use the `nmcli` command.

### Adding a new wireless connection

To add a new connection, you can use the following command:

    $ nmcli c add type wifi con-name <connect name> ifname <wlan> ssid <ssid>

This command creates a new connection with the type `wifi`. The `<connect name>` is the name you assign to the connection, `<wlan>` is the interface name, and `<ssid>` is the SSID of the wireless network.

*- **Note**: The `connect name` is a customizable identifier that you can assign to your network. This name is not fixed and can be changed according to your preference.*

### Connecting to a existing wireless connection

To connect to a wireless network, use:

    $ nmcli dev wifi connect <ssid> password <password>

*- **Note**: If your Wi-Fi connection is hidden, you must add the `hidden yes` parameter to the end of the previous command.*

### Deleting a a existing wireless connection

If you need to delete a connection, you can do so with:

    $ nmcli c delete <connect name>

## 5.3) Configuring the DNS  <a name='id-5.3'></a>

One of the crucial steps in setting up your internet connection is configuring the Domain Name System (DNS). This step is important to ensure seamless connectivity and to avoid potential issues, such as those that might occur with Microsoft services. 

To begin, you need to identify the name of your connection. This can be done by executing the following command in your terminal:

    $ nmcli con

This command will list all your active connections. Identify the connection for which you want to set the DNS.

Once you have the name of your connection (referred to as `<ssid>`), you can modify its DNS settings. Google's DNS servers (`8.8.8.8` and `8.8.4.4`) are commonly used due to their reliability. To set these as your DNS servers, use the following command:

    $ nmcli con mod "<ssid>" ipv4.dns "8.8.8.8 8.8.4.4"

Replace `<ssid>` with the name of your connection. This command sets the DNS servers for your specified connection to Google's DNS servers.

## 5.4) Firewall Configuration <a name='id-5.4'></a>

Configuring the Firewall is a very important step if you want to have a secure system, the easiest way is using the `ufw` package, you can install it with the following command:

    $ sudo pacman -S ufw

Once installed, you need to configure some rules to set it up:

    $ sudo ufw limit 22/tcp
    $ sudo ufw allow 80/tcp
    $ sudo ufw allow 443/tcp
    $ sudo ufw default deny incoming
    $ sudo ufw default allow outgoing
    $ sudo ufw enable

These commands limit the connection attempts to port 22, and allow all incoming connections to ports 80 and 443, which are the standard ports for HTTP requests. It also sets the default policy to deny all incoming connections. It also sets the default policy to allow all outgoing connections. And finally, it enables the firewall.

## 5.5) Battery Optimization <a name='id-5.5'></a>

If you're installing Arch Linux on a laptop, optimizing battery life is crucial. One effective tool for this purpose is `auto-cpufreq`. This utility dynamically adjusts the frequency of your CPU based on load and power source. Here's how you can install and use it:

First, clone the repository from GitHub:

    $ git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    
Next, navigate to the cloned directory and run the installer:

    $ cd auto-cpufreq && sudo ./auto-cpufreq-installer

Once the installation is complete, you need to activate `auto-cpufreq`. You can do this by running the following command:

    $ sudo auto-cpufreq --install

Remember, `auto-cpufreq` requires root privileges to make changes to your system. Always be cautious when using `sudo` with any command.

With `auto-cpufreq` installed and active, your laptop should now be better optimized for battery life. For more detailed information about your system's performance, you can use the `auto-cpufreq --stats` command to display real-time statistics.

---

The subsequent steps largely depend on the user's preferences, but it's generally advisable to set up a graphical environment for ease of use.

Remember, the beauty of Arch Linux lies in its flexibility. You can customize your system to suit your preferences. Enjoy the journey of making Arch Linux your own!