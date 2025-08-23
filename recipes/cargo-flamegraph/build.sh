#!/usr/bin/env bash

set -x

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ $(uname) == "Linux" ]]; then
    export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER="x86_64-conda-linux-gnu-cc"
fi

cargo auditable install --locked --no-track --bins --root ${PREFIX} --path .
cargo-bundle-licenses --format yaml --output ./THIRDPARTY.yml
