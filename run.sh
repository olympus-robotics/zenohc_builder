#!/bin/bash

docker build docker -f Dockerfile --tag zenohc_builder

docker run --rm -v $(pwd):/workspace -w /workspace/ zenohc_builder ./build_zenoh.sh
