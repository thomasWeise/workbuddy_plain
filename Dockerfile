# syntax=docker/dockerfile:1.4
FROM ubuntu:26.10

# Set locale to C.UTF-8
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN --mount=type=bind,source=WorkBuddy.deb,target=/tmp/WorkBuddy.deb \
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to building the plain WorkBuddy Image." &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): First we update the apt-cache." &&\
    apt-get -y update &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Then we update the system to the latest package versions (1)." &&\
    apt-get -y --fix-missing --no-install-recommends install &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Then we update the system to the latest package versions (2)." &&\
    apt-get -y --with-new-pkgs --no-install-recommends upgrade &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing all packages required for WorkBuddy." &&\
	apt-get install -y --fix-missing  \
        dbus \
        dbus-x11 \
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
		xdg-utils &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Cleaning apt caches." &&\
    apt-get -y clean &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting useless cached files." &&\
	rm -rf /var/cache/apt/archives/ &&\
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
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating the plain user." &&\
    useradd -m -s /bin/bash user &&\
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating the dbus directory." &&\
    mkdir -p "/run/user/$(id -u user)" &&\
    chown user "/run/user/$(id -u user)" && \
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): All is done, we built the image workbuddy_plain."

ENV DISPLAY=:0
#ENV DBUS_SYSTEM_BUS_ADDRESS="unix:path=/var/run/dbus/system_bus_socket"

CMD ["sh", "-c", "dbus-daemon --system --fork && su user -c 'dbus-run-session -- /opt/WorkBuddy/workbuddy'" ]
#"'eval $(dbus-launch --sh-syntax)' && echo 'xxx'."]
#"/opt/WorkBuddy/workbuddy"]
