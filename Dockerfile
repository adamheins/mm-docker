FROM osrf/ros:noetic-desktop-full

# Arguments
ARG user
ARG uid
ARG home
ARG shell

# Basic Utilities
RUN apt-get -y update
RUN apt-get install -y git zsh curl screen tree sudo ssh synaptic vim udev iputils-ping

# Python
RUN apt-get install -y python3-dev python3-pip
RUN python3 -m pip install --upgrade pip

# Additional development tools
RUN apt-get install -y x11-apps build-essential
RUN pip install catkin_tools numpy

# Just for kitty terminal
RUN apt install kitty-terminfo

# Orbbec dependencies
RUN apt install -y libgflags-dev ros-noetic-image-geometry ros-noetic-camera-info-manager \
ros-noetic-image-transport-plugins ros-noetic-compressed-image-transport \
ros-noetic-image-transport ros-noetic-image-publisher libgoogle-glog-dev libusb-1.0-0-dev libeigen3-dev \
ros-noetic-diagnostic-updater ros-noetic-diagnostic-msgs \
libdw-dev

# Other dependencies
RUN apt install -y ros-noetic-eigenpy ros-noetic-pybind11-catkin ros-noetic-moveit libglpk-dev ros-noetic-soem ros-noetic-socketcan-interface

# Make SSH available
EXPOSE 22

# Mount the user's home directory
VOLUME "${home}"

# Clone user into docker image and set up X11 sharing
RUN \
  echo "${user}:x:${uid}:${uid}:${user},,,:${home}:${shell}" >> /etc/passwd && \
  echo "${user}:x:${uid}:" >> /etc/group && \
  echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" && \
  chmod 0440 "/etc/sudoers.d/${user}"

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN echo "${user}:docker" | chpasswd
# this allows to switch to user with $ su -
RUN echo "root:docker" | chpasswd

# real robot network setup
RUN echo "192.168.131.1 cpr-tor11-01" >> /etc/hosts

# Switch to user
USER "${user}"

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

WORKDIR ${home}
