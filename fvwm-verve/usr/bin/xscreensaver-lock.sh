#!/bin/sh

. /usr/share/acpi-support/power-funcs

export CMD=$1
# Lock xscreensaver on resume from a suspend.

getXconsole() {
	local displaynum
	displaynum=$1

	if [ "$displaynum" ]; then
		DISPLAY=":$displaynum"
		export DISPLAY
		getXuser
	fi
}


if pidof xscreensaver > /dev/null; then
    #loginctl list-sessions|awk '$1 ~ /^[0-9]/ {print $1,$3}'|while read session user; do
    #loginctl list-users|awk '$1 ~ /[0-9]*/ {print $2}'|while read user;do
    /bin/loginctl --no-legend list-users|awk '$1 ~ /[0-9]*/ {print $2}'|while read XUSER;do
	echo "lock screen from user $XUSER"
	#getXuser $user $session;
    #ck-list-sessions | awk 'BEGIN { active = 0; } /^Session/ { active = 1; } active && /x11-display = '\':.+\''/ { gsub(/'\':*'/,"",$3); print $3; }'|while read disp; do    
	#getXconsole $disp
#        if [ x"$XAUTHORITY" != x"" ]; then
               case "$CMD" in
                   resume|thaw)
                       sudo -u $XUSER xscreensaver-command -unthrottle
                   ;;
                   suspend|hibernate)
			echo "XUSER: $XUSER"|logger -t $0
			#sudo -u $XUSER xscreensaver-command -throttle
			#sudo -u $XUSER xscreensaver-command -lock
			su -c "/usr/bin/xscreensaver-command -throttle" $XUSER
			su -c "/usr/bin/xscreensaver-command -lock" $XUSER
   		       #loginctl lock-session $session
                   ;;
		   *)
			echo IRGENDWAS;;
               esac
#        fi
    done
fi

loginctl --no-legend list-sessions |while read XSESSION XUID XUSER XSEAT;do
	case $CMD in
		resume|thaw)
			;;
		suspend|hibernate)
			echo "lock session $XSESSION from $XUSER on $XSEAT"
			loginctl lock-session $XSESSION
			;;
	esac
done

exit 0
