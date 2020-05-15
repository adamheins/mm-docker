# rosdocked

Originally forked from [here](https://github.com/jbohren/rosdocked), this fork
is specifically designed for running UTIAS mobile manipulator code.

Run Ubuntu 14.04 with ROS Indigo with a shared username, home directory, and
X11 graphics on a computer with a different Ubuntu version. Requires
[Docker](https://docs.docker.com/engine/installation/linux/ubuntulinux/):
```
sudo apt install docker-ce
```

Note that any changes made outside of your home directory from within the
Docker environment will not persist. If you want to add additional binary
packages without having to reinstall them each time, add them to the Dockerfile
and rebuild.

## NVIDIA

If your laptop has an NVIDIA graphics card, you'll need to use the `nvidia`
branch. That branch includes NVIDIA support by leveraging [this
Dockerfile](https://hub.docker.com/r/lindwaltz/ros-indigo-desktop-full-nvidia/).
This used to require installing a separate package `nvidia-docker2`, but Docker
now supports NVIDIA natively since version 19.03.

## macOS

It is not immediately obvious how to get this working on a Mac. There are
definitely some differences from Linux, and [this post](http://qr.ae/TUTszl)
may provide a reasonable starting point.

## Usage

1. The name of your image must be in a file called `image_name.txt`.
2. Run `build-image.sh` to build your image, based on the provided Dockerfile.
   This only needs to be done once unless you make changes to the Dockerfile.
3. Run `new-container.sh` to create a container from your built image. This
   only needs to be done once unless you wish to reset the environment of the
   container. This script will also automatically enter the newly created
   container.
4. If an existing container has been stopped (e.g., if you restarted your
   computer), run `restart-container.sh` to restart it. This does **not**
   automatically enter the newly created container; to do this, run
   `attach-to-container.sh`. You can also run `attach-to-container.sh` from any
   new terminal sessions to attach to the same running container.

## Sourcing ROS

You may now be using multiple ROS versions on the same computer: Indigo with
this Docker image and another for your actual Ubuntu version. You can add
something like the following to your .bashrc to choose the right one:
```bash
# for example, with ROS kinetic on my base system
if [ -d /opt/ros/kinetic ]; then
  source /opt/ros/kinetic/setup.zsh
elif [ -d /opt/ros/indigo ]; then
  source /opt/ros/indigo/setup.zsh
fi
```

## Useful Docker Commands

* `docker ps`: List running containers. If you see your container running here,
  you can attach to it.
* `docker ps -a`: List all containers (running and stopped).
* `docker images`: List docker images.
