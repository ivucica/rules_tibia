# -*- mode: python; -*-
# vim: set syntax=python:

workspace(name="rules_tibia")

# This is generally a .bzl-only repository to source data files.
#
# The remaining rules below this point are for testing only.

load(":tibia_data.bzl", "tibia_data_repositories")
tibia_data_repositories()

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# From abseil-py's WORKSPACE, but with lowered versions for 6.5.x compat, and rules_cc removed.
http_archive(
    name = "rules_python",
    sha256 = "9f9f3b300a9264e4c77999312ce663be5dee9a56e361a1f6fe7ec60e1beef9a3",
    strip_prefix = "rules_python-1.4.1",
    url = "https://github.com/bazel-contrib/rules_python/releases/download/1.4.1/rules_python-1.4.1.tar.gz",
)

load("@rules_python//python:repositories.bzl", "py_repositories")
py_repositories()

# Next, abseil-py itself.
http_archive(
    name = "io_abseil_py",
    strip_prefix = "abseil-py-2.3.1",
    url = "https://github.com/abseil/abseil-py/archive/v2.3.1.tar.gz",
    sha256 = "cc6d8764c0bdd76cc1308efdb75035d021447974271a83effa7f2616544ee3da",
)


# sh_binary.
http_archive(
    name = "rules_shell",
    sha256 = "410e8ff32e018b9efd2743507e7595c26e2628567c42224411ff533b57d27c28",
    strip_prefix = "rules_shell-0.2.0",
    url = "https://github.com/bazelbuild/rules_shell/releases/download/v0.2.0/rules_shell-v0.2.0.tar.gz",
)

load("@rules_shell//shell:repositories.bzl", "rules_shell_dependencies", "rules_shell_toolchains")
rules_shell_dependencies()
rules_shell_toolchains()
