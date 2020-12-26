# Max Moser's Dotfiles

This repository is a collection of configuration files that improve the handling of some applications for me personally.  
Its aim is to provide an efficient keyboard-centric workflow, while not being too hard on the eye.


Probably one of the highlights is the small desktop environment that it builds with `i3`, including the following features:

* [Nord theme](https://www.nordtheme.com/)
* Background image straight from the [Tyrolean Alps](https://www.alpbachtal.at/en)
* Screenshots
* Screen locking
* Keyboard-centric operation
* etc.


**Note**: Even though some of the configurations are meant to be used together (e.g. `i3` and `polybar`), others can be used completely stand-alone (e.g. `tmux` and `vim`).



# Installation

This repository is designed to be easily usable with [GNU Stow](https://www.gnu.org/software/stow/).  
To install the dotfiles for any of the applications, simply issue the command:

`$ stow -t ~ <TARGET>`


## zsh

Before installing the `zsh` dotfiles, make sure that [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) is installed.



# Requirements


## i3

### Default Programs

* [`alacritty`](https://github.com/alacritty/alacritty): Terminal Emulator
* [`nemo`](https://wiki.archlinux.org/index.php/Nemo): File Explorer
* [`dunst`](https://github.com/dunst-project/dunst): Notification Daemon
* [`picom`](https://github.com/yshui/picom): Compositor
* [`polybar`](https://github.com/polybar/polybar): Status Bar
* [`feh`](https://feh.finalrewind.org/): Image Viewer (for Desktop Background)
* [`rofi`](https://github.com/davatorium/rofi): Application Launcher
* [`scrot`](https://github.com/resurrecting-open-source-projects/scrot): Screen Capture Utility
* [`i3lock`](https://github.com/i3/i3lock): Screen Locker
* `xautolock`: Automatic Screen Locking

### Other

* [`bash`](https://www.gnu.org/software/bash/): Interpreter for scripts
* [`imagemagick`](https://imagemagick.org/index.php): Image manipulation (screen locking)
* [`xset`](https://www.x.org/wiki/): Screen saver timings (screen locking)
* [`xrandr`](https://www.x.org/wiki/): Monitor layouting
* [`xinput`](https://www.x.org/wiki/): Mouse settings
* [`xbacklight`](https://www.x.org/wiki/): Monitor backlight management (currently not in use)
* [`gnome-screenshot`](https://gitlab.gnome.org/GNOME/gnome-screenshot): Fancier screenshot utility


## polybar

* `bluetoothctl` ([`bluez-utils`](http://www.bluez.org/)) -- for the Bluetooth module (currently disabled)


## dunst

* [`firefox`](https://www.mozilla.org/en-US/firefox/new/): Browser



# Further Steps


## GTK Theme

To install the [Nordic (bluish accent)](https://github.com/EliverLara/Nordic) GTK theme, the packaged files have to be extracted into `~/.themes`:

```bash
$ mkdir ~/.themes
$ tar -xf Nordic-bluish-accent.tar.xf -C ~/.themes
```

**Note**: To install the theme system-wide, extract it into `/usr/share/themes` instead.


Then, the GTK settings for both GTK 2 and 3 have to be updated:

`~/.gtkrc-2.0`
---
```ini
gtk-theme-name="Nordic-bluish-accent"
```

`~/.config/gtk-3.0/settings.ini`
---
```ini
[Settings]
gtk-application-prefer-dark-theme = true
gtk-theme-name = Nordic-bluish-accent
```

