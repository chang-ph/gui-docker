#!/bin/bash
OUR_IP=$(hostname -i)

# start VNC server (Uses VNC_PASSWD Docker ENV variable)
mkdir -p $HOME/.vnc && echo "$VNC_PASSWD" | vncpasswd -f >$HOME/.vnc/passwd
# Remove potential lock files created from a previously stopped session
rm -rf /tmp/.X*
vncserver :0 -localhost no -nolisten -rfbauth $HOME/.vnc/passwd -xstartup /opt/x11vnc_entrypoint.sh
