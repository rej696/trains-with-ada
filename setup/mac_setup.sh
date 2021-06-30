#!/bin/bash
# Install script for installing GNAT and Alire on Mac OS
# 
# Dependencies:
# - You need Xcode version 10 or above to be installed for GNAT to work
# From the GNAT README:
#   == Mac OS: Xcode is now needed ==
#
#   On Mac OS, GNAT Community 2020 requires Xcode version 10 or above to be installed.
#
#   The executables are not codesigned, so we suggest doing the following:
#     - open the Preferences dialog, section "Security & Privacy",
#       in the "Privacy" tab,
#     - in the list on the left, select "Developer Tools"
#     - in the pane on the right which add the app "Terminal"
#   This will allow you to run the compiler and tools from the Terminal, without having to go through confirmation dialogs for each.
#
#   If you observe an error of the form:
#     ld: library not found for -lSystem
#   then you might have to execute the following:
#     xcode-select -s /Applications/Xcode.app/Contents/Developer


# install GNAT community
cd $HOME;
mkdir GNAT2021;
git clone https://github.com/AdaCore/gnat_community_install_script;
cd ~/gnat_community_install_script;
curl -o gnat2021-bin -L https://community.download.adacore.com/v1/aefa0616b9476874823a7974d3dd969ac13dfe3a?filename=gnat-2020-20200818-x86_64-darwin-bin.dmg;
./install_package.sh ./gnat2021-bin ~/GNAT2021;

# install GNAT ARM ELF
echo "export PATH=$PATH:~/user-bin:~/GNAT2021/bin" >> ~/.bashrc;

# clean up
rm -r ~/user-bin/gnat_community_install_script/;

# install Alire
mkdir ~/user-bin;
cd ~/user-bin;
curl -OL https://github.com/alire-project/alire/releases/download/v1.0.1/alr-1.0.1-bin-linux.zip;
unzip alr-1.0.1-bin-linux.zip;
mv ./bin/alr ./alr;
rm LICENSE.txt
rm alr-1.0.1-bin-linux.zip;
rm -r bin;
