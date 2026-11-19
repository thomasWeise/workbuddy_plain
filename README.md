# A plain WorkBuddy Docker image.

## 1. Introduction
This is a plain [Docker](https://www.docker.com) image of the [WorkBuddy](https://www.workbuddy.cn) agent.
It is based on an [Ubuntu](https://ubuntu.com) [Linux](https://thomasweise.github.io/tags/linux) image.
It is intended for use in particular with [rootless Docker](https://thomasweise.github.io/posts/2026-11-17-installing-rootless-docker-on-ubuntu-in-china) installations.

**Notice:** I am totally new to using AI tools.
Therefore, this is really a very very experimental setup.
I cannot guarantee that it will work.


## 2. Run the Image
You can either run this image via the provided script or manually.
Either way, the WorkBuddy login window will pop up.
It would provide you with a link to copy into your browser.
Then, you can authenticate/login via your browser.
After that, WorkBuddy can be used.


### 2.1. Run it via provided Script
Under Ubuntu Linux, you can run it with script [`workbuddy_plain_run.sh`](https://thomasweise.github.io/workbuddy_plain/workbuddy_plain_run.sh).
This script will take three optional parameters:

- The directory to mount into WorkBuddy, by default `"."`
- The version of the image to run, by default `"latest"`
- The mode of the image to use.
  By default, this uses the image `ghcr.io/thomasweise/workbuddy_plain` from the GitHub package repository.
  If you set this `"local"`, then you can also run a Docker image that you built locally using, e.g., the scripts [`workbuddy_plain_build.sh`](https://thomasweise.github.io/workbuddy_plain/workbuddy_plain_build.sh) and our [`Dockerfile.sh`](https://thomasweise.github.io/workbuddy_plain/Dockerfile).


## 2.2. Run it by Hand from the Shell
Alternatively, you can run the image by hand.

Notice that in order to run the image properly, you need to first set `xhost +local:docker` on your system.
This is needed so that WorkBuddy can access your screen.
You would do something like

```bash
xhost +local:docker

docker run -it --rm \
  --name workbuddy \
  --network host \
  --cap-add SYS_ADMIN \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /path/to/folder/you/want/to/mount/into/image:/home/user/workbuddy-data \
  "ghcr.io/thomasweise/workbuddy_plain:latest"
```


## 3. License
Copyright (C) 2026  [Thomas Weise](https://thomasweise.github.io) (汤卫思教授)

Dr. [Thomas Weise](https://thomasweise.github.io) (see [Contact](#12-contact)) holds the copyright of these scripts.
The scripts are provided to the public as open source software under the [GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007](https://thomasweise.github.io/moptipy/LICENSE.html).

**This license only here applies to the scripts in this package.
It obviously does NOT apply to the WorkBuddy software, Docker itself, or anything else contained in the Docker images.
These are obviously under the copyright of their copyright holders.**

All scripts here are free software: you can redistribute them and/or modify them under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
All scripts and programs here are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
You should have received a copy of the GNU General Public License along with them.
If not, see <https://www.gnu.org/licenses/>.

**If you feel that this repository or image infringes any of your property rights, please contact me.**


## 4. Contact
If you have any questions or suggestions, please contact
Prof. Dr. [Thomas Weise](https://thomasweise.github.io) (汤卫思教授) of the 
School of Artificial Intelligence and Big Data ([人工智能与大数据学院](http://www.hfuu.edu.cn/aibd)) at
[Hefei University](http://www.hfuu.edu.cn/english) ([合肥大学](http://www.hfuu.edu.cn)) in
Hefei, Anhui, China (中国安徽省合肥市) via
email to [tweise@hfuu.edu.cn](mailto:tweise@hfuu.edu.cn) with CC to [tweise@ustc.edu.cn](mailto:tweise@ustc.edu.cn).
