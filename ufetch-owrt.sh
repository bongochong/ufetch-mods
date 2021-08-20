#!/bin/sh
#
# ufetch-owrt - tiny system info for OpenWrt

## INFO

user="$(id -un)"
host="$(uname -n)"
os="$(cat /etc/openwrt_release | grep DISTRIB_DESCRIPTION | sed "s/^.*\(OpenWrt.*.\S\s\).*$/\1/")"
kernel="$(uname -srm)"
uptime="$(uptime | awk -F, '{sub(".*up ",x,$1);print $1}' | sed -e 's/^[ \t]*//')"
packages="$(opkg list-installed 2> /dev/null | tail -n +1 | wc -l)"
shell="$(basename "$SHELL")"

## UI DETECTION

if [ -f "${HOME}/.xinitrc" ]; then
	ui="$(tail -n 1 "${HOME}/.xinitrc" | cut -d ' ' -f 2)"
	uitype='WM'
elif [ -f "${HOME}/.xsession" ]; then
	ui="$(tail -n 1 "${HOME}/.xsession" | cut -d ' ' -f 2)"
	uitype='WM'
elif [ -f "${HOME}/.vnc/xstartup" ]; then
	ui="$(tail -n 1 "${HOME}/.vnc/xstartup" | cut -d ' ' -f 1)"
	uitype='WM'
else
	ui='CLI'
	uitype='Shell'
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
c1="${reset}${blue}"               # second color
c2="${reset}${yellow}"              # third color

## OUTPUT

printf "
${c0}      ___     ${nc}${USER}${ic}@${nc}${host}${reset}
${c0}     (${c1}.. ${c0}\    ${lc}OS:        ${ic}${os}${reset}
${c0}     (${c2}<> ${c0}|    ${lc}KERNEL:    ${ic}${kernel}${reset}
${c0}    /${c1}/  \\ ${c0}\\   ${lc}UPTIME:    ${ic}${uptime}${reset}
${c0}   ( ${c1}|  | ${c0}/|  ${lc}PACKAGES:  ${ic}${packages}${reset} 
${c2}  _${c0}/\\ ${c1}__)${c0}/${c2}_${c0})  ${lc}SHELL:     ${ic}${shell}${reset}
${c2}  \/${c0}-____${c2}\/${reset}   ${lc}${uitype}:        ${ic}${ui}${reset}

"
