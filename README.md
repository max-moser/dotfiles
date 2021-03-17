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



# Usage


## sway and i3

Most of the following hotkeys work for both i3 and sway, with some exceptions (e.g. the monitor management isn't implemented for i3/X11 yet).
For many of these hotkeys, both `Win` and `Alt` can be used as modifier.

### Applications

* `Win+e`: Application launcher
* `Win+Shift+d`: Executable launcher
* `Win+Enter`: Launch terminal emulator
* `Win+e`: Launch file explorer

### Windows

* `Win+Tab`: Switch to window
* `Alt+h/j/k/l`: Select window to the left/up/down/right
* `Alt+Tab`: Select next window
* `Alt+Shift+Tab`: Select previous window
* `Alt+Shift+h/j/k/l`: Move selected window to the left/up/down/right
* `Alt+a`: Focus parent container
* `Alt+Shift+a`: Focus child container
* `Alt+Shift+f`: Toggle fullscreen
* `Ctrl+Alt+Shift+f`: Toggle fullscreen (over all screens)
* `Alt+Shift+q`: Kill window

### Workspaces

* `Alt+[1-9]`: Select workspace by number
* `Alt+Shift+[1-9]`: Move selected window to workspace
* `Alt+n`: Select next workspace on focused monitor
* `Alt+p`: Select previous workspace on focused monitor
* `Alt+Shift+n`: Create new workspace

### Screenshots

* `Print`: All screens (to new file)
* `Control+Print`: All screens (to clipboard)
* `Shift+Print`: Selected area (to new file)
* `Control+Shift+Print`: Selected area (to clipboard)

### Menus

* `Alt+r`: Resize windows (with `h/j/k/l`)
* `Alt+M`: Monitor management (move focused monitor, ...)
* `Alt+Esc`: Power/Session management (logout, lock screen, power off, ...)

### Container Layouts

* `Alt+Shift+s`: Stacking layout
* `Alt+Shift+w`: Tabbed layout
* `Alt+Shift+e`: Split layout (toggle horizontal/vertical split)
* `Ctrl+Alt+i`: Split orientation: horizontal
* `Ctrl+Alt+o`: Split orientation: vertical
* `Ctrl+Alt+p`: Split orientation: toggle (horizontal/vertical)

### Floating Windows

* `Alt+Space`: Toggle focus floating windows
* `Alt+Shift+Space`: Toggle floating layout for current window



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

### Script Dependencies

* [`bash`](https://www.gnu.org/software/bash/): Interpreter for scripts
* [`imagemagick`](https://imagemagick.org/index.php): Image manipulation (screen locking)
* [`xset`](https://www.x.org/wiki/): Screen saver timings (screen locking)
* [`xrandr`](https://www.x.org/wiki/): Monitor layouting
* [`xinput`](https://www.x.org/wiki/): Mouse settings
* [`xbacklight`](https://www.x.org/wiki/): Monitor backlight management (currently not in use)
* [`gnome-screenshot`](https://gitlab.gnome.org/GNOME/gnome-screenshot): Fancier screenshot utility
* [`jq`](https://stedolan.github.io/jq/): JSON Processor (for parsing IPC messages)
* [`pulseaudio`](https://www.x.org/wiki/): Audio Control
* [`polkit`](https://www.freedesktop.org/wiki/Software/polkit/): Authorization Manager (for allowing normal users to reboot, etc.)


## polybar

* `bluetoothctl` ([`bluez-utils`](http://www.bluez.org/)): For the Bluetooth module (currently disabled)


## dunst

* [`firefox`](https://www.mozilla.org/en-US/firefox/new/): Browser


## sway

### Default Programs

* [`alacritty`](https://github.com/alacritty/alacritty): Terminal Emulator
* [`nemo`](https://wiki.archlinux.org/index.php/Nemo): File Explorer
* [`mako`](https://wayland.emersion.fr/mako/): Notification Daemon
* [`kanshi`](https://github.com/emersion/kanshi): Multihead Profile Manager
* [`waybar`](https://github.com/Alexays/Waybar/): Status Bar
* [`rofi`](https://github.com/davatorium/rofi): Application Launcher
* [`swaylock`](https://github.com/swaywm/swaylock): Screen Locker
* [`swayidle`](https://github.com/swaywm/swayidle): Automatic Screen Locking
* [`pulseaudio`](https://www.x.org/wiki/): Audio Control
* [`playerctl`](https://github.com/acrisci/playerctl): Audio Player Control
* [`brightnessctl`](https://github.com/Hummer12007/brightnessctl): Backlight Control

### Script Dependencies

* [`bash`](https://www.gnu.org/software/bash/): Interpreter for scripts
* [`python3`](https://www.python.org/): Scripting Language
* [`imagemagick`](https://imagemagick.org/index.php): Image manipulation (screen locking)
* [`grim`](https://github.com/emersion/grim): Screen Capture Utility
* [`slurp`](https://github.com/emersion/slurp): Screen Area Selection Utility (screenshots)
* `wl-copy` ([`wl-clipboard`](https://github.com/bugaevc/wl-clipboard)): Clipboard Utility (screenshots)
* [`jq`](https://stedolan.github.io/jq/): JSON Processor (for parsing IPC messages)
* [`polkit`](https://www.freedesktop.org/wiki/Software/polkit/): Authorization Manager (for allowing normal users to reboot, etc.)


## waybar

* [`pavucontrol`](https://freedesktop.org/software/pulseaudio/pavucontrol/): PulseAudio GUI
* [`brightnessctl`](https://github.com/Hummer12007/brightnessctl): Backlight Control
* [`networkmanager`](https://wiki.gnome.org/Projects/NetworkManager): Network Manager



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

