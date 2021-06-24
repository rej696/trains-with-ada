# trains-with-ada
Make with ada code for model railway signalling system


## Setup

### VNC
on your local machine you will need to install a VNC client. This is so that you can view gnatstudio through the docker container.

On linux, I have been using Remmina. I used TeamViewer on ATC2 system test and that was adequate. You could also try the chrome extention that allows you to use chrome as a VNC viewer.

### Docker

#### Installation
You will need docker installed on your machine.

For full instructions regarding the installation of docker, see the [Docker Getting Started Guide](https://www.docker.com/get-started)

#### Running
To build the docker environment from the Dockerfile, navigate into the directory with the Dockerfile and run the following:
```
docker build -t trains-with-ada:v1 .
```

This will create a docker image which can be used to create a container with the following command:

```
docker container run -it -p 5900:5900 -e GIT_USER_NAME="<github username>" -e GIT_USER_EMAIL="<github user email>" --name=<name for container, e.g. twaenv> -d trains-with-ada:v1
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


[VNC server setup](https://www.cloudsavvyit.com/10520/how-to-run-gui-applications-in-a-docker-container/)

