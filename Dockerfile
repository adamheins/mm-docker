FROM osrf/ros:indigo-desktop-full

# Arguments
ARG user
ARG uid
ARG home
ARG shell

# Basic Utilities
RUN apt-get -y update
RUN apt-get install -y git zsh curl screen tree sudo ssh synaptic vim

# Python.
RUN apt-get install -y python-dev python-pip python3-dev python3-pip
RUN pip install --upgrade pip
RUN pip3 install --upgrade pip

# Additional development tools
RUN apt-get install -y x11-apps build-essential
RUN pip install catkin_tools numpy


# mm dependencies
RUN apt-get install -y ros-indigo-soem ros-indigo-ur-modern-driver libeigen3-dev

# Symlink Eigen.
RUN ln -s /usr/include/eigen3/Eigen /usr/include/Eigen

# Thing dependencies.
RUN apt-get install -y \
  ros-indigo-ros-control ros-indigo-socketcan-interface \
  ros-indigo-moveit ros-indigo-ur-modern-driver ros-indigo-geometry2 \
  ros-indigo-robot-localization ros-indigo-hector-gazebo \
  ros-indigo-gazebo-ros-control

RUN ln -s /usr/include/gazebo-2.2/gazebo /usr/include/gazebo
RUN ln -s /usr/include/sdformat-1.4/sdf /usr/include/sdf

# Install ffmpeg to play sound.
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:mc3man/trusty-media
RUN apt-get update
RUN apt-get install -y ffmpeg

# pydub for playing audio from Python
RUN pip install pydub

# Allow user to access sound devices
RUN usermod -a -G audio "${user}"

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

# Switch to user
USER "${user}"

# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1

WORKDIR ${home}
