# Firejail profile for opencode
# Description: An open source AI coding agent.
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include opencode.local
# Persistent global definitions
include globals.local

# allow executables in HOME, see disable-exec.inc
ignore noexec ${HOME}

# blacklisted by disable-programs.inc
noblacklist ${HOME}/.cache/opencode
noblacklist ${HOME}/.config/opencode
noblacklist ${HOME}/.local/share/opencode
noblacklist ${HOME}/.local/state/opencode

# Allows files commonly used by IDEs
include allow-common-devel.inc

# Disable Wayland
blacklist ${RUNUSER}/wayland-*
# Disable RUNUSER (cli only; supersedes Disable Wayland)
blacklist ${RUNUSER}
# Remove the next blacklist if your system has no /usr/libexec dir,
# otherwise try to add it.
blacklist /usr/libexec

# disable-*.inc includes
include disable-proc.inc
include disable-write-mnt.inc
include disable-x11.inc
include disable-xdg.inc

mkdir ${HOME}/.cache/opencode
whitelist ${HOME}/.cache/opencode
mkdir ${HOME}/.config/opencode
whitelist ${HOME}/.config/opencode
mkdir ${HOME}/.local/share/opencode
whitelist ${HOME}/.local/share/opencode
mkdir ${HOME}/.local/state/opencode
whitelist ${HOME}/.local/state/opencode

# Commands that reduce access to resources.
caps.drop all
##caps.keep CAPS
##hostname NAME
# CLI only
ipc-namespace
machine-id
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
#tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,ld.so.cache,ld.so.preload,machine-id,pki,resolv.conf,ssl
private-tmp

dbus-user none
dbus-system none

env NO_BROWSER=true
restrict-namespaces
