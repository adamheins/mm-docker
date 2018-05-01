# rosdocked

Run ROS Indigo / Ubuntu Trusty within Docker on Ubuntu Xenial or on any
platform with a shared username, home directory, and X11.

This enables you to build and run a persistent ROS Indigo workspace as long as
you can run Docker images.

Note that any changes made outside of your home directory from within the
Docker environment will not persist. If you want to add additional binary
packages without having to reinstall them each time, add them to the Dockerfile
and rebuild.

For more info on Docker see here:
https://docs.docker.com/engine/installation/linux/ubuntulinux/

## Thing

This is a fork specifically designed for running the
[Thing](https://github.com/utiasSTARS/thing) robot manipulator code. The
original repository may be found [here](https://github.com/jbohren/rosdocked).

## Usage
* The name of your image must be in a file called `image_name.txt`.
* `build-image.sh` builds the image named in `image_name.txt`, following the
  directions laid out in the `Dockerfile`.
* `new-container.sh` creates a new container from the latest image and
  automatically attaches to it. The container shares your home directory.
* `restart-container.sh` restarts an existing container that has been stopped.
* `attach-to-container.sh` attaches to an already-running container.
