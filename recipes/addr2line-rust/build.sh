#!/usr/bin/env bash

set -x

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

cargo auditable install --locked --no-track --bins --root ${PREFIX} --path .
cargo-bundle-licenses --format yaml --output ./THIRDPARTY.yml
