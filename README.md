# Trains with Ada
Make With Ada repository for a model railway signalling system


## Setup

### VNC
On your local machine you will need to install a VNC client. This is so that you can view GNATstudio through the docker container.

On linux, I have been using Remmina. I used TeamViewer on ATC2 system test and that was adequate. You could also try the chrome extention that allows you to use chrome as a VNC viewer.

### Docker

#### Installation
You will need docker installed on your machine.

For full instructions regarding the installation of docker, see the [Docker Getting Started Guide](https://www.docker.com/get-started)

You will also need at least 15GB of space for the completed docker image/containers

#### Running
To build the docker environment from the Dockerfile, navigate into the directory with the Dockerfile and run the following:
```
docker build --build-arg GIT_USER_NAME "<your github username>" --build-arg GIT_USER_EMAIL "<your github email>" --build-arg GITHUB_TOKEN "<you github user token>" -t trains-with-ada:v1 .
```
You need to include your github username, github email address and a github authentication token so that docker can set up your details in the image and clone the trains with ada repository.

To generate a GITHUB_TOKEN, go to https://github.com/settings/tokens and click generate new token. Copy the generated token and store it in a file or write it down, then use it in the docker build command.

The above command will create a docker image which can be used to create a container with the following command:

```
docker container run -it -p 5900:5900 --name=<name for container, e.g. twaenv> -d trains-with-ada:v1
```

This will start the docker container. It will start an interactive terminal into the container window which should contain the project directory.

If you exit the interactive terminal, run the following to re-establish it
```
docker container exec -it <contianer-name> bash
```

At this point you have an interactive terminal where you can run git commands and edit files using vim or nano, but no gnatstudio window. gnatstudio is being beamed out of the container on port 5900 using VNC.

You need to find the IP address of the container in order to connect to it using your VNC viewer. Run the following on your host machine (not the container terminal):
```
docker inspect <container-name>
```

This will produce a JSON full of configuration information. The IP address of the container should be near the bottom.

Now connect to `<IP address>:5900` using your VNC viewer, and you should see an instance of the project in GNATstudio open!


### Build
To build the project and get an uf2 firmware, you must run the following in the docker interactive terminal
```
cd ~/trains-with-ada
alr build
elf2uf2 ./Trains_With_Ada/obj/main ./firmware.uf2
```

You must then copy the firmware file from the docker container to your local machine for flashing onto your Pico.

On your local machine terminal run the following commands
```
docker cp <container name>:/root/trains-with-ada/firmware.uf2 </path/to/pico>
```
Now you have the .uf2 file on your host machine, you can flash the Pico!!


## Links
[Play with Docker Tutorial](https://training.play-with-docker.com/)
[Docker Docs](https://docs.docker.com/)
[Github Personal Access Tokens](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token)
[VNC server setup](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)

