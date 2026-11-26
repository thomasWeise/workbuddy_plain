# syntax=docker/dockerfile:1.4
FROM ubuntu:26.10

# Set locale to C.UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

COPY resources/start_workbuddy.sh /usr/local/bin/start_workbuddy.sh
COPY resources/start_session.sh /usr/local/bin/start_session.sh

RUN --mount=type=bind,source=WorkBuddy.deb,target=/tmp/WorkBuddy.deb \
    --mount=type=bind,source=firefox.tar.xz,target=/tmp/firefox.tar.xz \
    --mount=type=bind,source=resources/install_dbus.sh,target=/tmp/install_dbus.sh \
    --mount=type=bind,source=resources/workbuddy_cli_sandbox_patch.py,target=/tmp/workbuddy_cli_sandbox_patch.py \
    --mount=type=bind,source=resources/install_firefox_root.sh,target=/tmp/install_firefox_root.sh \
    --mount=type=bind,source=resources/install_firefox_user.sh,target=/tmp/install_firefox_user.sh \
    --mount=type=bind,source=resources/install_workbuddy.sh,target=/tmp/install_workbuddy.sh \
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to building the plain WorkBuddy Image." &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): First we update the apt-cache." &&\
    apt-get -y update &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Then we update the system to the latest package versions (1)." &&\
    apt-get -y --fix-missing --no-install-recommends install &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Then we update the system to the latest package versions (2)." &&\
    apt-get -y --with-new-pkgs --no-install-recommends upgrade &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing all packages required for WorkBuddy." &&\
	apt-get install -y --fix-missing \
        adwaita-icon-theme \
        adwaita-icon-theme-full \
        dbus \
        dbus-x11 \
        desktop-file-utils \
        dunst \
        libdbus-glib-1-2 \
        fonts-dejavu-core \
        fonts-dejavu-extra \
        fonts-noto-cjk \
		fuse \
        hicolor-icon-theme \
		libasound2t64 \
        libcanberra-gtk3-module \
		libgbm1 \
		libdrm2 \
		libfuse2 \
        libgdk-pixbuf-2.0-0 \
        libgdk-pixbuf2.0-bin \
		libgtk-3-0 \
		libnotify4 \
		libnss3 \
        librsvg2-2 \
        librsvg2-common \
		libsecret-1-0 \
		libxcb-dri3-0 \
		libxcomposite1 \
		libxdamage1 \
		libxrandr2 \
		libxss1 \
        libxt6 \
        shared-mime-info \
        wget \
        xdg-desktop-portal \
        xdg-desktop-portal-gtk \
		xdg-utils \
        xz-utils &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Cleaning apt caches." &&\
    apt-get -y clean &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting useless cached files." &&\
	rm -rf /var/cache/apt/archives/ &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now updating fonts cache, so that WorkBuddy finds the Chinese fonts." &&\
    fc-cache -fv &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Invoking Firefox installer." &&\
    /bin/sh /tmp/install_firefox_root.sh &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Invoking WorkBuddy installing." &&\
    /bin/sh /tmp/install_workbuddy.sh &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating the plain user." &&\
    useradd -m -s /bin/bash user &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Invoking dbus installer." &&\
    /bin/sh /tmp/install_dbus.sh &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Making start scripts executable." &&\
    chmod +x /usr/local/bin/start_workbuddy.sh &&\
    chmod +x /usr/local/bin/start_session.sh &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting up Firefox for user account." &&\
    su user -c "/bin/sh /tmp/install_firefox_user.sh" &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): All is done, we built the image workbuddy_plain."

# This is needed so that we can share the display and actually start the GUI.
ENV DISPLAY=:0
ENV GDK_BACKEND=x11
ENV XDG_SESSION_TYPE=x11
ENV XDG_CURRENT_DESKTOP=GNOME
ENV GDK_PIXBUF_MODULEDIR=/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/2.10.0/loaders

# This is need to allow WorkBuddy to execute commands outside the CLI sandbox.
# Without this and the patch that we apply to the binaries, you cannot run LEAN
# or any other tool that reserves (not even allocates) an address space beyond 4GB.
ENV WORKBUDDY_ENABLE_LINUX_SANDBOX_CLI=0

CMD [ "/usr/local/bin/start_session.sh" ]
