# Trains with Ada
Make With Ada repository for a model railway signalling system

## Setup

### Docker

#### Installation
You will need docker installed on your machine.

For full instructions regarding the installation of docker, see the [Docker Getting Started Guide](https://www.docker.com/get-started)

You will also need at least 9.9GB of space for the completed docker image/containers

Also install [VSCode](https://code.visualstudio.com/)

When you open this git repo in vscode, you should get a prompt in the bottom right to install the recommended extensions. This will install the "Remote - Containers" extension which will allow us to connect to a docker container that actuall runs our dev environment.

### Running Dev Container
When you first install the "Remote - Containers" extension, or afterwards when you open up VSCode, you should get a prompt in the bottom right to "Reopen in Container". This will start the container, and attach to it.

There are also a number of other commands that can be run with this extension, e.g. rebuilding the container if you make changes to the DOCKERFILE. These can be accessed by hitting Ctrl+Shift+P, and looking for anything that starts "Remote-Containers".


### Build
To build the project, press Ctrl+Shift+B and select "Alire Build".
To generate the UF2 file, press Ctrl+Shift+B and select "ELF to UF2"

Trains_With_Ada/obj/firmware.uf2 should now exist, and is ready for flashing onto your Pico.

Disconnect the pico, press the BOOTSEL button, connect the pico, and then release the BOOTSEL button.

In a file explorer now copy the "firmware.uf2" file onto RPI-RP2.

## Tips

### Alire tips
You can set your environment variables so that normal gnat tools know about the alire dependencies by running:
```
eval $(alr printenv --unix)
```

### Docker tips
```
docker images
docker container ls
docker container start <container name>
docker container stop <container name>
docker inspect <container name>
```

## Links
- [Play with Docker Tutorial](https://training.play-with-docker.com/)
- [Docker Docs](https://docs.docker.com/)
- [Github Personal Access Tokens](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [VNC server setup](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)

