# zenohc_builder

This library is used to build and release zenoh-c and zenoh-cpp headers and libraries.

Run it with `./run.sh`. It will:
* Create docker image with all the required dependencies
* Start it and run `./build_zenoh.sh`

To update the zenoh version open `build_zenoh.sh` and change `VERSION` variable.
