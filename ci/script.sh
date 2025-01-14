#!/bin/sh

set -ex

if [[ "$TRAVIS_RUST_ARCHITECTURE" == "i386" ]]; then
  apt-get update
  apt-get install -y gcc-multilib
  rustup target add i686-unknown-linux-gnu
fi

cargo build --verbose
cargo doc --verbose

# If we're testing on an older version of Rust, then only check that we
# can build the crate. This is because the dev dependencies might be updated
# more frequently, and therefore might require a newer version of Rust.
#
# This isn't ideal. It's a compromise.
if [ "$TRAVIS_RUST_VERSION" = "1.21.0" ]; then
  exit
fi

cargo test --verbose
if [ "$TRAVIS_RUST_VERSION" = "nightly" ]; then
  cargo bench --verbose --no-run
fi
