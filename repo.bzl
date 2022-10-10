windows_build_file_content = """
alias(
    name = "doxyrest",
    visibility = ["//visibility:public"],
    actual = "{doxyrest_VERSION}/bin/doxyrest.exe",
)
"""

linux_build_file_content = """
alias(
    name = "doxyrest",
    visibility = ["//visibility:public"],
    actual = "{doxyrest_VERSION}/bin/doxyrest",
)
"""

_known_archives = {
    "2.1.3": {
        "windows64": struct(
            urls = [
                "https://github.com/Zeratul-Aiur/rules_doxyrest/releases/download/v0.3.0/doxyrest-2.1.3-windows-amd64.zip",
            ],
            strip_prefix = "doxyrest-2.1.3-windows-amd64",
            sha256 = "571172ad7520f920abeaea58c181448b2db3f9bb64853b236259f81dea5965e9",
            build_file_content = windows_build_file_content,
        ),
        "linux64": struct(
            urls = [
                "https://github.com/Zeratul-Aiur/rules_doxyrest/releases/download/v0.3.0/doxyrest-2.1.3-linux-amd64.tar.gz",
            ],
            strip_prefix = "doxyrest-2.1.3-linux-amd64",
            sha256 = "12f1dfbcdf6d4e2f78f6ed3fd15ce7aeaa7b11212298c4363d8ae4de4ce96696",
            build_file_content = linux_build_file_content,
        ),
    },
}

def _os_key(os):
    if os.name.lower().startswith("windows"):
        return "windows64"
    elif os.name.startswith("linux"):
        return "linux64"
    return os.name

def _get_doxyrest_archive(rctx):
    doxyrest_version = rctx.attr.doxyrest_version
    archives = _known_archives.get(doxyrest_version)

    if not archives:
        fail("rules_doxyrest unsupported doxyrest_version: {}".format(doxyrest_version))

    archive = archives.get(_os_key(rctx.os))

    if not archive:
        fail("rules_doxyrest unknown doxyrest version / operating system combo: doxyrest_version = {} os = {}".format(doxyrest_version, rctx.os.name))

    return archive

def _doxyrest_repository(rctx):
    archive = _get_doxyrest_archive(rctx)
    rctx.download_and_extract(archive.urls, output = rctx.attr.doxyrest_version, stripPrefix = archive.strip_prefix, sha256 = archive.sha256)
    rctx.file("BUILD.bazel", archive.build_file_content.format(doxyrest_VERSION = rctx.attr.doxyrest_version), executable = False)

doxyrest_repository = repository_rule(
    implementation = _doxyrest_repository,
    attrs = {
        "doxyrest_version": attr.string(
            default = "2.1.3",
            values = _known_archives.keys(),
        ),
    },
)
