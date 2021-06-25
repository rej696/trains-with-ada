FROM ubuntu
RUN apt update && apt upgrade -y
# COPY . /project
WORKDIR /root/

# install vnc tools
RUN apt install -y x11vnc xvfb
RUN apt install -y curl unzip

# setup git
RUN apt install -y apt-utils git
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
RUN git config --global user.name $GIT_USER_NAME
RUN git config --global user.email $GIT_USER_EMAIL

# install pico-sdk and get elf2uf2 tool
RUN apt install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential libstdc++-arm-none-eabi-newlib
WORKDIR /root/
RUN git clone https://github.com/raspberrypi/pico-sdk
WORKDIR /root/pico-sdk/tools/elf2uf2
RUN cmake ./
RUN make -f Makefile
RUN mkdir /user-bin
RUN cp elf2uf2 /user-bin
WORKDIR /root/

# install GNAT community
RUN apt install -y fontconfig dbus libx11-xcb1 libncurses5 libxinerama1 libxrandr2 libxcursor1 libxi6 libxcb-shm0 xcb libxcb-render0
WORKDIR /user-bin
RUN mkdir GNAT2021
RUN mkdir GNAT2021-ARM-ELF
RUN git clone https://github.com/AdaCore/gnat_community_install_script
WORKDIR /user-bin/gnat_community_install_script
RUN curl -o gnat2021-bin -L https://community.download.adacore.com/v1/f3a99d283f7b3d07293b2e1d07de00e31e332325?filename=gnat-2021-20210519-x86_64-linux-bin
RUN ./install_package.sh ./gnat2021-bin /user-bin/GNAT2021

# install GNAT ARM ELF
RUN curl -o gnat2021-armelf-bin -L https://community.download.adacore.com/v1/2ceb9d1ada2029d79556b710c6c4834cade3749f?filename=gnat-2021-20210519-arm-elf-linux64-bin
RUN ./install_package.sh ./gnat2021-armelf-bin /user-bin/GNAT2021-ARM-ELF
RUN echo "export PATH=$PATH:/user-bin:/user-bin/GNAT2021/bin:/user-bin/GNAT2021-ARM-ELF/bin" >> /root/.bashrc

# clean up
RUN rm -r /user-bin/gnat_community_install_script/


# install Alire
WORKDIR /user-bin
RUN curl -OL https://github.com/alire-project/alire/releases/download/v1.0.1/alr-1.0.1-bin-linux.zip
RUN unzip alr-1.0.1-bin-linux.zip
RUN mv ./bin/alr ./alr
RUN rm LICENSE.txt
RUN rm alr-1.0.1-bin-linux.zip
RUN rm -r bin
WORKDIR /root/


# clone project repo
WORKDIR /root/
ARG GITHUB_TOKEN
RUN git clone https://${GITHUB_TOKEN}@github.com/rej696/trains-with-ada.git


# install desktop environment
ARG DEBIAN_FRONTEND=noninteractive
RUN apt install -y xfce4
RUN echo "setxkbmap -layout gb" >> ~/.xinitrc
RUN echo "exec startxfce4" >> ~/.xinitrc && chmod +x ~/.xinitrc

# add alr edit command to .xinitrc
# RUN echo "exec alr edit --project=~/trains-with-ada/project/project.gpr" >> ~/.xinitrc && chmod +x ~/.xinitrc

# run vnc server
CMD ["x11vnc", "-create", "-forever"]

# instructions for building and running
# docker build -t trains-with-ada:v1
# docker run 
