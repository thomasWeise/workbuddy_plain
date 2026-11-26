#!/bin/bash -

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value


inner="${1:-}"
if [ -n "$inner" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): '$inner' provided as inner script to execute inside dbus session."
else
  inner="/usr/local/bin/start_workbuddy.sh"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will use '$inner' as the default script for dbus sessions."
fi

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Getting user ID for user 'user'."
USER_ID="$(id -u user)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): User ID for user 'user' is $USER_ID, now setting XDG_RUNTIME_DIR."
export XDG_RUNTIME_DIR=/run/user/$USER_ID
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Set XDG_RUNTIME_DIR to $XDG_RUNTIME_DIR."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Making sure that the dbus-daemon can be started."
rm -f /run/dbus/pid

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Launching dbus-daemon."
dbus-daemon --system --fork

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Launching session and executing '$inner'."
su user -c "GLYCIN_DISABLE_SANDBOX=i-know-the-risks dbus-run-session -- ${inner}"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Session has terminated."
