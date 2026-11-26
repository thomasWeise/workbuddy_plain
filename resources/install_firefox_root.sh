#!/bin/bash -

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing Firefox."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Unpacking Firefox browser."
tar xf /tmp/firefox.tar.xz -C /opt/

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting up links."
export __browser="/usr/local/bin/firefox"
ln -s /opt/firefox/firefox "${__browser}"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now making '${__browser}' the default browser."
update-alternatives --install /usr/bin/x-www-browser x-www-browser "${__browser}" 100
update-alternatives --set x-www-browser "${__browser}"
update-alternatives --install /usr/bin/www-browser www-browser "${__browser}" 100
update-alternatives --set www-browser "${__browser}"
update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser "${__browser}" 100
update-alternatives --set gnome-www-browser "${__browser}"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating desktop entry."
echo '[Desktop Entry]' > /usr/share/applications/firefox.desktop
echo 'Name=Firefox' >> /usr/share/applications/firefox.desktop
echo "Exec=${__browser} %u" >> /usr/share/applications/firefox.desktop
echo 'Type=Application' >> /usr/share/applications/firefox.desktop
echo 'MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;' >> /usr/share/applications/firefox.desktop

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Updating MIME database (1)."
update-desktop-database

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Updating MIME database (2)."
update-mime-database /usr/share/mime

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done installing Firefox."
