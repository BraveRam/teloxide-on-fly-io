# Builder stage
FROM rust:1.86-slim-bookworm AS builder
WORKDIR /app

# Install dependencies for building
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libssl-dev pkg-config ca-certificates git && \
    rm -rf /var/lib/apt/lists/*

# Copy source code
COPY . .

# Build release binary
RUN cargo build --release

# Runtime stage
FROM debian:bookworm-slim
WORKDIR /app

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy binary from builder
COPY --from=builder /app/target/release/<your-binary-name> .

# Run the app
CMD ["./teloxide-on-fly-io"]
