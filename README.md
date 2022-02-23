# rules_doxyrest

Bazel rules for running doxyrest.

## Install

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_doxyrest",
    # See release page for latest version url and sha.
)

load("@rules_doxyrest//:repo.bzl", "doxyrest_repository")

doxyrest_repository(name = "doxyrest")
```

## Usage

Adjust the settings in your Doxyrest configuration file `doxyrest-config.lua`.Then run doxyrest.

```sh
bazel run @doxyrest//:doxyrest -- -c doxyrest-config.lua
```

## LICENSE

MIT
