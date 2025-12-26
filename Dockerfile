FROM    ubuntu:22.04

# for the VNC connection
EXPOSE 5900
# for the browser VNC client
EXPOSE 5901
# Use environment variable to allow custom VNC passwords
ENV VNC_PASSWD=123456

# Make sure the dependencies are met
ENV APT_INSTALL_PRE="apt -o Acquire::ForceIPv4=true update && DEBIAN_FRONTEND=noninteractive apt -o Acquire::ForceIPv4=true install -y --no-install-recommends"
ENV APT_INSTALL_POST="&& apt clean -y && rm -rf /var/lib/apt/lists/*"


# Make sure the dependencies are met
RUN eval ${APT_INSTALL_PRE} curl sudo tigervnc-standalone-server tigervnc-common tigervnc-tools fluxbox eterm xterm git net-tools python3 python3-numpy ca-certificates scrot pulseaudio-utils ${APT_INSTALL_POST}
RUN curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb && eval ${APT_INSTALL_PRE} /tmp/chrome.deb ${APT_INSTALL_POST} && rm /tmp/chrome.deb

# Add menu entries to the container
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker && update-menus
RUN echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Google Chrome\" command=\"google-chrome --no-sandbox\"" >> /usr/share/menu/custom-docker && update-menus

# Set timezone to UTC
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

ENV UID_OF_DOCKERUSER=1000
RUN sed  's/%sudo\s\+ALL=(ALL:ALL)\s\+ALL/%sudo        ALL=(ALL:ALL) NOPASSWD :ALL/' /etc/sudoers
RUN useradd -m -s /bin/bash -U -G sudo -p 1234 -u ${UID_OF_DOCKERUSER} cph
RUN chown -R cph:cph /home/cph && chown cph:cph /opt

USER cph

# Copy various files to their respective places
COPY container_startup.sh /opt/container_startup.sh
COPY x11vnc_entrypoint.sh /opt/x11vnc_entrypoint.sh
# Subsequent images can put their scripts to run at startup here
RUN mkdir /opt/startup_scripts

ENTRYPOINT ["/opt/container_startup.sh"]
