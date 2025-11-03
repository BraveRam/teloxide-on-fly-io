# ---- Build Stage ----
FROM rust:1.80-slim-bookworm AS builder

WORKDIR /app

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libssl-dev \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the manifest only
COPY Cargo.toml ./

# Fetch dependencies and generate Cargo.lock (no source code yet)
RUN cargo fetch

# Now copy the source code
COPY ./src ./src

# Build the application
RUN cargo build --release
