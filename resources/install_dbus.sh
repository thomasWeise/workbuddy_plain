#!/bin/bash -

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing dbus et al."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating dbus directory."
mkdir -p /var/run/dbus

export USER_ID="$(id -u user)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): User has user ID $USER_ID."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Creating the dbus directories."
mkdir -p "/run/user/$USER_ID"
mkdir -p "/run/user/$USER_ID/dconf"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting directory owner."
chown -R user:user "/run/user/$USER_ID"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting appropriate permissions."
chmod -R 700 "/run/user/$USER_ID"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting access rights for mime folder."
chmod -R uga-x /usr/share/mime
chmod -R ugo+X /usr/share/mime

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Making gdk-pixbuf-query-loaders available."
ln -s "/usr/lib/x86_64-linux-gnu/gdk-pixbuf-2.0/gdk-pixbuf-query-loaders" "/usr/local/bin/gdk-pixbuf-query-loaders"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Update the GDK Pixbuf loader cache."
gdk-pixbuf-query-loaders --update-cache

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting access rights for mime folder again, just in case."
chmod -R uga-x /usr/share/mime
chmod -R ugo+X /usr/share/mime

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Updating icon cache."
gtk-update-icon-cache -f -t /usr/share/icons/Adwaita
gtk-update-icon-cache -f -t /usr/share/icons/hicolor


echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done installing dbus et al."
