# Docker image for Barrelfish OS build tools

This repository contains Docker image for building and running
[Barrelfish OS](http://barrelfish.org) locally.

## Bootstrapping container

First of all, the image has to be built or fetched from
[hub.docker.org](https://registry.hub.docker.com/u/brb0/barrelfish/)
with `make build` or `make pull` respectively.

Next, a container has to be created from the image.
`make create SRC_PATH=... BUILD_PATH=...` will do the job. `SRC_PATH`
corresponds to Barrelfish OS source tree and `BUILD_PATH` to a directory which
will contain build artifacts on local machine.

Finally, `make start` will open a terminal from which the OS can be compiled
and run.

## Compiling and running

In order to compile the OS for the first time, the following commands need to
be executed after entering the terminal:

* `cd /barrelfish_build && /barrelfish_src/hake/hake.sh -s /barrelfish_src -a x86_64`
* `cd /barrelfish_build && make -j4`

Afterwards, launching the OS via `qemu` can be done by
`cd /barrelfish_build && make sim`.

For further details please refer to [an official Barrelfish
README file](http://git.barrelfish.org/?p=barrelfish;a=blob;f=README;hb=HEAD).
