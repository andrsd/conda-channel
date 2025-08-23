#!/usr/bin/env bash

set -x

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat

if [[ $(uname) == "Linux" ]]; then
    export CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER="x86_64-conda-linux-gnu-cc"
fi

cargo install --no-track --locked --root ${PREFIX} --path cargo-auditable
cargo-bundle-licenses --format yaml --output ${SRC_DIR}/THIRDPARTY.yml
