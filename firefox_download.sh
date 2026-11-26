#!/bin/bash -

# Download the firefox archive file for Linux.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value


echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the Firefox Package Download Script."

curl -o firefox.tar.xz "https://download-installer.cdn.mozilla.net/pub/firefox/releases/153.8.0esr/linux-x86_64/en-US/firefox-153.8.0esr.tar.xz" ||

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): All done."
