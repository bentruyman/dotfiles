#!/usr/bin/env bash
set -euo pipefail

# Build the test image, then run setup.sh inside a container so we exercise
# the actual provisioning flow (CMD is ./setup.sh).
docker build -f Dockerfile.test -t dotfiles-test --progress=plain .
docker run --rm -it dotfiles-test
