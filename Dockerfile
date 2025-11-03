# ---- Build Stage ----
FROM rust:1.80-slim-bookworm AS builder

# Create a new empty shell project
RUN USER=root cargo new --bin app
WORKDIR /app

# Install dependencies required for building
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libssl-dev \
    pkg-config \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the manifest files
COPY Cargo.toml Cargo.lock ./

# Fetch dependencies (this will be cached unless the Cargo.toml changes)
RUN cargo build --release && \
    rm src/*.rs

# Copy the actual source code
COPY ./src ./src

# Build the application
RUN cargo build --release

# ---- Runtime Stage ----
FROM debian:bookworm-slim AS runtime

# Install needed packages (e.g. for TLS)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/target/release/teloxide-on-fly-io .

# Run the application
CMD ["./teloxide-on-fly-io"]
