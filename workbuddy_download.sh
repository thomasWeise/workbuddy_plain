#!/bin/bash -

# Download the workbuddy deb file for Linux.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value


echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the WorkBuddy 'deb' Package Downloading Script."

jsonTemp="$(mktemp --suffix=.json)"
url="https://copilot.tencent.com/v2/update?platform=workbuddy-linux-x64-deb"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will download the JSON data from '$url' to the temporary file '$jsonTemp'."
curl -o "$jsonTemp" "$url"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now we extract the actual package URL."
url="$(jq -r ".url" "$jsonTemp")"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We got URL '$url'."
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We first delete the temporary file '$jsonTemp'."
rm "$jsonTemp"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now we download '$url' to 'WorkBuddy.deb'."
curl -o WorkBuddy.deb "$url"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): All done."
