<h1 align="center">Dotfiles</h1>

<p align="center">A minimalist repository of my dotfiles for arch linux</p>

<p align="center">
<a href="https://www.deviantart.com/druxorey/gallery/94231956/wallpapers-for-dracula"><img src="https://img.shields.io/badge/wallpapers-BD93F9?style=for-the-badge"></a>
<a href="#installation"><img src="https://img.shields.io/badge/installation-FF79C6?style=for-the-badge"></a>
<a href="https://github.com/druxorey/dotfiles/tree/main/local/bin"><img src="https://img.shields.io/badge/scripts-BD93F9?style=for-the-badge"></a>
</p>

![Desktop Screenshot](/assets/rice-2026-01-25.webp)

## Repository Structure

- `assets`: This directory contains resources required for the repository, such as screenshots, and other media files.

- `config`: This directory holds configuration files for various programs and tools. These files are used to customize or set up the behavior of specific software.

- `local`: This directory is used for user-specific files and scripts. It is divided into:
	- `share/applications`: Contains `.desktop` files, which are used to define shortcuts and metadata for Linux applications, making them accessible from the application menu or launcher.
	- `bin`: Contains custom scripts and executable files created by the user for system-level tasks or automation.

## Installation

The [`drxboot.sh`](drxboot.sh) script automates the initial installation and configuration of an Arch Linux system. It updates the system, installs essential packages (both from Pacman and AUR), and enables necessary services like the firewall and the login manager. It’s particularly useful for users who want a quick and straightforward installation process.

To download and execute the script directly, run:

```bash
curl -O https://raw.githubusercontent.com/druxorey/dotfiles/refs/heads/main/drxboot.sh
bash drxboot.sh
```

To execute the script directly without downloading it, run:

```bash
bash <(curl -s https://raw.githubusercontent.com/druxorey/dotfiles/refs/heads/main/drxboot.sh)
```

## Dependencies

In this repository are the configuration files for my work environment, below is a list of the most important programs.

<table align="center">
	<tr>
		<th>Program</th>
		<th>Link</th>
	</tr>
	<tr>
		<td>Linux Distribution</td>
		<td><a href="https://github.com/archlinux/linux">arch</a></td>
	</tr>
	<tr>
		<td>Window Manager</td>
		<td><a href="https://github.com/baskerville/bspwm">bspwm</a></td>
	</tr>
	<tr>
		<td>Shell</td>
		<td><a href="https://github.com/zsh-users/zsh">zsh</a></td>
	</tr>
	<tr>
		<td>Prompt</td>
		<td><a href="https://github.com/JanDeDobbeleer/oh-my-posh">oh my posh</a></td>
	</tr>
	<tr>
		<td>Terminal</td>
		<td><a href="https://github.com/kovidgoyal/kitty">kitty</a></td>
	</tr>
	<tr>
		<td>System Fetch</td>
		<td><a href="https://github.com/fastfetch-cli/fastfetch">fastfetch</a></td>
	</tr>
	<tr>
		<td>Bar</td>
		<td><a href="https://github.com/polybar/polybar">polybar</a></td>
	</tr>
	<tr>
		<td>Browser</td>
		<td><a href="https://github.com/brave/brave-browser">brave</a></td>
	</tr>
	<tr>
		<td>Editor</td>
		<td><a href="https://github.com/neovim/neovim">neovim</a></td>
	</tr>
	<tr>
		<td>File Manager</td>
		<td><a href="https://github.com/sxyazi/yazi">yazi</a></td>
	</tr>
	<tr>
		<td>Application Launcher</td>
		<td><a href="https://github.com/adi1090x/rofi">rofi</a></td>
	</tr>
	<tr>
		<td>Colorscheme</td>
		<td><a href="https://draculatheme.com/">dracula</a></td>
	</tr>
	<tr>
		<td>Wallpapers</td>
		<td><a href="https://www.deviantart.com/druxorey">deviantart</a></td>
	</tr>
	<tr>
		<td>GTK Theme</td>
		<td><a href="https://draculatheme.com/gtk">dracula gtk</a></td>
	</tr>
	<tr>
		<td>Icon Theme</td>
		<td><a href="https://draculatheme.com/gtk">dracula papirus</a></td>
	</tr>
	<tr>
		<td>Cursor</td>
		<td><a href="https://www.gnome-look.org/p/1669262/">dracula cursor</a></td>
	</tr>
	<tr>
		<td>GUI Font</td>
		<td><a href="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Noto.zip">noto sans nerd font</a>
		</td>
	</tr>
	<tr>
		<td>TUI Font</td>
		<td><a href="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip">hack nerd font</a></td>
	</tr>
</table>

## License

This project is licensed under the GPL-3.0 License. See the [LICENSE](LICENSE) file for more details.
