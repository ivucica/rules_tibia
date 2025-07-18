# -*- mode: python; -*-
# vim: set syntax=python:

"""verify takes in the version and checks if the assets are present in runfiles.

    Only the existence of the files will be checked at this time.

    USAGE: %s [flags] VERSION
      where VERSION is a number such as 854.
"""
import os
from python.runfiles import Runfiles
from absl import app

def verify_tibia_assets(version: int):
    """Verify that all Tibia assets for a version are accessible."""
    r = Runfiles.Create()

    assets = ['Tibia.dat', 'Tibia.spr', 'Tibia.pic']
    for asset in assets:
        path = r.Rlocation(f"tibia{version}/{asset}")
        if not path or not os.path.exists(path):
            raise FileNotFoundError(f"Asset {asset} not found for version {version}")
        print(f"✓ {asset}: {os.path.getsize(path)} bytes")


def main(argv):
    if len(argv) > 2:
        raise app.UsageError('Too many command-line arguments.')
    if len(argv) <= 1:
        raise app.UsageError('Must pass version.')

    version: int = int(argv[1])
    verify_tibia_assets(version)


if __name__ == '__main__':
    app.run(main)
