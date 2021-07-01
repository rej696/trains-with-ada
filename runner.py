import os
import subprocess
import argparse

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
        default=False,
        help="run gnatprove on specified files, defaults to main.adb"
    )

    args = parser.parse_args()
    args.prove = True if args.prove == [] else args.prove

    docker_cmd = [
        "docker",
        "run",
        "--rm",
        "-it",
        "-v",
        f"{os.getcwd()}:/build",
        "rej696/pico-ada-builder:latest"
    ]

    if args.build:
        print("Building firmware")
        subprocess.run(docker_cmd, capture_output=True, check=True)

    if args.prove:
        print(f"Running gnatprove on {args.prove}")
        docker_cmd.extend([
            "bash",
            "/build/docker/pico-ada-builder/prove.sh"
        ])

        if isinstance(args.prove, list):
            docker_cmd.extend(args.prove)
        
        subprocess.run(docker_cmd, capture_output=True, check=True)

    if not args.prove and not args.build:
        print("No arguments given, run python runner.py --help for options")
