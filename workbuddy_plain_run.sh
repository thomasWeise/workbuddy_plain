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
  sharedDir="/tmp/workbuddy"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Mounting directory '$sharedDir' into WorkBuddy."
fi

sharedDir="$(realpath "$sharedDir")"
if [ -d "$sharedDir" ]; then
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Directory '$sharedDir' exists."
  echo "Did you make sure that the container will have write permissions?"
  echo "You could call 'chmod 777 \"$sharedDir\"' to ensure that."
else
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Directory '$sharedDir' does not exist, creating it."
  mkdir -p "$sharedDir"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting its permissions to 777."
  chmod 777 "$sharedDir"
  echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The shared directory now is created and has full permissions."
fi

image="$image:$version"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We will now run the WorkBuddy docker image '$image'."

docker run -it --rm \
  --name workbuddy \
  --network host \
  --cap-add SYS_ADMIN \
  --add-host=update.codebuddy.cn:127.0.0.1 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$sharedDir":/home/user/workbuddy-data \
  "$image"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done."
