# -*- mode: python; -*-
# vim: set syntax=python:

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def tibia_data_repository(version):
    if version == 854:
        http_archive(
            name = "tibia854",
            url = (
                "https://badc0de.net/UNSTABLE_TEMPORARY_URL/tibia854.tgz?" +
                "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
            ),
            sha256 = "3d897c233226586d86f5a33941ac3b62b3aa001b8e563c574a4a860320d7a865",
            type = "tar.gz",
            strip_prefix = "Tibia/",
            build_file_content = (
                "exports_files(['Tibia.pic', 'Tibia.spr', 'Tibia.dat'])"
            )
        )
    else:
        print("Unknown Tibia version; downloading without sha256 check")
        http_archive(
            name = "tibia%d" % version,
            url = (
                "https://remeresmapeditor.com/rmedl.php?file=tibia%d.tgz&" +
                "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
            ),
            type = "tar.gz",
            strip_prefix = "Tibia/",
            build_file_content = (
                "exports_files(['Tibia.pic', 'Tibia.spr', 'Tibia.dat'])"
            )
        )

