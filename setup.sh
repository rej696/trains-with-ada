sudo apt update && apt upgrade -y;
sudo apt install -y apt-utils git;
git config --global user.name $1;
git config --global user.email $2;

cd ~;
rm -r Desktop Documents Downloads Music Pictures Public Templates Videos;

# install pico-sdk and get elf2uf2 tool
sudo apt install -y cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential libstdc++-arm-none-eabi-newlib;
cd ~;
git clone https://github.com/raspberrypi/pico-sdk;
cd ~/pico-sdk/tools/elf2uf2;
cmake ./;
make -f Makefile;
mkdir ~/user-bin;
cp elf2uf2 ~/user-bin;
cd ~;

# install GNAT community
sudo apt install -y fontconfig dbus libx11-xcb1 libncurses5 libxinerama1 libxrandr2 libxcursor1 libxi6 libxcb-shm0 xcb libxcb-render0;
cd ~/user-bin;
mkdir GNAT2021;
mkdir GNAT2021-ARM-ELF;
git clone https://github.com/AdaCore/gnat_community_install_script;
cd ~/user-bin/gnat_community_install_script;
curl -o gnat2021-bin -L https://community.download.adacore.com/v1/f3a99d283f7b3d07293b2e1d07de00e31e332325?filename=gnat-2021-20210519-x86_64-linux-bin;
./install_package.sh ./gnat2021-bin /user-bin/GNAT2021;

# install GNAT ARM ELF
curl -o gnat2021-armelf-bin -L https://community.download.adacore.com/v1/2ceb9d1ada2029d79556b710c6c4834cade3749f?filename=gnat-2021-20210519-arm-elf-linux64-bin;
./install_package.sh ./gnat2021-armelf-bin /user-bin/GNAT2021-ARM-ELF;
echo "export PATH=$PATH:~/user-bin:~/user-bin/GNAT2021/bin:~/user-bin/GNAT2021-ARM-ELF/bin" >> ~/.bashrc;

# clean up
rm -r ~/user-bin/gnat_community_install_script/;

# install Alire
cd ~/user-bin;
curl -OL https://github.com/alire-project/alire/releases/download/v1.0.1/alr-1.0.1-bin-linux.zip;
unzip alr-1.0.1-bin-linux.zip;
mv ./bin/alr ./alr;
rm LICENSE.txt
rm alr-1.0.1-bin-linux.zip;
rm -r bin;

# clone project repo
cd ~;
RUN git clone https://${3}@github.com/rej696/trains-with-ada.git;
