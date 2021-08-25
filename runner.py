#!/usr/bin/env python3
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

    parser.add_argument(
        "-t",
        "--test",
        action="store_true",
        help="Run the tests stored in the Harness directory"
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
            and not args.clean
            and not args.test):
        print("No arguments given, run python runner.py --help for options")
        sys.exit()

    if args.clean:
        print("Cleaning project directory of artefacts")
        clean_cmd = deepcopy(DOCKER_CMD)
        clean_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/clean.sh"
        ])

        try:
            subprocess.run(
                clean_cmd,
                check=True,
                stdout=subprocess.PIPE,
                stdin=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            print("Clean complete")
        except subprocess.CalledProcessError as error:
            print(error)
            print("Clean failed")

    if args.build_image:
        print("Building pico-ada-builder Docker Image")

        try:
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
            print("pico-ada-builder Image created")
        except subprocess.CalledProcessError as error:
            print(error)
            print("Image build failed")

    if args.build:
        print("Building firmware")
        build_cmd = deepcopy(DOCKER_CMD)
        build_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/build.sh"
        ])

        try:
            subprocess.run(
                build_cmd,
                check=True,
                stdout=subprocess.PIPE,
                stdin=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            print("firmware.uf2 created")
            print("Build complete")
        except subprocess.CalledProcessError as error:
            print(error)
            print("Firmware build failed")

    if args.prove:
        prove_cmd = deepcopy(DOCKER_CMD)
        prove_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/prove.sh",
            args.prove
        ])

        print(f"Running gnatprove on {prove_cmd[-1]}")

        try:
            subprocess.run(
                prove_cmd,
                check=True,
                stdout=subprocess.PIPE,
                stdin=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            print("gnatprove complete, check logs")
        except subprocess.CalledProcessError as error:
            print(error)
            print("gnatprove run failed")

    if args.test:
        print("Building test firmware")
        test_cmd = deepcopy(DOCKER_CMD)
        test_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/test.sh",
        ])

        try:
            subprocess.run(
                test_cmd,
                check=True,
                stdout=subprocess.PIPE,
                stdin=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            print("test_firmware.uf2 created")
            print("Build complete")
        except subprocess.CalledProcessError as error:
            print(error)
            print("Test firmware build failed")

    if args.print_log:
        if args.build:
            with open("logs/build.log", "r") as f:
                print("Build Log:")
                print(f.read())
            with open("logs/build-error.log", "r") as f:
                print("Build Error Log:")
                print(f.read())
        if args.prove:
            with open("logs/prove.log", "r") as f:
                print("Prove Log:")
                print(f.read())
            with open("logs/prove-error.log", "r") as f:
                print("Prove Error Log:")
                print(f.read())
        if args.test:
            with open("logs/test.log", "r") as f:
                print("Test Log:")
                print(f.read())
            with open("logs/test-error.log", "r") as f:
                print("Test Error Log:")
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
        try:
            os.system(f"docker run -it --rm -v {os.getcwd()}:/build {IMAGE} bash")
            print("Interactive container closed")
        except Exception as error:
            print(error)
            print("Interactive container failure")
