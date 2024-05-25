# BSPWM DOTFILES

These dotfiles are designed to customize and optimize your working environment on Arch Linux. They include configurations for BSPWM, Kitty, file managers (such as Ranger or Thunar), and other essential tools. Additionally, you’ll find shortcuts, themes, and specific tweaks to enhance productivity and the overall user experience.

## Dotfiles Structure

### arch-bootstrap script

The scripts have been moved to a separate repository, you can be find them [here](https://github.com/druxorey/pybash-scripts/), however there is a script that was left here due to its importance and it is 'arch-bootstrap'.

The `arch-bootstrap` script automates the initial installation and configuration of an Arch Linux system. It updates the system, installs essential packages (both from Pacman and AUR), and enables necessary services like the firewall and the login manager. 

It’s particularly useful for users who want a quick and straightforward installation process. You can find the script [here](arch-bootstrap.sh).

### config

This directory contains specific configuration files for different programs and tools. Here you can find the `bin` directory which contains several scripts that are added to the `$PATH` so that they can be executed at any time.

### guides 

Here you'll find the [arch linux installation guide](guides/arch-linux-installation.md), a step-by-step guide to installing Arch Linux, and the [bspwm installation guide](guides/bspwm-arch-installation.md), and detailed instruction guide for configuring the bspwm window manager. You can also find them in [CIPAL](https://cipalonline.github.io/).

### resources

Directory where screenshots, documents and some other files are stored.

## Screenshots

![This is an image](/resources/rices/rice-2024-02-23.png)

## Dependencies

- **Shell**: zsh
- **Prompt**: oh-my-posh
- **Terminal**: kitty
- **System Fetch**: neofetch
- **Bar**: polybar
- **Browser**: brave
- **Editor**: neovim
- **File Manager**: thunar and ranger
- **Aplication launcher**: rofi
- **Colorscheme**: [dracula](https://draculatheme.com/)
- **Wallpaper**: [here](/resources/wallpapers.zip)
- **GTK theme**: [Dracula GTK](https://draculatheme.com/gtk)
- **Icon theme**: [Dracula Papirus](https://draculatheme.com/gtk#:~:text=Icon%20Theme%20(optional))
- **Cursor**: [Dracula cursor](https://www.gnome-look.org/p/1669262/)
- **GUI Font**: [Noto Sans Nerd Font](https://www.nerdfonts.com/font-downloads#:~:text=or%20straight%20lined-,Download,-Preview%20on%20ProgrammingFonts)
- **TUI Font**: [Hack Nerd Font](https://www.nerdfonts.com/font-downloads#:~:text=at%20common%20sizes-,Download,-Preview%20on%20ProgrammingFonts)
