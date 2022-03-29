FROM rust:1.59-bullseye as builder

RUN apt-get update \
    && apt-get install -y git virtualenv \
    && rm -rf /var/lib/apt/lists/*

WORKDIR build

RUN git clone --depth 1 https://github.com/esp-rs/rust-build \
    && cd rust-build  \
    && ./install-rust-toolchain.sh \
    && cd .. \
    && rm -rf rust-build

RUN rustup default esp

ENV PATH="/root/.espressif/tools/xtensa-esp32-elf-clang/esp-13.0.0-20211203-x86_64-unknown-linux-gnu/bin/:$PATH"
ENV LIBCLANG_PATH="/root/.espressif/tools/xtensa-esp32-elf-clang/esp-13.0.0-20211203-x86_64-unknown-linux-gnu/lib/"
ENV PIP_USER=no

ENV RUST_ESP32_STD_DEMO_WIFI_SSID=secret
ENV RUST_ESP32_STD_DEMO_WIFI_PASS=secret

ADD . ./
RUN cargo build --features="native"
