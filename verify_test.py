# -*- mode: python; -*-
# vim: set syntax=python:

from absl.testing import absltest
from absl import flags
from rules_tibia import verify
import os


def remove_suffix(input_string, suffix):
    """Implement str.removesuffix where Python 3.9 is not available."""
    if suffix and input_string.endswith(suffix):
        return input_string[:-len(suffix)]
    return input_string


def remove_prefix(input_string, prefix):
    """Implement str.removeprefix where Python 3.9 is not available."""
    if prefix and input_string.startswith(prefix):
       return input_string[len(prefix):]
    return prefix


class Verify(absltest.TestCase):
    def testVerify(self):
        # determine version from target name
        tgt = os.environ.get("TEST_TARGET", None)
        self.assertIsNotNone(tgt)
        ver = int(remove_prefix(remove_suffix(tgt, "_test"), "//:verify"))

        verify.verify_tibia_assets(ver)


if __name__ == '__main__':
    absltest.main()
