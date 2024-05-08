# To update version of compiler

1. Identify build number for the compiler available at conda channel `intel`:

```bash
conda search -c intel --override-channel dpcpp-cpp-rt=<version> --subdir=win-64 --override-channels
conda search -c intel --override-channel dpcpp-cpp-rt=<version> --subdir=linux-64 --override-channels
```

Using these numbers to set `intel_build_num` jinja variables in `meta.yaml` for respective platforms.

2. Get full info about compiler packages:

```bash
conda search -c intel --override-channel dpcpp_impl_win-64=<version>=intel_<win_build_num> --subdir=win-64 --info
conda search -c intel --override-channel dpcpp_impl_linux-64=<version>=intel_<lin_build_num> --subdir=linux-64 --info
```

Use `md5` entries from the info output and copy them to the `meta.yaml`'s "`source`" section.
