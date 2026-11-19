#!/bin/bash -

# Prepare the WorkBuddy container.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the WorkBuddy image preparation script."

if [ -f "WorkBuddy.deb" ]; then
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): WorkBuddy.deb exists, no need to download it."
else
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): WorkBuddy.deb does not exist, need to download it."
    scriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The directory with the download script is '$scriptDir'."
    "$scriptDir/workbuddy_download.sh"
  if [ -f "WorkBuddy.deb" ]; then
      echo "$(date +'%0Y-%0m-%0d %0R:%0S'): WorkBuddy.deb successfully downloaded."
  else
      echo "$(date +'%0Y-%0m-%0d %0R:%0S'): WorkBuddy.deb still does not exist, aborting."
      exit 1
  fi
fi

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We delete any potentially existing old images."
docker image rm workbuddy_plain || true
docker image rm workbuddy_plain || true

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now we build the plain image."
docker build --progress=plain -t workbuddy_plain .

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): All done."
