# Trains with Ada
Make With Ada repository for a model railway signalling system

Competition now called [Ada/SPARK Crate Of The Year](https://blog.adacore.com/announcing-the-first-ada-spark-crate-of-the-year-award)

## Instructions
The project includes a `runner.py` python script which runs docker commands.

### Running the Script
There are various options that are explained if you run `python3 runner.py --help`.

#### Building Firmware
`python3 runner.py -b` will build a firmware.uf2 file ready to be flashed to the pico, and place it at the top of the project directory structure.

You can then drag and drop the firmware onto the pi pico

#### Running Spark Prover
`python3 runner.py -p <filename>` will run gnatprove on the given file. If no filename is stated, this defaults to `main.adb`.

### Logs
Outputs from building and proving the project with the python runner tool are stored in the `logs` directory.

These logs are overwritten each time the appropriate command is run.

You can show the contents of the log in your terminal using the `-l` option
```
python3 runner.py -l
```

### Tests
To create tests, write test code in the `Harness/tests/` directory

This project can call functions, packages and procedures from the `Trains_With_Ada` project.

To build the test harness Pico Firmware run
```
python3 runner.py -t
```
This wil create a `test_firmware.uf2` file that can be loaded onto the Pico.

The output of the tests are sent as strings using the `Send_String` and `Echo` procedures using the UART interface on GPIO pins 16 (TX) and 17 (RX).

You can read these output strings using a second Raspberry Pi Pico that has the [Pico UART-USB bridge Firmware](https://github.com/Noltari/pico-uart-bridge/releases/tag/v2.1) firmware installed.

This "Bridge Pico" must be connected to a Computer via USB that has a Serial console installed, such as [Minicom](https://wiki.emacinc.com/wiki/Getting_Started_With_Minicom) or [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)

The "Test Pico" must be connected to the "Bridge Pico" as follows:
| Test Pico | Bridge Pico |
| -- | -- | -- |
| GPIO 16 (TX) | GPIO 1 (RX) |
| GPIO 17 (RX) | GPIO 0 (TX) |

## Dependencies
Install your favourite text editor/IDE. If you wish to use GNATStudio, see the GNATCommunity and Alire section

### Install Docker
You will need docker installed on your machine to build the Raspberry Pi Pico firmware from the Ada project.

For full instructions regarding the installation of docker, see the [Docker Getting Started Guide](https://www.docker.com/get-started)

You will also need at least 15GB of space for the completed docker image/containers

### Install Python3
If you wish to use the python `runner.py` tool, you will need python3 installed locally.

If you are using linux, you can install python3 using your package manager
```
apt install python3
```

Alternatively, you can download and install it from the [python website](https://www.python.org/downloads/)

### GNATCommunity and Alire (OPTIONAL)
You can install GNATStudio on your local machine if you wish to use it as an IDE for writing your SPARK/Ada code.
To use GNATStudio with the project, you will also need to install [Alire](https://alire.ada.dev/).

Alire is a package manager for Ada/SPARK, and we need it installed to include the Pico_BSP libraries we use.

Note that if you are using another IDE/Text editor, like VSCode or Vim, you do not need to install GNAT Community or Alire; all the `runner.py` commands use docker containers.

#### Installation
For Mac and Linux there are install scripts for setting up GNAT Community and Alire (in addition to the rest of the toolchain) in the `setup` directory.
```
bash /setup/setup_permissions.sh
./setup/setup.sh
```

Alternatively, you can download GNAT Community and Alire from [the AdaCore Website](https://www.adacore.com/download/more) and [the Alire Website](https://alire.ada.dev/docs/#installation).

Both of these include comprehensive installation instructions.

## Tips

### Docker tips
```
docker images                           // list images either built locally or pulled from docker hub
docker container ls                     // list running containers
docker container ls -a                  // list all containers
docker container start <container name> // start a stopped container
docker container stop <container name>  // stop a running container
docker inspect <container name>         // view configuration information about a container
docker conatiner prune                  // remove unused containers
```

## Links
- [Play with Docker Tutorial](https://training.play-with-docker.com/)
- [Docker Docs](https://docs.docker.com/)
- [TLDR;Docker](https://github.com/tldr-pages/tldr/blob/master/pages/common/docker.md)
- [Alire](https://alire.ada.dev/)
- [Learn Ada](https://learn.adacore.com/)
