FROM mcr.microsoft.com/vscode/devcontainers/base:focal

# install pico-sdk and get elf2uf2 tool
RUN apt-get update
RUN apt-get install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential libstdc++-arm-none-eabi-newlib
WORKDIR /root/
RUN git clone https://github.com/raspberrypi/pico-sdk
WORKDIR /root/pico-sdk/tools/elf2uf2
RUN cmake ./
RUN make -f Makefile
RUN mkdir /user-bin
RUN cp elf2uf2 /user-bin
WORKDIR /root/

# install GNAT community
RUN apt-get install -y fontconfig dbus libx11-xcb1 libncurses5 libxinerama1 libxrandr2 libxcursor1 libxi6 libxcb-shm0 xcb libxcb-render0
WORKDIR /user-bin
RUN mkdir GNAT2021-ARM-ELF
RUN git clone https://github.com/AdaCore/gnat_community_install_script
WORKDIR /user-bin/gnat_community_install_script

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


# install picotool
# RUN apt-get install -y libusb-1.0-0-dev
# WORKDIR /temp
# RUN git clone -b master https://github.com/raspberrypi/picotool.git
# RUN cd picotool
# RUN mkdir build
# RUN cd build
# RUN export PICO_SDK_PATH=~/pico/pico-sdk
# RUN cmake ../
# RUN make
