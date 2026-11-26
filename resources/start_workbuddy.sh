#!/bin/bash -

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Getting user ID for user 'user'."
USER_ID="$(id -u user)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): User ID for user 'user' is $USER_ID, now setting XDG_RUNTIME_DIR."
export XDG_RUNTIME_DIR=/run/user/$USER_ID
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Set XDG_RUNTIME_DIR to $XDG_RUNTIME_DIR."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Launching dunst in parallel."
nohup dunst > /dev/null 2>&1 &

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Launching WorkBuddy."
"/opt/WorkBuddy/workbuddy"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): WorkBuddy has terminated."
