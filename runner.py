"""Python script for running the GNAT toolchain in docker containers"""

import os
import sys
import subprocess
import argparse

from copy import deepcopy

IMAGE = "rej696/pico-ada-builder:latest"
DOCKER_CMD = [
    "docker",
    "run",
    "--rm",
    "-v",
    f"{os.getcwd()}:/build",
    IMAGE
]

if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="""Tool for managing execution of SPARK/Ada tools using Docker:
          - Build uf2 firmware for Raspberry Pi Pico from SPARK/Ada code
          - Run GNATprove on specified SPARK file"""
    )

    parser.add_argument(
        "-b",
        "--build",
        action="store_true",
        help="flag for building pico firmware from ada project"
    )

    parser.add_argument(
        "-p",
        "--prove",
        nargs="*",
        default="",
        help="run gnatprove on specified file"
    )

    parser.add_argument(
        "--build_image",
        action="store_true",
        help="build the pico-ada-builder docker image from the dockerfile"
    )

    parser.add_argument(
        "-i",
        "--interactive",
        action="store_true",
        help="Run a docker interactive shell for the pico-ada-builder image"
    )

    parser.add_argument(
        "-l",
        "--print_log",
        action="store_true",
        help="Print the log to the stdout after running a build/prove command"
    )

    parser.add_argument(
        "-c",
        "--clean",
        action="store_true",
        help="Clean the project directory of all build artefacts and logs"
    )

    args = parser.parse_args()
    args.prove = "main.adb" if args.prove == [] else args.prove
    if isinstance(args.prove, list):
        if len(args.prove) > 1:
            print("Only one file can be selected for the --prove option")
            sys.exit()
        else:
            args.prove = args.prove[0]

    if (not args.build
            and not args.build_image
            and not args.prove
            and not args.interactive
            and not args.print_log
            and not args.clean):
        print("No arguments given, run python runner.py --help for options")
        sys.exit()

    if args.build_image:
        print("Building pico-ada-builder Docker Image")
        subprocess.run(
            ["docker",
             "build",
             "-t",
             IMAGE,
             "docker/pico-ada-builder/"],
            check=True,
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE
        )
        print("pico-ada-builder Image Created")

    if args.build:
        print("Building firmware")
        subprocess.run(
            DOCKER_CMD,
            check=True,
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print("Build complete")

    if args.prove:
        prove_cmd = deepcopy(DOCKER_CMD)
        prove_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/prove.sh",
            args.prove
        ])

        print(f"Running gnatprove on {prove_cmd[-1]}")

        subprocess.run(
            prove_cmd,
            check=True,
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print("gnatprove complete, output in logs/prove.log")

    if args.print_log:
        if args.prove:
            with open("logs/prove.log", "r") as f:
                print(f.read())
        else:
            with open("logs/build.log", "r") as f:
                print(f.read())

    if args.interactive:
        print("Opening interactive container")
#         pty, tty = pty.openpty()
#         subprocess.run(
#             ["docker",
#              "run",
#              "-it",
#              "--rm",
#              "-v",
#              f"{os.getcwd()}:/build",
#              IMAGE,
#              "bash"],
#             check=True,
#             stdout=subprocess.PIPE,
#             stdin=subprocess.PIPE,
#             stderr=subprocess.PIPE,
#             shell=True
#         )
        os.system(f"docker run -it --rm -v {os.getcwd()}:/build {IMAGE} bash")
        print("Interactive container closed")

    if args.clean:
        print("Cleaning project directory of artefacts")
        clean_cmd = deepcopy(DOCKER_CMD)
        clean_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/prove.sh"
        ])

        subprocess.run(
            clean_cmd,
            check=True,
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print("Clean complete")
