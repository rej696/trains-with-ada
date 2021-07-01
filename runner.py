import os
import sys
import subprocess
import argparse

IMAGE = "rej696/pico-ada-builder:latest"

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
            and not args.print_log):
        print("No arguments given, run python runner.py --help for options")
        sys.exit()

    docker_cmd = [
        "docker",
        "run",
        "--rm",
        "-v",
        f"{os.getcwd()}:/build",
        IMAGE
    ]

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
            docker_cmd,
            check=True,
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        print("Build complete")

    if args.prove:
        docker_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/prove.sh",
            args.prove
        ])
        
        print(f"Running gnatprove on {docker_cmd[-1]}")

        subprocess.run(
            docker_cmd,
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
