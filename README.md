[![https://thomasweise.github.io](https://shields.io/badge/home-thomasweise.github.io-009000)](https://thomasweise.github.io)

# A plain WorkBuddy Docker image.

## 1. Introduction
This is a plain [Docker](https://www.docker.com) image of the [WorkBuddy](https://www.workbuddy.cn) agent based on [Ubuntu](https://ubuntu.com) [Linux](https://thomasweise.github.io/tags/linux).
You can find the image at [`ghcr.io/thomasweise/workbuddy_plain`](https://github.com/thomasWeise/workbuddy_plain/pkgs/container/workbuddy_plain).

WorkBuddy normally runs in a Chrome Sandbox. 
However, here we put it *additionally* into a Docker container.
So it runs in a sandbox inside a container.

This has two advantages:

1. We can mount a directory into the container to share data.
   We also need to allow WorkBuddy to access the screen&nbsp;(and we had to weaken its inner sandbox [in some places](#4-additional-notes) to make it work).
   Apart from that, we can more or less keep the system isolated from it.
   This container is particularly intended for use with [rootless Docker](https://thomasweise.github.io/posts/2026-11-17-installing-rootless-docker-on-ubuntu-in-china) installations.
   This should at least keep your data isolated from the agent unless you want to explicitly share it, which should offer an additional layer of protection against errors.
2. By putting WorkBuddy into a container, we can develop images where all the software and tools that WorkBuddy needs are installed together in a consistent image.
   For example, in [`workbuddy_cs`](https://thomasweise.github.io/workbuddy_cs), we put a computer science pipeline on top this plain installation.
   Without the container, we would need to install many additional tools into our productive system.
   With the container, the setup and maintenance should become easier.

**Notice:** I am totally new to using AI tools.
Therefore, this is really a very very experimental setup.
I cannot guarantee that it will work.


## 2. Run the Image
You can either run this image via the provided script or manually.
Either way, after starting the container, you can log in as described in [Section&nbsp;3.1](#31-logging-in).
After that, you can use WorkBuddy as discussed in [Section&nbsp;3.2](#32-using-workbuddy).

**Connection Issues:**
If your internet connection is unstable, it may take a few attempts to download the image.
The image is not small.
This download issue only occurs during the first launch of the image&nbsp;(or if you update it later on).
If you experience connection issues, you can combine the [script-based execution](#21-run-it-via-provided-script) with our [`tryForever.sh`](https://thomasweise.github.io/posts/2026-03-09-repeating-until-success-linux) shell script.


### 2.1. Run it via provided Script
Under Ubuntu Linux, you can run the container with script [`workbuddy_plain_run.sh`](https://thomasweise.github.io/workbuddy_plain/workbuddy_plain_run.sh).
If the container image is not yet downloaded to your machine, this script will automatically download it.
This script will take three optional parameters:

- The directory to mount into WorkBuddy, by default `"/tmp/workbuddy"`.
  This folder will be created if it does not exist.
  You can point this to some folder with data in it that you want to share.
  The default setting just uses a temporary folder, where nothing important should be in.
  This directory should have reading and writing permissions for the container.
  The easiest way to do this is to `chmod 777 directory`.
  The files created by WorkBuddy will have read permissions for you only, so you can tell it to give all files read/write permissions for everyone.
- The version of the image to run, by default `"latest"`
- The mode of the image to use.
  By default, this uses the image [`ghcr.io/thomasweise/workbuddy_plain`](https://github.com/thomasWeise/workbuddy_plain/pkgs/container/workbuddy_plain) from the GitHub package repository.
  If you set this to `"local"`, then you can also run a Docker image that you built locally using, e.g., the scripts [`workbuddy_plain_build.sh`](https://thomasweise.github.io/workbuddy_plain/workbuddy_plain_build.sh) and our [`Dockerfile.sh`](https://thomasweise.github.io/workbuddy_plain/Dockerfile).


## 2.2. Run it by Hand from the Shell
Alternatively, you can run the image by hand.
This will also download the image if it is not downloaded yet.

Notice that in order to run the image properly, you need to first set `xhost +local:docker` on your system.
This is needed so that WorkBuddy can access your screen.
You would do something like

```bash
xhost +local:docker

docker run -it --rm \
  --name workbuddy \
  --network host \
  --cap-add SYS_ADMIN \
  --add-host=update.codebuddy.cn:127.0.0.1 \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /path/to/folder/you/want/to/mount/into/image:/home/user/workbuddy-data \
  "ghcr.io/thomasweise/workbuddy_plain:latest"
```

## 3. Usage
After you have started the container as described above, a WorkBuddy window will pop up.

### 3.1. Logging In
When you start the container, you first need to log in.
For this, you should ideally have a [WeChat](https://www.wechat.com/en) account.

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_1.png" style="width:50%;border:2px solid black;border-radius:8px" alt='The log in window appears. You click "Sign in" in the login screen.' />
<figcaption>The log in window appears. You click "Sign in" in the login screen.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_2.png" style="width:50%;border:2px solid black;border-radius:8px" alt="After the click, it may take a second until the container-internal browser pops up." />
<figcaption>After the click, it may take a second until the container-internal browser pops up.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_3.png" style="width:50%;border:2px solid black;border-radius:8px" alt=">It shows you a WeChat confirmation QR-code&nbsp;(here blotted out by the gray rectangle)." />
<figcaption>It shows you a <a href="https://www.wechat.com/en">WeChat</a> confirmation QR-code&nbsp;(here blotted out by the gray rectangle).</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_4.png" style="width:50%;border:2px solid black;border-radius:8px" alt="Using WeChat on your phone, you scan this QR code&hellip;" />
<figcaption>Using <a href="https://www.wechat.com/en">WeChat</a> on your phone, you scan this QR code&hellip;</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_5.png" style="width:50%;border:2px solid black;border-radius:8px" alt="&hellip;and allow it to use your information." />
<figcaption>&hellip;and allow it to use your information.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_6.png" style="width:50%;border:2px solid black;border-radius:8px" alt="The browser will change to a confirmation. After the browser content has changed, you can close it." />
<figcaption>The browser will change to a confirmation. After the browser content has changed, you can close it.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_sign_in_7.png" style="width:50%;border:2px solid black;border-radius:8px" alt="You are now logged into WorkBuddy." />
<figcaption>You are now logged into WorkBuddy.</figcaption>
</figure>


### 3.2. Using WorkBuddy
Now you can now use WorkBuddy.

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_example_1.png" style="width:50%;border:2px solid black;border-radius:8px" alt="Here I instruct WorkBuddy to create a simple Python file, run it, store its output in the shared folder, and set all permissions to the generated files so that I can edit them."/>
<figcaption>Here I instruct WorkBuddy to create a simple Python file, run it, store its output in the shared folder, and set all permissions to the generated files so that I can edit them.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_example_2.png" style="width:50%;border:2px solid black;border-radius:8px" alt="WorkBuddy begins to work." />
<figcaption>WorkBuddy begins to work.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_example_3.png" style="width:50%;border:2px solid black;border-radius:8px" alt="It shows me the contents of the file it created." />
<figcaption>It shows me the contents of the file it created.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_example_3.png" style="width:50%;border:2px solid black;border-radius:8px" alt="And it explains what it did." />
<figcaption>And it explains what it did.</figcaption>
</figure>

<figure>
<img src="https://thomasweise.github.io/workbuddy_plain/images/workbuddy_example_3.png" style="width:50%;border:2px solid black;border-radius:8px" alt="And the files appear indeed in the shared folder." />
<figcaption>And the files appear indeed in the shared folder.</figcaption>
</figure>


## 4. Additional Notes
It turns out that WorkBuddy in a working setup uses a sandbox client to execute shell commands.
This sandbox client seems to override the address space limit (`RLIMIT_AS`) to 4&nbsp;GB.
This causes some tools to fail.
For example, you cannot run [Lean](https://lean-lang.org) or [Java](https://openjdk.org).
Not because these tools would actually use that much memory.
But just because they reserve such an address range, seemingly.

This is quite annoying.
Normally, you could prevent this behavior by setting the environment variable `WORKBUDDY_ENABLE_LINUX_SANDBOX_CLI=0`.
It turns out, however, that WorkBuddy ignores and overrides this variable.
Therefore, we have to patch the file `/opt/WorkBuddy/resources/app.asar` on a binary level after installing WorkBuddy.
This way, we can disable the CLI sandbox.
Since we are inside a Docker container, this should be OK.
It is a bit dodgy, though, and whether the patch works or not may change during upgrades.

Also, in order to make things such as the "Save As"-dialog work, we need to run the internal dbus session with `GLYCIN_DISABLE_SANDBOX=i-know-the-risks`.
This weakens the sandbox inside the container, but the container boundary remains.


## 5. License
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


## 6. Contact
If you have any questions or suggestions, please contact
Prof. Dr. [Thomas Weise](https://thomasweise.github.io) (汤卫思教授) of the 
School of Artificial Intelligence and Big Data ([人工智能与大数据学院](http://www.hfuu.edu.cn/aibd)) at
[Hefei University](http://www.hfuu.edu.cn/english) ([合肥大学](http://www.hfuu.edu.cn)) in
Hefei, Anhui, China (中国安徽省合肥市) via
email to [tweise@hfuu.edu.cn](mailto:tweise@hfuu.edu.cn) with CC to [tweise@ustc.edu.cn](mailto:tweise@ustc.edu.cn).
