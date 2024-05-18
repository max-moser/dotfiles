# Max Moser's Dotfiles

This repository is a collection of configuration files that improve the handling of some applications for me personally.  
Its aim is to provide an efficient keyboard-centric workflow, while not being too hard on the eye.


Probably one of the highlights is the small desktop environment that it builds with `sway`, including the following features:

* [Nord theme](https://www.nordtheme.com/)
* Background image straight from the [Tyrolean Alps](https://www.alpbachtal.at/en)
* Keyboard-centric operation (including moving the cursor via hotkeys)
* Hotkeys for managing multiple monitors
* Hotkeys for connecting to Wi-Fi or VPN
* Screenshots
* Screen locking
* Night-time color correction
* etc.


## Do I need to use all configs together?

Even though some of the configurations are meant to be used together (e.g. `sway` and `waybar`), others can be used completely stand-alone (e.g. `tmux` and `vim`).


## Note about outdated configs

I've been using `sway` (Wayland) over `i3` (X11) for quite a while now, so the configuration for the latter has become a bit stale.
At some point these outdated configs might fall victim to some clean-up operation.



# Installation

This repository is designed to be easily usable with [GNU Stow](https://www.gnu.org/software/stow/).  
To install the dotfiles for any of the applications, simply issue the command:

`$ stow -t ~ <TARGET>`


## zsh

Before installing the `zsh` dotfiles, make sure that [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) is installed.



# Usage


## sway

Many of the following hotkeys work with `i3` as well as `sway`, but the former has been
neglected for quite a while now.

*Note*: For many of these hotkeys, both `Win` and `Alt` can be used as modifier.

### Applications

* `Win+d`: Application launcher
* `Win+Shift+d`: Executable launcher
* `Win+Enter`: Launch terminal emulator
* `Win+e`: Launch file explorer (via `xdg-open`)

### Windows

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
* `Win+[1-9]`: Select workspace by number (with no auto-back-and-forth)
* `Alt+Shift+[1-9]`: Move selected window to workspace
* `Alt+n`: Select next workspace on focused monitor
* `Alt+p`: Select previous workspace on focused monitor
* `Alt+Shift+n`: Create new workspace

### Notifications

* `Control+Shift+Comma`: Dismiss current notification
* `Control+Shift+Grave`: Restore previous notification
* `Control+Shift+Period`: Choose action for current notification

### Screenshots

* `Print`: Current screen (to new file)
* `Control+Print`: All screens (to clipboard)
* `Shift+Print`: Selected area (to new file)
* `Alt+Print`: All screens (to new file)
* `Control+Shift+Print`: Selected area (to clipboard)
* `Control+Alt+Print`: All screens (to clipboard)

### Menus

* `Alt+r`: Resize windows (with `h/j/k/l`)
* `Alt+m`: Monitor management (move focused monitor, ...)
* `Alt+Shift+m`: Mouse management (move cursor, click, ...)
* `Alt+Esc`: Power/Session management (logout, lock screen, power off, ...)
* `Alt+Shift+v`: Simple VPN management
* `Control+Alt+Shift+v`: Manual VPN management
* `Control+Alt+Shift+w`: Select wi-fi connection

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


### Other

* `Alt+Shift+p`: Select an output and mirror/present it


# Requirements

## sway

### Default Programs

* [`foot`](https://codeberg.org/dnkl/foot): Terminal Emulator
* [`mako`](https://wayland.emersion.fr/mako/): Notification Daemon
* [`kanshi`](https://github.com/emersion/kanshi): Multihead Profile Manager
* [`waybar`](https://github.com/Alexays/Waybar/): Status Bar
* [`rofi`](https://github.com/davatorium/rofi): Application Launcher
* [`swaylock`](https://github.com/swaywm/swaylock): Screen Locker
* [`swayidle`](https://github.com/swaywm/swayidle): Automatic Screen Locking
* [`pulseaudio`](https://www.x.org/wiki/): Audio Control
* [`playerctl`](https://github.com/acrisci/playerctl): Audio Player Control
* [`brightnessctl`](https://github.com/Hummer12007/brightnessctl): Backlight Control
* [`gammastep`](https://gitlab.com/chinstrap/gammastep): Color Correction
* [`dex`](https://github.com/jceb/dex): Autostart applications launcher

### Script Dependencies

* [`bash`](https://www.gnu.org/software/bash/): Interpreter for scripts
* [`python3`](https://www.python.org/): Scripting Language
* [`imagemagick`](https://imagemagick.org/index.php): Image manipulation (screen locking)
* [`python-pillow`](https://pillow.readthedocs.io/en/stable/): Imaging Library (for splitting screenshots for swaylock)
* [`grim`](https://github.com/emersion/grim): Screen Capture Utility
* [`slurp`](https://github.com/emersion/slurp): Screen Area Selection Utility (screenshots)
* `wl-copy` ([`wl-clipboard`](https://github.com/bugaevc/wl-clipboard)): Clipboard Utility (screenshots)
* [`jq`](https://stedolan.github.io/jq/): JSON Processor (for parsing IPC messages)
* [`polkit`](https://www.freedesktop.org/wiki/Software/polkit/): Authorization Manager (for allowing normal users to reboot, etc.)
* [`geoclue`](https://www.freedesktop.org/wiki/Software/GeoClue/): Geoinformation service (for color correction)
* [`wl-mirror`](https://github.com/Ferdi265/wl-mirror): Tool for mirroring outputs


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
