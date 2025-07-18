# -*- mode: python; -*-
# vim: set syntax=python:

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# This is a magic string expanded by `git archive`, as set by `.gitattributes`
# See https://git-scm.com/docs/git-archive/2.29.0#Documentation/git-archive.txt-export-subst
_VERSION_PRIVATE = "$Format:%(describe:tags=true)$"

KNOWN_VERSIONS = {
    790: "f78855ec906f163b4e6e3a12d463e781f010b2d6df0ee58dde9926b2a1e8274c",
    791: "c80674b773cbb4bcf0410f1876ca4ebe0f56724fc08cde0da8b935222d77d63f",
    792: "088f5e9926025ee84180f5e837c9cdf9563cb262e0c10650dd248d64d0e431ab",
    800: "c0899cf138b07063c49db75c5df63d262b1686f4f6665b04a7fc725be5c760cb",
    810: "5d09e9985e44faa4fa60b138b12d5e503f4db6e3ab6ea26c7331b043eb952923",
    811: "5147ae8732f795747789d1ca84333b73f37afea59e1d1388db95db15cbffa0c2",
    822: "a16258fa7d57695c2abc9f0991e9d81b50d05595669cf349b110eb23a812bb3b",
    830: "1bd05aef9e4800d5680bd9142e3137ec0d1a9947879865a67585b8507a986942",
    831: "68c438fa4b06f1a32f8b3084e03f3e452695662dd78567e02bd944a9fe54cc98",
    840: "4cbe83f45052490bed54f22deccead334741c22a7676847183639fe75a29d637",
    841: "63b5f6e369654c82c478cb9ad44d6109d5e73fb071e27003fd8b1980420a022c",
    842: "a4345aab7c0d94602de8ee229148634f7d68383dc7ccbe163d1f7d2df19b182a",
    850: "976921dec520d027da09d1045ce19cfce8d9c10366c1f3bd0e02c6f79fb9c077",
    852: "9f31b5a07e3895ac53a105785d173e231cb3acdd7cc2a710bd132bf9f0de9a1e",
    853: "081ed5cdb0eea477ba91350178a892f72b959b63ac6fcef8e399cb7d4318662e",
    854: "3d897c233226586d86f5a33941ac3b62b3aa001b8e563c574a4a860320d7a865",
    860: "68b787c1a1cca1c6f95b16de81b1433bc908bbd8cb84aa357a34845bb35acdf7",
    861: "3baf990be00c98e31897ac81adee3cb1b9ff29817422300339cb6dc8d8f3734b",
    900: "9f0207e3b66c4f5a6363982a66ac4581ffcf4a02ca8eed3224f26dc3690ccf52",
    910: "97f6746b6eb6cadad9b7dcd52a38e0f3f1f547a4913145e16174acbeff2445a0",
    920: "c68e9f6e03bc4069a5a640ffb3a7b0671e957e4375fe4de53fe61d4c4f12c76b",
    931: "ac2df36ca265691dcb3aa9914681c6fd204740ea1fb05bc4650d837cf2388bed",
    946: "5e60c0f24e1bddf72595a6a7e6f8343fc1586f05761d3fd387aa74df8d52cc05",
    954: "872a73910da143930039c5a08563b12ddfe6df1226ff9b4b220223e89d8335bf",
    960: "c9412aaff24fa15264f0846f6dea602bdfce93d4a64fb5ee2f4675e6363f7e6d",
}

# IPFS CIDs for tarballs for each version.
KNOWN_CIDS = {
    854: "QmQuHvyHCetUsZYT7ZDmPdCHHWgFgHNzNTW7jxQ96azrvV",
}

# Extra mirrors per version.
KNOWN_MIRRORS = {
    854: ["https://badc0de.net/UNSTABLE_TEMPORARY_URL/tibia854.tgz"],
}


def tibia_data_repositories():
    """Create repos for all versions with known SHA256 hashes."""
    for version in KNOWN_VERSIONS:
        tibia_data_repository(version)


def tibia_data_repository(version):
    """Create a Bazel repo from a downloaded Linux version's tarball.

    Passed version should be a number, not a string.

    Any Windows installers are not unpacked; this would be doable with a tool
    such as innoextract, which ships in Debian, but is not currently
    implemented.
    """
    if version in KNOWN_VERSIONS:
        sha256 = KNOWN_VERSIONS[version]
    else:
        sha256 = None
        print("Unknown Tibia version; downloading without sha256 check")
        # n.b. Plain HTTP URLs won't work without a checksum.
    urls = [
        (
            "http://remere.clients.archive.tibia.badc0de.net/tibia%d.tgz?" +
            "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
        ) % version,
        (
            "http://archive.tibia.badc0de.net/tibia/clients/tibia-clients-remere/tibia%d.tgz?" +
            "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
        ) % version,
        (
            "http://proxy.ipfs.badc0de.net/ipns/remere.clients.archive.tibia.badc0de.net/tibia%d.tgz?" +
            "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
        ) % version,
    ]
    if version in KNOWN_CIDS:
        cid = KNOWN_CIDS[version]
        urls.extend([
            (
                "http://proxy.ipfs.badc0de.net/ipfs/" + cid + "?" +
                "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
            ),
            (
                "https://cloudflare-ipfs.com/ipfs/" + cid + "?" +
                "agent=bazel+rule,+see+github.com/ivucica/rules_tibia"
            ),
        ])
    if version in KNOWN_MIRRORS:
        urls.extend(["%s?agent=bazel+rule,see+github.com/ivucica/rules_tibia" % u for u in KNOWN_MIRRORS[version]])
    http_archive(
        name = "tibia%d" % version,
        urls = urls,
        sha256 = sha256,
        type = "tar.gz",
        strip_prefix = "Tibia/",
        build_file_content = "\n".join([
            "exports_files(['Tibia.pic', 'Tibia.spr', 'Tibia.dat'])",
            "filegroup(name='data', visibility=['//visibility:public'], data=['Tibia.pic', 'Tibia.spr', 'Tibia.dat'])",
        ])
    )

