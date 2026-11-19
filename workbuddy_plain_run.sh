#!/bin/bash -

# Run the plain WorkBuddy docker container.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will now run the WorkBuddy docker container."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the shared screen."
xhost +local:docker

sharedDir="${1:-}"
version="${2:-}"
execMode="${3:-}"

image="workbuddy_plain"
if [ "$execMode" == "local" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Using local image."
else
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Using repository image."
  image="ghcr.io/thomasweise/$image"
fi

if [ -n "$version" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Using version '$version'."
else
  version="latest"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Using '$version' version."
fi

if [ -n "$sharedDir" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Mounting provided '$sharedDir' into WorkBuddy."
else
  sharedDir="."
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Mounting current directory '$sharedDir' into WorkBuddy."
fi
sharedDir="$(realpath "$sharedDir")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The fully expanded shared directory is '$sharedDir'."

image="$image:$version"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will now run the WorkBuddy docker image '$image'."

docker run -it --rm \
  --name workbuddy \
  --network host \
  --cap-add SYS_ADMIN \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$sharedDir":/home/user/workbuddy-data \
  "$image"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done."
