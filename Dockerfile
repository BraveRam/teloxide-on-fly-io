# ---- Build Stage ----
FROM rust:1.80-slim-bookworm AS builder

WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libssl-dev pkg-config ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the full source tree including Cargo.toml and src/
COPY . .

# Build the application
RUN cargo build --release

# ---- Runtime Stage ----
FROM debian:bookworm-slim AS runtime

WORKDIR /app

# Needed for TLS
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy binary from build stage
COPY --from=builder /app/target/release/teloxide-on-fly-io .

# Run the binary
CMD ["./teloxide-on-fly-io"]
