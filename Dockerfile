# syntax=docker/dockerfile:1.4
FROM ubuntu:26.10

# Set locale to C.UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

COPY resources/start_workbuddy.sh /usr/local/bin/start_workbuddy.sh
COPY resources/start_session.sh /usr/local/bin/start_session.sh

RUN --mount=type=bind,source=WorkBuddy.deb,target=/tmp/WorkBuddy.deb \
    --mount=type=bind,source=firefox.tar.xz,target=/tmp/firefox.tar.xz \
    --mount=type=bind,source=resources/workbuddy_cli_sandbox_patch.py,target=/tmp/workbuddy_cli_sandbox_patch.py \
    --mount=type=bind,source=resources/setup_firefox.sh,target=/tmp/setup_firefox.sh \
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to building the plain WorkBuddy Image." &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): First we update the apt-cache." &&\
    apt-get -y update &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Then we update the system to the latest package versions (1)." &&\
    apt-get -y --fix-missing --no-install-recommends install &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Then we update the system to the latest package versions (2)." &&\
    apt-get -y --with-new-pkgs --no-install-recommends upgrade &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing all packages required for WorkBuddy." &&\
	apt-get install -y --fix-missing \
        dbus \
        dbus-x11 \
        desktop-file-utils \
        dunst \
        libdbus-glib-1-2 \
        fonts-dejavu-core \
        fonts-dejavu-extra \
        fonts-noto-cjk \
		fuse \
		libasound2t64 \
        libcanberra-gtk3-module \
		libgbm1 \
		libdrm2 \
		libfuse2 \
		libgtk-3-0 \
		libnotify4 \
		libnss3 \
		libsecret-1-0 \
		libxcb-dri3-0 \
		libxcomposite1 \
		libxdamage1 \
		libxrandr2 \
		libxss1 \
        libxt6 \
        wget \
        xdg-desktop-portal \
        xdg-desktop-portal-gtk \
		xdg-utils \
        xz-utils &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Cleaning apt caches." &&\
    apt-get -y clean &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting useless cached files." &&\
	rm -rf /var/cache/apt/archives/ &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Unpacking Firefox browser." &&\
    tar xf /tmp/firefox.tar.xz -C /opt/ && \
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting up links." &&\
    export __browser="/usr/local/bin/firefox" &&\
    ln -s /opt/firefox/firefox "${__browser}" && \
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now making '${__browser}' the default browser." &&\
    update-alternatives --install /usr/bin/x-www-browser x-www-browser "${__browser}" 100 && \
    update-alternatives --set x-www-browser "${__browser}" && \
    update-alternatives --install /usr/bin/www-browser www-browser "${__browser}" 100 && \
    update-alternatives --set www-browser "${__browser}" && \
    update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser "${__browser}" 100 && \
    update-alternatives --set gnome-www-browser "${__browser}" &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating desktop entry." &&\
    echo '[Desktop Entry]' > /usr/share/applications/firefox.desktop && \
    echo 'Name=Firefox' >> /usr/share/applications/firefox.desktop && \
    echo "Exec=${__browser} %u" >> /usr/share/applications/firefox.desktop && \
    echo 'Type=Application' >> /usr/share/applications/firefox.desktop && \
    echo 'MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;' >> /usr/share/applications/firefox.desktop &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Updating MIME database." &&\
    update-desktop-database &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating dbus directory." &&\
    mkdir -p /var/run/dbus &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now updating fonts cache, so that WorkBuddy finds the Chinese fonts." &&\
    fc-cache -fv &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing WorkBuddy." &&\
    dpkg -i /tmp/WorkBuddy.deb &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the Chrome Sandbox used by WorkBuddy (1)." &&\
	chown root:root /opt/WorkBuddy/chrome-sandbox &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the Chrome Sandbox used by WorkBuddy (2)." &&\
	chmod 4755 /opt/WorkBuddy/chrome-sandbox &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the Chrome Sandbox used by WorkBuddy (3)." &&\
	echo "kernel.unprivileged_userns_clone=1" | tee /etc/sysctl.d/99-userns.conf &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now patching WorkBuddy binary to not use sandbox-cli, because otherwise some tools cannot be used." &&\
    python3 /tmp/workbuddy_cli_sandbox_patch.py &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating the plain user." &&\
    useradd -m -s /bin/bash user &&\
    export USER_ID="$(id -u user)" &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): User has user ID $USER_ID." &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating the dbus directories." &&\
    mkdir -p "/run/user/$USER_ID" &&\
    mkdir -p "/run/user/$USER_ID/dconf" &&\
    chown -R user:user "/run/user/$USER_ID" &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting appropriate permissions." &&\
    chmod -R 700 "/run/user/$USER_ID" &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Making start scripts executable." &&\
    chmod +x /usr/local/bin/start_workbuddy.sh &&\
    chmod +x /usr/local/bin/start_session.sh &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting up Firefox for user account." &&\
    su user -c "/bin/sh /tmp/setup_firefox.sh" &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): All is done, we built the image workbuddy_plain."

# This is needed so that we can share the display and actually start the GUI.
ENV DISPLAY=:0
ENV GDK_BACKEND=x11
ENV XDG_SESSION_TYPE=x11
ENV XDG_CURRENT_DESKTOP=GNOME

# This is need to allow WorkBuddy to execute commands outside the CLI sandbox.
# Without this and the patch that we apply to the binaries, you cannot run LEAN
# or any other tool that reserves (not even allocates) an address space beyond 4GB.
ENV WORKBUDDY_ENABLE_LINUX_SANDBOX_CLI=0

CMD [ "/usr/local/bin/start_session.sh" ]
