#!/bin/sh
#
# ufetch-termux - tiny system info for termux

## INFO

user="$(whoami)"
host="$(getprop net.hostname)"
os="$(uname -o) $(getprop ro.build.version.release)"
kernel="$(uname -sr)"
uptime="$(uptime | awk -F, '{sub(".*up ",x,$1);print $1}' | sed -e 's/^[ \t]*//')"
packages="$(pkg list-installed 2> /dev/null | tail -n +2 | wc -l)"
shell="$(basename "$SHELL")"

## UI DETECTION

if [ -n "${DE}" ]; then
	ui="${DE}"
	uitype='DE'
elif [ -n "${WM}" ]; then
	ui="${WM}"
	uitype='WM'
elif [ -n "${XDG_CURRENT_DESKTOP}" ]; then
	ui="${XDG_CURRENT_DESKTOP}"
	uitype='DE'
elif [ -n "${DESKTOP_SESSION}" ]; then
	ui="${DESKTOP_SESSION}"
	uitype='DE'
#elif [ -f "${HOME}/.xinitrc" ]; then
#	ui="$(tail -n 1 "${HOME}/.xinitrc" | cut -d ' ' -f 2)"
#	uitype='WM'
#elif [ -f "${HOME}/.xsession" ]; then
#	ui="$(tail -n 1 "${HOME}/.xsession" | cut -d ' ' -f 2)"
#	uitype='WM'
#elif [ -f "${HOME}/.vnc/xstartup" ]; then
#	ui="$(tail -n 1 "${HOME}/.vnc/xstartup" | cut -d ' ' -f 1)"
#	uitype='WM'
else
	ui='AOSP-based'
	uitype='UI'
fi

## DEFINE COLORS

# probably don't change these
bold="\033[1m"
black="\033[0;30m"
red="\033[0;31m"
green="\033[0;32m"
yellow="\033[0;33m"
blue="\033[0;34m"
magenta="\033[0;35m"
cyan="\033[0;36m"
white="\033[0;37m"
reset="\033[0m"

# you can change these
lc="${reset}${bold}${magenta}"        # labels
nc="${reset}${bold}${cyan}"        # user and hostname
ic="${reset}"                       # info
c0="${reset}${green}"               # first color
c1="${reset}${white}"               # second color
c2="${reset}${yellow}"              # third color

## OUTPUT

printf "
${c0}    ╲    ╱    ${nc}${user}${ic}@${nc}${host}${reset}
${c0}    ▟▀██▀▙    ${lc}OS:      ${ic}${os}${reset}
${c0}   ▟█▆██▆█▙   ${lc}KERNEL:  ${ic}${kernel}${reset}
${c0} ▄ ▄▄▄▄▄▄▄▄ ▄ ${lc}UPTIME:  ${ic}${uptime}${reset}
${c0} █ ████████ █ ${lc}PKGS:    ${ic}${packages}${reset} 
${c0}   ▜██████▛   ${lc}SHELL:   ${ic}${shell}${reset}
${c0}    █▌  ▐█    ${lc}${uitype}:      ${ic}${ui}${reset}

"
